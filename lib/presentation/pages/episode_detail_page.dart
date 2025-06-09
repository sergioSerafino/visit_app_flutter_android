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
import '../widgets/cover_image_widget.dart';
import '../widgets/sticky_info_header.dart';
import '../widgets/bottom_player_widget.dart';
import '../widgets/episode_action_row.dart';

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
    // --- ENTFERNT: KEIN automatisches Setzen/Preload der Episode mehr ---
    // Die Episode wird erst beim Play-Button-Click gesetzt und abgespielt.
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
    final String formattedAbbreviatedTitle = formatAndAbbreviateTitle(
      widget.trackName,
      maxLength: 48,
    );
    // Riverpod Consumer für Player- und Cast-Status
    return Consumer(
      builder: (context, ref, _) {
        // --- Entferne weitere ungenutzte lokale Variablen ---
        // final devices = ref.watch(castDevicesProvider);
        // final connectedDevice = ref.watch(connectedCastDeviceProvider);
        // --- Entferne ungenutzte lokale Variablen ---
        // final isAvailable = devices.isNotEmpty;
        // final isConnected = connectedDevice != null;
        // --- Entferne ungenutzte lokale Variablen ---
        // final statusText = isConnected
        //     ? 'Verbunden mit {connectedDevice.name}'
        //     : (isAvailable ? 'Mit Gerät verbinden' : 'Kein Gerät gefunden');
        // final service = ref.watch(castAirPlayServiceProvider);

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
                        formattedAbbreviatedTitle,
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

                  // Sticky Header mit Dauer & Veröffentlichungsdatum
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyInfoHeader(
                      duration: _formatDuration(widget.episode.trackTimeMillis),
                      releaseDate: formatReleaseDate(
                        widget.episode.releaseDate,
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
                          const SizedBox(height: 16),
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

                          const SizedBox(height: 40),

                          // Divider über der Button-Row
                          Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            thickness: 2,
                            height: 4,
                          ),
                          const SizedBox(
                              height: 8), // Abstand über den Symbolen
                          // --- ERSETZT: Inline-Button-Row durch EpisodeActionRow ---
                          EpisodeActionRow(
                            episode: widget.episode,
                            trackName: widget.trackName,
                          ),
                          // --- ENDE Button-Row ---
                          const SizedBox(height: 8),
                          // Divider unter der Button-Row
                          Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            thickness: 2,
                            height: 4,
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
    // Stunden nur anzeigen, wenn >0
    if (hours > 0) {
      return '${hours}h '
          '${minutes.toString().padLeft(2, '0')}m '
          '${seconds.toString().padLeft(2, '0')}s';
    } else {
      return '${minutes}m '
          '${seconds.toString().padLeft(2, '0')}s';
    }
  }

  String formatReleaseDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  // Kombiniert Formatierung (Zeilenumbruch nach Trennzeichen) und Abkürzung für die erste Zeile (ohne Einkürzen, sondern Anfang und Ende zeigen).
  String formatAndAbbreviateTitle(String input, {int maxLength = 32}) {
    final formatted = _formatTitle(input);
    final lines = formatted.split('\n');
    if (lines.length == 1) {
      // Nur eine Zeile: Anfang und Ende zeigen, Mittelteil durch ... ersetzen
      return abbreviateStartAndEnd(lines[0], maxLength: maxLength);
    } else {
      // Erste Zeile: Anfang und Ende zeigen, zweite bleibt wie formatiert
      final first = abbreviateStartAndEnd(lines[0], maxLength: maxLength);
      return '$first\n${lines.sublist(1).join('\n')}';
    }
  }

  // Gibt von einem langen String den Anfang und das Ende zurück, Mittelteil wird durch ... ersetzt (z.B. "Anfang ...Ende")
  String abbreviateStartAndEnd(String input, {int maxLength = 48}) {
    if (input.length <= maxLength) return input;
    // Mindestens 6 Zeichen für Anfang und Ende, sonst nur ...
    final minKeep = 6;
    final keep = ((maxLength - 3) ~/ 2).clamp(minKeep, maxLength);
    final start = input.substring(0, keep).trim();
    final end = input.substring(input.length - keep).trim();
    return '$start...$end';
  }

  // Gibt den Titel für die AppBar so zurück, dass das Ende (z.B. Episodenname) immer sichtbar bleibt.
  String abbreviateTitle(String input, {int maxLength = 32}) {
    if (input.length <= maxLength) return input;
    // Trennzeichen für Episoden-/Folgentitel
    final delimiters = [':', '-', '|', '/'];
    String lastSegment = input;
    for (var d in delimiters) {
      if (input.contains(d)) {
        lastSegment = input.split(d).last.trim();
        break;
      }
    }
    // Wenn das letzte Segment fast so lang ist wie der ganze Titel, dann normal ellipsieren
    if (lastSegment.length > maxLength - 4) {
      return input.substring(0, maxLength - 1) + '…';
    }
    // Sonst: Anfang abschneiden, Ende behalten
    return '… $lastSegment';
  }

  /*
  UX-Logik: Play-Button auf der EpisodeDetailPage
  ------------------------------------------------
  - Der Play-Button koppelt die jeweilige Episode explizit an den Player (BottomPlayerWidget).
  - Die farbliche Hervorhebung (aktiv) erfolgt nur, wenn die aktuell im Player geladene Episode (currentEpisodeProvider)
    mit der auf der Seite dargestellten Episode übereinstimmt.
  - Der Abgleich erfolgt aktuell über trackId (TODO: Für Offline-Wiedergabe ggf. robusteren Vergleich implementieren, z.B. mit localId oder trackName).
  - Ziel: Die UI bleibt konsistent, auch wenn mehrere Detailseiten geöffnet sind oder Episoden aus verschiedenen Quellen geladen werden.
  */
}
