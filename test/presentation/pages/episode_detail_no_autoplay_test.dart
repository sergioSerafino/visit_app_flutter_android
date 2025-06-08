import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empty_flutter_template/presentation/pages/episode_detail_page.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'package:empty_flutter_template/core/services/i_audio_player.dart';
import 'package:empty_flutter_template/application/providers/audio_player_provider.dart';
import 'package:empty_flutter_template/application/providers/current_episode_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empty_flutter_template/domain/models/podcast_episode_model.dart';

class MockAudioPlayerBackend extends Mock implements IAudioPlayerBackend {}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  testWidgets(
      'Audio wird NICHT automatisch gestartet beim Öffnen der EpisodeDetailPage',
      (WidgetTester tester) async {
    final backend = MockAudioPlayerBackend();
    // Backend gibt an: nicht playing, keine Streams
    when(() => backend.positionStream).thenAnswer((_) => const Stream.empty());
    when(() => backend.durationStream).thenAnswer((_) => const Stream.empty());
    when(() => backend.playerStateStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => backend.speedStream).thenAnswer((_) => Stream.value(1.0));
    when(() => backend.volumeStream).thenAnswer((_) => Stream.value(0.5));
    when(() => backend.position).thenReturn(const Duration());
    when(() => backend.duration).thenReturn(const Duration(seconds: 60));
    when(() => backend.playing).thenReturn(false);
    when(() => backend.seek(any<Duration>())).thenAnswer((_) async {});
    when(() => backend.play()).thenAnswer((_) async {});
    when(() => backend.pause()).thenAnswer((_) async {});
    when(() => backend.stop()).thenAnswer((_) async {});
    when(() => backend.setUrl(any<String>())).thenAnswer((_) async {});
    when(() => backend.dispose()).thenReturn(null);
    when(() => backend.speed).thenReturn(1.0);
    when(() => backend.volume).thenReturn(0.5);
    final bloc = AudioPlayerBloc(backend: backend);

    final episode = PodcastEpisode(
      wrapperType: 'episode',
      trackId: 1,
      trackName: 'Test Episode',
      artworkUrl600: '',
      description: 'Beschreibung',
      episodeUrl: 'https://audio',
      trackTimeMillis: 60000,
      episodeFileExtension: 'mp3',
      releaseDate: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerBlocProvider.overrideWithValue(bloc),
          audioPlayerStateProvider.overrideWith((ref) => Stream.value(Idle())),
          currentEpisodeProvider.overrideWith((ref) => episode),
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
    // Timer aus Marquee/Animationen ablaufen lassen, um Pending Timer zu vermeiden
    await tester.pump(const Duration(seconds: 4));
    // Es darf KEIN Playing-State erscheinen
    expect(find.byIcon(Icons.pause_circle_filled), findsNothing);
    expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
    // Backend.play() darf NICHT aufgerufen worden sein
    verifyNever(() => backend.play());
    // setUrl DARF EINMAL aufgerufen werden (Preload)
    verify(() => backend.setUrl(any())).called(1);
  });
}
