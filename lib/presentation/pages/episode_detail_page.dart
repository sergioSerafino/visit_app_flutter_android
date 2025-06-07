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
import '../../application/providers/cast_airplay_provider.dart';
import '../../application/providers/audio_player_provider.dart';
import '../../application/providers/current_episode_provider.dart';
import '../../core/services/audio_player_bloc.dart';
import '../widgets/cast_airplay_button.dart';
import '../widgets/cover_image_widget.dart';
import '../widgets/sticky_info_header.dart';
import '../widgets/bottom_player_widget.dart';
import '../../core/messaging/snackbar_manager.dart';

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
    // --- Buffering/Preload der Episode beim Öffnen (ohne Autoplay) ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final container = ProviderScope.containerOf(context, listen: false);
      final audioBloc = container.read(audioPlayerBlocProvider);
      final currentEpisode = container.read(currentEpisodeProvider);
      final currentAudioUrl = audioBloc.currentUrl;
      // --- currentEpisodeProvider setzen, falls noch nicht gesetzt ---
      if (currentEpisode == null ||
          currentEpisode.trackId != widget.episode.trackId) {
        container.read(currentEpisodeProvider.notifier).state = widget.episode;
      }
      // Preload NUR wenn die URL sich geändert hat (sonst bleibt Position erhalten)
      if (widget.episode.episodeUrl.isNotEmpty &&
          currentAudioUrl != widget.episode.episodeUrl) {
        audioBloc.add(PreloadEpisode(widget.episode.episodeUrl));
      }
    });
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
                    iconTheme: const IconThemeData(
                      color: Color.fromARGB(180, 0, 0, 0),
                    ),
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
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color.fromARGB(0, 0, 0, 0),
                                  (() {
                                    final theme = Theme.of(context);
                                    final secondary =
                                        theme.colorScheme.secondary;
                                    // Standardwert, wie vom Skript gesetzt (z.B. #EEEEEE)
                                    const defaultSecondary = Color(0xFFEEEEEE);
                                    // Vergleiche explizit die Farbkomponenten statt .value (deprecated)
                                    bool isCustomSecondary(Color c) =>
                                        c.r != defaultSecondary.r ||
                                        c.g != defaultSecondary.g ||
                                        c.b != defaultSecondary.b ||
                                        c.a != defaultSecondary.a;
                                    return (isCustomSecondary(secondary)
                                            ? secondary
                                            : theme.colorScheme.primary)
                                        .withAlpha(160);
                                  })(),
                                ],
                                stops: const [0.35, 0.85],
                              ),
                            ),
                          ),

                          // Cover-Bild zentriert
                          Align(
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 32,
                              ), // leicht nach oben versetzt
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withAlpha(40),
                                    blurRadius: 8,
                                    offset: const Offset(3, 10),
                                  ),
                                ],
                              ),
                              child: CoverImageWidget(
                                imageUrl: widget.episode.artworkUrl600,
                                scaleFactor: 0.5,
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
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                thickness: 2,
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Sticky Header mit Dauer & Veröffentlichungsdatum + Button-Row
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
                                  size: 32, // wie Download-Icon
                                  color: /*Theme.of(context)
                                      .colorScheme
                                      .primary,*/
                                      Colors.grey[500], // wie Download-Icon
                                ),
                                tooltip: 'Favorisieren',
                                onPressed: () {
                                  ref
                                      .read(snackbarManagerProvider.notifier)
                                      .showByKey('favorites_feature');
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.download,
                                  size: 32,
                                  color: //Theme.of(context).colorScheme.primary,
                                      Colors.grey[500],
                                ),
                                tooltip: 'Download',
                                onPressed: () {
                                  ref
                                      .read(snackbarManagerProvider.notifier)
                                      .showByKey('download_feature');
                                },
                              ),
                              CastAirPlayButton(
                                isAvailable: isAvailable,
                                isConnected: isConnected,
                                statusText: statusText,
                                onPressed: isAvailable
                                    ? () {
                                        ref
                                            .read(snackbarManagerProvider
                                                .notifier)
                                            .showByKey('cast_feature');
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
                                iconColor:
                                    //Theme.of(context).colorScheme.primary,
                                    Colors.grey[500],
                                iconSize: 32,
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
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            thickness: 2,
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Text(
                              widget.episode.description ?? "",
                              style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 2),
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
    final totalSeconds = (millis / 1000).round();
    final hours = (totalSeconds ~/ 3600);
    final minutes = ((totalSeconds % 3600) ~/ 60);
    final seconds = totalSeconds % 60;
    // Für StickyInfoHeader: Format '0h 00m 00s'
    return '${hours}h '
        '${minutes.toString().padLeft(2, '0')}m '
        '${seconds.toString().padLeft(2, '0')}s';
  }

  String formatReleaseDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
