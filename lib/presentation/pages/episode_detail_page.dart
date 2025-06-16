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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../widgets/sticky_info_header.dart';
import '../widgets/bottom_player_widget.dart';
import '../widgets/episode_action_row.dart';
import '../../core/utils/episode_format_utils.dart';
import '../widgets/cover_image_widget.dart';

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
    final String displayTitle =
        EpisodeFormatUtils.formatTitle(widget.trackName);
    final String formattedAbbreviatedTitle =
        EpisodeFormatUtils.formatAndAbbreviateTitle(
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
                                    const defaultSecondary = Color(0xFFEEEEEE);
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
                          // Cover-Bild zentriert (ersetzt durch EpisodeCoverWidget)
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
                      duration: EpisodeFormatUtils.formatDuration(
                          widget.episode.trackTimeMillis),
                      releaseDate: EpisodeFormatUtils.formatReleaseDate(
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
                          // Beschreibungstext direkt hier eingefügt
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
