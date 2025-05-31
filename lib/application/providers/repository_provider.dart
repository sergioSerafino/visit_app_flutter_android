// lib/application/providers/repository_provider.dart
// liefert Repository-Instanz: podcastRepositoryProvider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/api_client.dart';
import '../../data/api/local_cache_client.dart';
import '../../data/repositories/api_podcast_repository.dart';
import '../../data/repositories/mock_podcast_repository.dart';
import '../../data/repositories/podcast_repository.dart';
import '../../domain/enums/repository_source_type.dart';
import 'data_mode_provider.dart';
import 'package:hive/hive.dart';

/// Liefert den passenden PodcastRepository je nach Modus
final podcastRepositoryProvider = Provider<PodcastRepository>((ref) {
  final mode = ref.watch(dataSourceProvider);
  final apiClient = ApiClient(); // könnte ref.watch(apiClientProvider) sein
  final cacheClient = LocalCacheClient(Hive.box('podcastBox'));

  return mode == RepositorySourceType.api
      ? ApiPodcastRepository(apiClient: apiClient, cacheClient: cacheClient)
      : MockPodcastRepository(fakeDelay: const Duration(milliseconds: 0));
});

// Die folgenden Imports wurden entfernt, da sie aktuell nicht genutzt werden:
// import '../../application/controllers/episode_load_controller.dart'; // Entfernt, da aktuell nicht genutzt. Siehe ggf. Refactoring- und Architektur-HowTos für spätere Erweiterung.
// import '../../domain/enums/episode_load_state.dart'; // Entfernt, da aktuell nicht genutzt. Siehe ggf. Refactoring- und Architektur-HowTos für spätere Erweiterung.
