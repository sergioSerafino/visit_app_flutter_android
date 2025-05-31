// lib/presentation/pages/episode_detail_page.dart
// Detailansicht einer Episode
/*
✅ Ready für:
    Wireframes
    Flutter-Routenstruktur
    Zustandslogik (Riverpod)
    Services (Audio, Registry, Merge)
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../application/providers/audio_player_provider.dart';
import '../../application/providers/cast_airplay_provider.dart';
import '../widgets/cast_airplay_button.dart';
import '../../core/services/audio_player_bloc.dart';
import '../widgets/cover_image_widget.dart';
import '../widgets/sticky_info_header.dart';
import '../widgets/bottom_player_widget.dart';

class EpisodeDetailPage extends StatefulWidget {
  final PodcastEpisode episode;
  final String trackName;
  // final String formattedTrackName;

  const EpisodeDetailPage({
    super.key,
    required this.episode,
    required this.trackName,
  });

  @override
  State<EpisodeDetailPage> createState() => _EpisodeDetailPageState();
}

class _EpisodeDetailPageState extends State<EpisodeDetailPage> {
  late final ScrollController _scrollController;
  double _titleOpacity = 0.0; // AppBar-Titel
  double _bigTitleOpacity = 1.0; // Großer Titel unter dem Bild

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    const fadeStart = 180.0;
    const fadeEnd = 250.0;

    final offset = _scrollController.offset;
    final newOpacity = ((offset - fadeStart) / (fadeEnd - fadeStart)).clamp(
      0.0,
      1.0,
    );
    final newBigTitleOpacity = 1.0 - newOpacity;

    if (_titleOpacity != newOpacity || _bigTitleOpacity != newBigTitleOpacity) {
      setState(() {
        _titleOpacity = newOpacity;
        _bigTitleOpacity = newBigTitleOpacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String displayTitle = _formatTitle(widget.trackName);
    // Riverpod Consumer für Player- und Cast-Status
    return Consumer(
      builder: (context, ref, _) {
        final audioBloc = ref.watch(audioPlayerBlocProvider);
        final audioState = ref
            .watch(audioPlayerStateProvider)
            .maybeWhen(data: (state) => state, orElse: () => null);
        final position = (audioState is Playing || audioState is Paused)
            ? (audioState as dynamic).position as Duration
            : Duration.zero;
        final duration = (audioState is Playing || audioState is Paused)
            ? (audioState as dynamic).duration as Duration
            : const Duration(seconds: 100);
        final devices = ref.watch(castDevicesProvider);
        final connectedDevice = ref.watch(connectedCastDeviceProvider);
        final isAvailable = devices.isNotEmpty;
        final isConnected = connectedDevice != null;
        final statusText = isConnected
            ? 'Verbunden mit ${connectedDevice.name}'
            : (isAvailable ? 'Mit Gerät verbinden' : 'Kein Gerät gefunden');
        final service = ref.watch(castAirPlayServiceProvider);

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 280,
                    title: Opacity(
                      opacity: _titleOpacity,
                      child: Text(
                        displayTitle,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          // Hintergrund-Verlauf
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(0, 0, 0, 0),
                                  Colors.black45,
                                ],
                                stops: [0.35, 0.85],
                              ),
                            ),
                          ),

                          // Cover-Bild zentriert
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 32,
                              ), // leicht nach oben versetzt
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.025,
                                    ),
                                    blurRadius: 1,
                                    offset: const Offset(3, 10),
                                  ),
                                ],
                              ),
                              child: CoverImageWidget(
                                imageUrl: widget.episode.artworkUrl600,
                                scaleFactor: 0.5,
                                showLabel: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Großer Titel unter dem Bild (mit Fade-Out beim Scrollen)
                  SliverToBoxAdapter(
                    child: Opacity(
                      opacity: _bigTitleOpacity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                displayTitle,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Divider(
                                color: Colors.grey[
                                    300], // oder Colors.grey.shade400 für feiner
                                thickness: 2,
                                height:
                                    4, // vertikaler Abstand vor & nach der Linie
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Sticky Header mit Dauer & Veröffentlichungsdatum + Button-Row + Progressbar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyInfoHeader(
                      duration: _formatDuration(widget.episode.trackTimeMillis),
                      releaseDate: formatReleaseDate(
                        widget.episode.releaseDate,
                      ),
                      extraContent: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.grey[500],
                                ),
                                tooltip: 'Favorisieren',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Favoriten-Feature folgt'),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.download,
                                  color: Colors.grey[400],
                                ),
                                tooltip: 'Download',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Download-Feature folgt'),
                                    ),
                                  );
                                },
                              ),
                              CastAirPlayButton(
                                isAvailable: isAvailable,
                                isConnected: isConnected,
                                statusText: statusText,
                                onPressed: isAvailable
                                    ? () {
                                        if (isConnected) {
                                          service.disconnect();
                                        } else if (devices.isNotEmpty) {
                                          service.connectToDevice(
                                            devices.first,
                                          );
                                        } else {
                                          service.discoverDevices();
                                        }
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          // Kein SizedBox mehr zwischen Buttons und Slider, Abstand komplett entfernt
                          Row(
                            children: [
                              SizedBox(
                                width: 48,
                                child: Text(
                                  _formatDurationMMSS(position.inMilliseconds),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.blue,
                                    inactiveTrackColor: Colors.grey[250],
                                    thumbColor: Colors.grey[350],
                                    overlayColor: Colors.grey.withAlpha(32),
                                    trackHeight: 14,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 9,
                                    ),
                                    valueIndicatorShape:
                                        const PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: Colors.grey[350],
                                    showValueIndicator:
                                        ShowValueIndicator.onlyForContinuous,
                                  ),
                                  child: Slider(
                                    value: position.inSeconds.toDouble(),
                                    max: duration.inSeconds.toDouble(),
                                    divisions: duration.inSeconds > 0
                                        ? duration.inSeconds
                                        : null,
                                    label: _formatDurationMMSS(
                                      position.inMilliseconds,
                                    ),
                                    onChanged: (v) {
                                      audioBloc.add(
                                        Seek(Duration(seconds: v.toInt())),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 48,
                                child: Text(
                                  '-${_formatDurationMMSS((duration - position).inMilliseconds)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Scrollbare Beschreibung
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.grey[
                                300], // oder Colors.grey.shade400 für feiner
                            thickness: 2,
                            height:
                                4, // vertikaler Abstand vor & nach der Linie
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Text(
                              widget.episode.description ?? "",
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BottomPlayerWidget(),
              ),
            ],
          ),
        );
      },
    );
  }

  // 1. Optionaler manuell gesteuerter Umbruch nach Trennzeichen
  // 2. Wörter extrahieren und Stück für Stück zusammensetzen
  // 3. Suffix anhängen (z. B. ... – Max Mustermann)

  String _formatTitle(String input) {
    if (input.length > 10 && input.contains('- ')) {
      final delimiters = [':', '-', '|', '/']; // beliebig erweiterbar

      for (var d in delimiters) {
        if (input.contains(d)) {
          final parts = input.split(d);
          if (parts.length > 1) {
            return '${parts[0]}$d\n${parts.sublist(1).join(d).trim()}';
          }
        }
      }
      return input.replaceFirst(': ', ':\u200B');
    }
    return input;
  }

  // Hilfsfunktion für die Episoden-Dauer (für StickyInfoHeader)
  String _formatDuration(int millis) {
    final seconds = (millis / 1000).round();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    // Für StickyInfoHeader: Format 'Xm YYs'
    return '${minutes}m ${remainingSeconds.toString().padLeft(2, '0')}s';
  }

  // Hilfsfunktion für Fortschrittsbalken (Slider) und Zeitanzeige: mm:ss
  String _formatDurationMMSS(int millis) {
    final seconds = (millis / 1000).round();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatReleaseDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
