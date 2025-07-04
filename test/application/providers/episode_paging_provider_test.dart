import 'dart:async';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_app_flutter_android/application/providers/episode_paging_provider.dart';
import 'package:visit_app_flutter_android/domain/models/podcast_episode_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('EpisodePagingProvider', () {
    late Directory tempDir;
    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test');
      Hive.init(tempDir.path);
    });
    tearDown(() async {
      // Relevante Hive-Box schließen und löschen, um Zugriffskonflikte zu vermeiden
      try {
        var box = await Hive.openBox('episodePagesBox');
        await box.close();
        await Hive.deleteBoxFromDisk('episodePagesBox');
      } catch (_) {}
      // ProviderContainer korrekt disposen
      // (muss im Test angelegt werden)
    });

    test('Lädt und kombiniert Episoden-Seiten korrekt', () async {
      final container = ProviderContainer();
      final notifier = container.read(episodePagingProvider.notifier);
      Future<List<PodcastEpisode>> fetchPage(int page, int pageSize) async {
        return List.generate(
          pageSize,
          (i) => PodcastEpisode(
            wrapperType: "podcastEpisode",
            trackId: page * pageSize + i,
            trackName: 'Ep${page * pageSize + i}',
            artworkUrl600: '',
            description: '',
            episodeUrl: '',
            trackTimeMillis: 1,
            episodeFileExtension: 'mp3',
            releaseDate: DateTime.now(),
          ),
        );
      }

      final completer = Completer<void>();
      late ProviderSubscription sub;
      sub = container.listen<EpisodePagingState>(episodePagingProvider, (
        prev,
        next,
      ) {
        if (next.episodes.length == 40) {
          completer.complete();
          sub.close();
        }
      }, fireImmediately: true);

      await notifier.loadPage(0, fetchPage);
      await notifier.loadPage(1, fetchPage);
      await completer.future.timeout(const Duration(seconds: 2));
      final state = container.read(episodePagingProvider);
      expect(state.episodes.length, 40);
      expect(state.episodes[0].trackName, 'Ep0');
      expect(state.episodes[39].trackName, 'Ep39');
      container.dispose();
    });
  });
}
