import 'package:flutter_test/flutter_test.dart';
import 'package:empty_flutter_template/core/services/episode_paging_cache_service.dart';
import 'package:empty_flutter_template/domain/models/podcast_episode_model.dart';
import 'package:hive/hive.dart';
import 'dart:io';

void main() {
  group('EpisodePagingCacheService Integration', () {
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

    test('Serialisierung/Deserialisierung bleibt 1:1 erhalten', () async {
      final original = PodcastEpisode(
        wrapperType: "podcastEpisode",
        trackId: 42,
        trackName: 'Test Episode',
        artworkUrl600: 'https://img',
        description: 'Beschreibung',
        episodeUrl: 'https://audio',
        trackTimeMillis: 123,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime.parse('2024-05-28T12:00:00Z'),
      );
      await cacheService.savePage(1, 0, [original]);
      final loaded = await cacheService.loadPage(1, 0);
      expect(loaded, isNotNull);
      expect(loaded!.length, 1);
      final re = loaded.first;
      expect(re.trackId, original.trackId);
      expect(re.trackName, original.trackName);
      expect(re.artworkUrl600, original.artworkUrl600);
      expect(re.description, original.description);
      expect(re.episodeUrl, original.episodeUrl);
      expect(re.trackTimeMillis, original.trackTimeMillis);
      expect(re.episodeFileExtension, original.episodeFileExtension);
      expect(re.releaseDate, original.releaseDate);
    });
  });
}
