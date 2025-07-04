import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visit_app_flutter_android/presentation/widgets/bottom_player_widget.dart';
import 'package:visit_app_flutter_android/core/services/audio_player_bloc.dart';
import 'package:visit_app_flutter_android/core/services/i_audio_player.dart';
import 'package:visit_app_flutter_android/application/providers/audio_player_provider.dart';
import 'package:visit_app_flutter_android/domain/models/podcast_episode_model.dart';
import 'package:visit_app_flutter_android/application/providers/current_episode_provider.dart';
import '../../test_hive_init.dart';

class MockAudioPlayerBackend extends Mock implements IAudioPlayerBackend {}

void stubAllBackendMethods(MockAudioPlayerBackend mockBackend) {
  when(() => mockBackend.play()).thenAnswer((_) async {});
  when(() => mockBackend.pause()).thenAnswer((_) async {});
  when(() => mockBackend.stop()).thenAnswer((_) async {});
  when(() => mockBackend.seek(any())).thenAnswer((_) async {});
  when(() => mockBackend.setSpeed(any())).thenAnswer((_) async {});
  when(() => mockBackend.setVolume(any())).thenAnswer((_) async {});
  when(() => mockBackend.position).thenReturn(Duration.zero);
  when(() => mockBackend.duration).thenReturn(const Duration(seconds: 60));
  when(() => mockBackend.speed).thenReturn(1.0);
  when(() => mockBackend.volume).thenReturn(0.5);
  when(() => mockBackend.playing).thenReturn(false);
  when(() => mockBackend.positionStream)
      .thenAnswer((_) => Stream.fromIterable([Duration.zero]));
  when(() => mockBackend.durationStream)
      .thenAnswer((_) => Stream.fromIterable([const Duration(seconds: 60)]));
  when(() => mockBackend.playerStateStream)
      .thenAnswer((_) => Stream.fromIterable(['paused']));
  when(() => mockBackend.speedStream).thenAnswer((_) => Stream.value(1.0));
  when(() => mockBackend.volumeStream).thenAnswer((_) => Stream.value(0.5));
}

void main() {
  setupHiveForTests();

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  testWidgets(
    'Nach Reset (Idle-State) bleibt Play/Pause-Button aktiv, wenn Episode im Provider',
    (WidgetTester tester) async {
      final mockBackend = MockAudioPlayerBackend();
      stubAllBackendMethods(mockBackend);
      final bloc = AudioPlayerBloc(backend: mockBackend);
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1),
      );
      // Starte mit Idle-State und gültiger Episode im Provider
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerBlocProvider.overrideWithValue(bloc),
            audioPlayerStateProvider
                .overrideWith((ref) => Stream.value(Idle())),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: const MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      // Play/Pause-Button muss enabled sein
      final playButtonFinder =
          find.byKey(const Key('player_play_pause_button'));
      expect(playButtonFinder, findsOneWidget);
      final playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNotNull,
          reason: 'Play/Pause-Button muss nach Reset aktiv bleiben');
      // Cleanup: Widget-Baum abräumen
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
    },
  );
}
