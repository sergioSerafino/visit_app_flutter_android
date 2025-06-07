import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empty_flutter_template/presentation/pages/episode_detail_page.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'package:empty_flutter_template/core/services/i_audio_player.dart';
import 'package:empty_flutter_template/application/providers/audio_player_provider.dart';
import 'package:empty_flutter_template/application/providers/cast_airplay_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empty_flutter_template/domain/models/podcast_episode_model.dart';
import '../../test_hive_init.dart';

class MockAudioPlayerBackend extends Mock implements IAudioPlayerBackend {}

void main() {
  setupHiveForTests();
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  testWidgets(
    'EpisodeDetailPage zeigt Fortschrittsbalken (Slider) und Zeitanzeige korrekt',
    (WidgetTester tester) async {
      final backend = MockAudioPlayerBackend();
      // Arrange: Backend-State und Streams stubben
      when(() => backend.positionStream)
          .thenAnswer((_) => Stream.value(const Duration(seconds: 10)));
      when(() => backend.durationStream)
          .thenAnswer((_) => Stream.value(const Duration(seconds: 60)));
      when(() => backend.playerStateStream)
          .thenAnswer((_) => Stream.value('playing'));
      when(() => backend.position).thenReturn(const Duration(seconds: 10));
      when(() => backend.duration).thenReturn(const Duration(seconds: 60));
      when(() => backend.playing).thenReturn(true);
      when(() => backend.seek(any<Duration>())).thenAnswer((_) async {});
      when(() => backend.play()).thenAnswer((_) async {});
      when(() => backend.pause()).thenAnswer((_) async {});
      when(() => backend.stop()).thenAnswer((_) async {});
      when(() => backend.setUrl(any<String>())).thenAnswer((_) async {});
      when(() => backend.dispose()).thenReturn(null);
      final bloc = AudioPlayerBloc(backend: backend);
      // Simuliere Playing-State explizit
      bloc.emit(Playing(Duration(seconds: 10), Duration(seconds: 60)));

      final episode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Beschreibung',
        episodeUrl: '',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerBlocProvider.overrideWithValue(bloc),
            audioPlayerStateProvider.overrideWith(
              (ref) => Stream.value(
                Playing(Duration(seconds: 10), Duration(seconds: 60)),
              ),
            ),
          ],
          child: MaterialApp(
            home: EpisodeDetailPage(
              episode: episode,
              trackName: episode.trackName,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Assert: Slider und Zeitanzeige vorhanden
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('00:10'), findsOneWidget); // linke Zeit
      expect(find.text('-00:50'), findsOneWidget); // rechte Zeit
      await bloc.close();
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle(); // Timer/Marquee cleanup
    },
  );
}
