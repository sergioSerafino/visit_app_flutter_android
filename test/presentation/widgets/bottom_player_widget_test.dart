import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empty_flutter_template/presentation/widgets/bottom_player_widget.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'package:empty_flutter_template/core/services/i_audio_player.dart';
import 'package:empty_flutter_template/application/providers/audio_player_provider.dart';
import 'package:empty_flutter_template/domain/models/podcast_episode_model.dart';
import 'package:empty_flutter_template/application/providers/current_episode_provider.dart';

class MockAudioPlayerBackend extends Mock implements IAudioPlayerBackend {}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  testWidgets(
    'BottomPlayerWidget Integration: Play mit echter OpaliaTalk-Episode',
    (WidgetTester tester) async {
      final mockBackend = MockAudioPlayerBackend();
      // Stubbing aller relevanten Methoden/Streams
      when(() => mockBackend.play()).thenAnswer((_) async {});
      when(() => mockBackend.pause()).thenAnswer((_) async {});
      when(() => mockBackend.stop()).thenAnswer((_) async {});
      when(() => mockBackend.seek(any())).thenAnswer((_) async {});
      when(() => mockBackend.setSpeed(any())).thenAnswer((_) async {});
      when(() => mockBackend.position).thenReturn(Duration.zero);
      when(() => mockBackend.duration).thenReturn(const Duration(seconds: 60));
      when(() => mockBackend.speed).thenReturn(1.0);
      when(() => mockBackend.playing).thenReturn(false);
      when(() => mockBackend.positionStream).thenAnswer((_) => Stream.value(Duration.zero));
      when(() => mockBackend.durationStream).thenAnswer((_) => Stream.value(const Duration(seconds: 60)));
      when(() => mockBackend.playerStateStream).thenAnswer((_) => Stream.value('paused'));
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
        releaseDate: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerBlocProvider.overrideWithValue(bloc),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: BottomPlayerWidget(
                onClose: () {}, // <-- Callback gesetzt für Close-Button
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Play drücken
      await tester.tap(find.byIcon(Icons.play_circle_fill));
      await tester.pumpAndSettle();
      // Simuliere Playing-State mit echter Episode
      bloc.emit(Playing(Duration(seconds: 0), Duration(seconds: 60)));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.pause_circle_filled), findsOneWidget);
      // Fehlerfall simulieren
      bloc.emit(ErrorState('Testfehler mit echter Episode'));
      await tester.pumpAndSettle();
      // Fehlertext/Fehleranzeige: Prüfe auf Tooltip oder SemanticsLabel
      expect(
        find.byTooltip('Player schließen'),
        findsOneWidget,
        reason:
            'Im Fehlerfall sollte der Close-Button mit Tooltip sichtbar sein',
      );
    },
  );

  testWidgets(
      'BottomPlayerWidget ist robust gegen State-Wechsel und UI-Änderungen', (
    tester,
  ) async {
    // Korrekt: Bloc erwartet IAudioPlayerBackend, nicht AudioHandler
    final mockBackend = MockAudioPlayerBackend();
    when(() => mockBackend.play()).thenAnswer((_) async {});
    when(() => mockBackend.pause()).thenAnswer((_) async {});
    when(() => mockBackend.stop()).thenAnswer((_) async {});
    when(() => mockBackend.seek(any())).thenAnswer((_) async {});
    when(() => mockBackend.setSpeed(any())).thenAnswer((_) async {});
    when(() => mockBackend.position).thenReturn(Duration.zero);
    when(() => mockBackend.duration).thenReturn(const Duration(seconds: 60));
    when(() => mockBackend.speed).thenReturn(1.0);
    when(() => mockBackend.playing).thenReturn(false);
    when(() => mockBackend.positionStream).thenAnswer((_) => Stream.value(Duration.zero));
    when(() => mockBackend.durationStream).thenAnswer((_) => Stream.value(const Duration(seconds: 60)));
    when(() => mockBackend.playerStateStream).thenAnswer((_) => Stream.value('paused'));
    final bloc = AudioPlayerBloc(backend: mockBackend);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerBlocProvider.overrideWithValue(bloc)],
        child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
      ),
    );
    // Initial: Idle
    expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
    expect(find.byIcon(Icons.pause_circle_filled), findsNothing);
    // Wechsel zu Playing
    bloc.emit(Playing(Duration(seconds: 5), Duration(seconds: 60)));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.pause_circle_filled), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_fill), findsNothing);
  });
}
