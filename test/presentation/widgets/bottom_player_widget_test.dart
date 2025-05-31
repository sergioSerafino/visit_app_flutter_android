import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empty_flutter_template/presentation/widgets/bottom_player_widget.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'package:empty_flutter_template/core/services/i_audio_player.dart';
import 'package:empty_flutter_template/application/providers/audio_player_provider.dart';

class MockAudioPlayerBackend extends Mock implements IAudioPlayerBackend {}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  testWidgets(
    'BottomPlayerWidget Integration: Play mit echter OpaliaTalk-Episode',
    (WidgetTester tester) async {
      final backend = MockAudioPlayerBackend();
      final positionController = StreamController<Duration>.broadcast();
      final durationController = StreamController<Duration?>.broadcast();
      final playerStateController = StreamController<dynamic>.broadcast();
      when(() => backend.positionStream)
          .thenAnswer((_) => positionController.stream);
      when(() => backend.durationStream)
          .thenAnswer((_) => durationController.stream);
      when(() => backend.playerStateStream)
          .thenAnswer((_) => playerStateController.stream);
      when(() => backend.position).thenReturn(Duration.zero);
      when(() => backend.duration).thenReturn(Duration(seconds: 60));
      when(() => backend.playing).thenReturn(false);
      when(() => backend.dispose()).thenReturn(null);

      final bloc = AudioPlayerBloc(backend: backend);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [audioPlayerBlocProvider.overrideWithValue(bloc)],
          child: MaterialApp(
            home: Scaffold(
              body: BottomPlayerWidget(
                onClose:
                    () {}, // Callback gesetzt, damit Close-Button sichtbar ist
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
      // Cleanup
      await positionController.close();
      await durationController.close();
      await playerStateController.close();
    },
  );

  testWidgets(
      'BottomPlayerWidget ist robust gegen State-Wechsel und UI-Änderungen', (
    tester,
  ) async {
    final backend = MockAudioPlayerBackend();
    when(() => backend.positionStream).thenAnswer((_) => const Stream.empty());
    when(() => backend.durationStream).thenAnswer((_) => const Stream.empty());
    when(() => backend.playerStateStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => backend.position).thenReturn(Duration(seconds: 0));
    when(() => backend.duration).thenReturn(Duration(seconds: 60));
    when(() => backend.playing).thenReturn(false);
    when(() => backend.dispose()).thenReturn(null);
    final bloc = AudioPlayerBloc(backend: backend);
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
