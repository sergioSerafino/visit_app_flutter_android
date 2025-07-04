import 'package:flutter_test/flutter_test.dart';
import 'package:visit_app_flutter_android/core/services/episode_paging_cache_service.dart';
import 'package:visit_app_flutter_android/domain/models/podcast_episode_model.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() {
  group('EpisodePagingCacheService', () {
    late EpisodePagingCacheService cacheService;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test');
      Hive.init(tempDir.path);
      cacheService = EpisodePagingCacheService();
    });

    tearDown(() async {
      await Hive.deleteBoxFromDisk('episodePagesBox');
      await tempDir.delete(recursive: true);
    });

    test('Speichert und lädt eine Episoden-Seite korrekt', () async {
      final episodes = [
        PodcastEpisode(
          wrapperType: "podcastEpisode",
          trackId: 1,
          trackName: 'Test Episode',
          artworkUrl600: '',
          description: 'Beschreibung',
          episodeUrl: 'https://audio',
          trackTimeMillis: 123,
          episodeFileExtension: 'mp3',
          releaseDate: DateTime.now(),
        ),
      ];
      await cacheService.savePage(123, 0, episodes);
      final loaded = await cacheService.loadPage(123, 0);
      expect(loaded, isNotNull);
      expect(loaded!.first.trackName, 'Test Episode');
    });

    test('isPageFresh erkennt frische und abgelaufene Seiten', () async {
      final episodes = [
        PodcastEpisode(
          wrapperType: "podcastEpisode",
          trackId: 1,
          trackName: 'Test',
          artworkUrl600: '',
          description: '',
          episodeUrl: '',
          trackTimeMillis: 1,
          episodeFileExtension: 'mp3',
          releaseDate: DateTime.now(),
        ),
      ];
      await cacheService.savePage(123, 0, episodes);
      final fresh = await cacheService.isPageFresh(
        123,
        0,
        ttl: const Duration(seconds: 5),
      );
      expect(fresh, true);
      // Simuliere Ablauf
      final box = await Hive.openBox('episodePagesBox');
      final entry = box.get('123_0');
      entry['timestamp'] = DateTime.now()
          .subtract(const Duration(seconds: 10))
          .toIso8601String();
      await box.put('123_0', entry);
      final expired = await cacheService.isPageFresh(
        123,
        0,
        ttl: const Duration(seconds: 5),
      );
      expect(expired, false);
    });
  });
}
