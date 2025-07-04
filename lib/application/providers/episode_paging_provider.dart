// filepath: lib/application/providers/episode_paging_provider.dart
// StateNotifier für Paging- und Listen-Caching von Episoden
//
// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Paging, Caching, Provider-Pattern und Teststrategie.
// Lessons Learned: StateNotifier für Paging, Listen-Caching und Fehlerbehandlung. Siehe auch episode_paging_cache_service.dart.
// Hinweise: Testdaten, Fallback-Logik und Performance beachten.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'collection_provider.dart';
import '../../core/services/episode_paging_cache_service.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../core/placeholders/placeholder_content.dart';

class EpisodePagingState {
  final List<PodcastEpisode> episodes;
  final int currentPage;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  EpisodePagingState({
    required this.episodes,
    required this.currentPage,
    required this.isLoading,
    required this.hasMore,
    this.error,
  });

  factory EpisodePagingState.initial() => EpisodePagingState(
        episodes: [],
        currentPage: 0,
        isLoading: false,
        hasMore: true,
      );

  EpisodePagingState copyWith({
    List<PodcastEpisode>? episodes,
    int? currentPage,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return EpisodePagingState(
      episodes: episodes ?? this.episodes,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

final episodePagingCacheServiceProvider = Provider(
  (ref) => EpisodePagingCacheService(),
);

final episodePagingProvider = StateNotifierProvider.autoDispose<
    EpisodePagingNotifier, EpisodePagingState>((ref) {
  final collectionId = ref.watch(collectionIdProvider);
  final cacheService = ref.watch(episodePagingCacheServiceProvider);
  return EpisodePagingNotifier(collectionId, cacheService);
});

class EpisodePagingNotifier extends StateNotifier<EpisodePagingState> {
  final int collectionId;
  final EpisodePagingCacheService cacheService;
  static const int pageSize = 20;

  EpisodePagingNotifier(this.collectionId, this.cacheService)
      : super(EpisodePagingState.initial());

  Future<void> loadPage(
    int pageIndex,
    Future<List<PodcastEpisode>> Function(int page, int pageSize) fetchPage,
  ) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      List<PodcastEpisode>? episodes;
      if (await cacheService.isPageFresh(collectionId, pageIndex)) {
        episodes = await cacheService.loadPage(collectionId, pageIndex);
      } else {
        episodes = await fetchPage(pageIndex, pageSize);
        await cacheService.savePage(collectionId, pageIndex, episodes);
      }
      // Fallback: Wenn keine Episoden gefunden oder Fehler, Placeholder zurückgeben
      if (episodes == null || episodes.isEmpty) {
        episodes = PlaceholderContent.placeholderEpisodes;
      }
      final allEpisodes = List<PodcastEpisode>.from(state.episodes);
      final start = pageIndex * pageSize;
      if (allEpisodes.length < start) {
        allEpisodes.length = start;
      }
      for (int i = 0; i < episodes.length; i++) {
        if (allEpisodes.length > start + i) {
          allEpisodes[start + i] = episodes[i];
        } else {
          allEpisodes.add(episodes[i]);
        }
      }
      state = state.copyWith(
        episodes: allEpisodes,
        currentPage: pageIndex,
        isLoading: false,
        hasMore: episodes.length == pageSize,
      );
    } catch (e) {
      // Fehlerfall: Immer konsistente Placeholder-Episoden zurückgeben
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        episodes: PlaceholderContent.placeholderEpisodes,
        hasMore: false,
      );
    }
  }
}
