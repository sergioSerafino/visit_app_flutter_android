// /../presentation/pages/podcast_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../domain/models/podcast_episode_model.dart';
import '../../../presentation/pages/episode_detail_page.dart';
import '../../../presentation/widgets/image_with_banner.dart';
import '../../../presentation/widgets/episode_item_tile.dart';
import '../../domain/enums/repository_source_type.dart';
import '../../../presentation/widgets/async/async_ui_helper.dart';
import '../../../presentation/widgets/async/async_value_widget.dart';
import '../../../application/providers/data_mode_provider.dart';
import '../../../application/providers/podcast_provider.dart';
import '../../../application/providers/app_mode_provider.dart';
import '../../../application/providers/collection_provider.dart';
import '../../application/controllers/should_load_controller.dart';
import '../../../domain/enums/episode_load_state.dart';
import '../../../core/placeholders/placeholder_loader_service.dart';
import '../../../application/providers/episode_controller_provider.dart';
import '../../../domain/enums/collection_load_state.dart';
import '../../core/utils/color_utils.dart';
import '../../../application/providers/overlay_tab_provider.dart';
import './podcast_scroll_indicator.dart';
import '../../../core/placeholders/placeholder_content.dart';

class PodcastPage extends ConsumerWidget {
  final ScrollController? scrollController;
  final double? initialScrollOffset;
  const PodcastPage(
      {super.key, this.scrollController, this.initialScrollOffset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appMode = ref.watch(appModeProvider);
    final isApiMode = ref.watch(dataSourceProvider) == RepositorySourceType.api;
    final collectionId = ref.watch(collectionIdProvider);

    // Controller State
    final collectionState = ref.watch(collectionLoadControllerProvider);
    final episodeState = ref.watch(episodeLoadControllerProvider);

    final podcastResponse = ref.watch(podcastCollectionProvider(collectionId));
    final shouldLoad = episodeState == EpisodeLoadState.loaded;

    final episodeResponse = shouldLoad
        ? ref.watch(podcastEpisodeProvider(collectionId))
        : const AsyncValue<List<PodcastEpisode>>.loading();

    // Lade-Reihenfolge sicherstellen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (collectionState == CollectionLoadState.initial) {
        ref
            .read(collectionLoadControllerProvider.notifier)
            .performCollectionLoadingSequence();
      } else if (collectionState == CollectionLoadState.loaded &&
          episodeState == EpisodeLoadState.initial) {
        ref
            .read(episodeLoadControllerProvider.notifier)
            .performEpisodesLoadingSequence();
      }
    });

    // Wenn Placeholder-Modus aktiv: Direkt Dummy-Daten anzeigen
    // ✳️ Placeholder-Modus?
    if (appMode == AppMode.placeholder) {
      final placeholderEpisodes =
          PlaceholderLoaderService.podcastCollection.allEpisodes;

      // Flutter-konforme Overlay-Farbe für AppBar (auch im Placeholder-Modus verfügbar machen)
      final showOverlay = ref.watch(overlayTabProvider)[0] ?? false;
      final baseColor = Theme.of(context).colorScheme.primary;
      final appBarColor = showOverlay
          ? flutterAppBarOverlayColorM3(context, baseColor)
          : baseColor;

      return Scaffold(
        appBar: AppBar(
          title: const Text("📻 Placeholder-Modus"),
          backgroundColor: appBarColor,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: placeholderEpisodes.length,
          itemBuilder: (context, index) {
            return EpisodeItemTile(episode: placeholderEpisodes[index]);
          },
        ),
      );
    }

    // final isLoading = podcastResponse.isLoading || episodeResponse.isLoading;

    if (initialScrollOffset != null && scrollController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController!.hasClients &&
            scrollController!.offset != initialScrollOffset) {
          scrollController!.jumpTo(initialScrollOffset!);
        }
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // 📡 Eingabefeld für CollectionId (nur im API-Modus)
            Row(
              children: [
                if (isApiMode)
                  Container(), // Platzhalter für zukünftiges Eingabefeld
              ],
            ),
            //----
            // 🔽 Cover + Genre mit CollectionLoadState
            Builder(
              builder: (context) {
                switch (collectionState) {
                  case CollectionLoadState.loading:
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.black12),
                      ),
                    );

                  case CollectionLoadState.placeholder:
                    return const ImageWithBanner(
                      imageUrl: '',
                      label: 'Podcast lädt...',
                    );

                  case CollectionLoadState.loaded:
                    // Der AsyncValue podcastResponse kann nie null sein, daher Bedingung entfernt
                    return podcastResponse.when(
                      data: (apiResponse) => apiResponse.when(
                        success: (collection) {
                          final podcast = collection.podcasts.firstOrNull;
                          return GestureDetector(
                            onTap: () => ref
                                .read(
                                  shouldLoadEpisodesProvider.notifier,
                                )
                                .loadEpisodes(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Placeholder bleibt sichtbar
                                const ImageWithBanner(
                                  imageUrl: '',
                                  label: 'Podcast lädt...',
                                ),
                                // Das echte Cover blendet sich darüber ein
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(
                                    milliseconds: 700,
                                  ),
                                  curve: Curves.easeIn,
                                  tween: Tween<double>(begin: 0, end: 1),
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: child,
                                    );
                                  },
                                  child: ImageWithBanner(
                                    key: ValueKey(
                                      podcast?.artworkUrl600 ?? "",
                                    ),
                                    imageUrl: podcast?.artworkUrl600 ?? "",
                                    label: podcast?.primaryGenreName ?? "genre",
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (msg) => Builder(
                          builder: (context) {
                            // Fallback: PlaceholderCollection anzeigen
                            final placeholder = PlaceholderContent.podcastCollection.podcasts.first;
                            return ImageWithBanner(
                              key: const ValueKey("placeholder"),
                              imageUrl: placeholder.artworkUrl600,
                              label: placeholder.primaryGenreName,
                            );
                          },
                        ),
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 32),
                            SizedBox(height: 8),
                            Text('Fehler beim Laden der Podcast-Daten'),
                          ],
                        ),
                      ),
                    );

                  case CollectionLoadState.error:
                    return const Text(
                      "Fehler beim Laden der Sammlung",
                      style: TextStyle(color: Colors.red),
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 12),

            // 🔽 Episodenliste mit Async Builder
            Expanded(
              child: Builder(
                builder: (context) {
                  switch (episodeState) {
                    case EpisodeLoadState.loading:
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.black12),
                      );
                    case EpisodeLoadState.placeholder:
                      return Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: EpisodeItemTile(
                                episode: PodcastEpisode(
                                  wrapperType: "",
                                  trackId: index,
                                  trackName: "Lade Folge\n", // ${index + 1}",
                                  artworkUrl600: "",
                                  description:
                                      "Beschreibungs-Text des Platzhalter-Inhaltes dieser Folge.",
                                  trackTimeMillis: 1150000,
                                  episodeUrl: "",
                                  episodeFileExtension: "mp3",
                                  releaseDate: DateTime.now(),
                                ),
                                onTap: () {},
                              ),
                            );
                          },
                        ),
                      );
                    case EpisodeLoadState.loaded:
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1500),
                        switchInCurve: Curves.easeIn,
                        // switchOutCurve: Curves.easeOut,
                        child: AsyncValueWidget<List<PodcastEpisode>>(
                          key: ValueKey(episodeResponse.hashCode),
                          value: episodeResponse,
                          data: (episodes) {
                            if (episodes.isEmpty) {
                              return const Center(
                                child: Text("Keine Episoden gefunden."),
                              );
                            }
                            return ListView.builder(
                              controller: scrollController, // <- NEU
                              itemCount: episodes.length,
                              itemBuilder: (context, index) {
                                final episode = episodes[index];
                                return EpisodeItemTile(
                                  episode: episode,
                                  onTap: () {
                                    // KEIN automatisches Setzen der Episode mehr!
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EpisodeDetailPage(
                                          episode: episode,
                                          trackName: episode.trackName,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            // ProgressBar und Abstand jetzt unterhalb der Liste
            if (scrollController != null) ...[
              const SizedBox(height: 12),
              PodcastScrollIndicator(scrollController: scrollController!),
            ],
          ],
        ),
      ),
    );
  }
}
