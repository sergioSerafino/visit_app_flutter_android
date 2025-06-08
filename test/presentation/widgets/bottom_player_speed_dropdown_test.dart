import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empty_flutter_template/presentation/widgets/bottom_player_speed_dropdown.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empty_flutter_template/application/providers/audio_player_provider.dart';

class MockAudioPlayerBloc extends Mock implements AudioPlayerBloc {}

void main() {
  test('Debug: main() wird ausgeführt', () {
    print('DEBUG: main() in bottom_player_speed_dropdown_test.dart läuft!');
    expect(1, 1);
  });

  setUpAll(() {
    registerFallbackValue(Idle());
  });

  testWidgets('SpeedDropdown zeigt initialen Wert und reagiert auf Auswahl',
      (tester) async {
    final mockBloc = MockAudioPlayerBloc();
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(Idle()));
    when(() => mockBloc.state).thenReturn(Idle());
    double selectedSpeed = 1.0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerBlocProvider.overrideWithValue(mockBloc)],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: BottomPlayerSpeedDropdown(
                  currentSpeed: 1.0,
                  speedOptions: const [0.5, 1.0, 1.5, 2.0],
                  onSpeedChanged: (v) => selectedSpeed = v,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Dropdown zeigt initial 1.0x
    expect(find.text('1.0x '), findsOneWidget);
    // Dropdown öffnen und 1.5x auswählen
    await tester.tap(find.byType(DropdownButton<double>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1.5x ').last);
    await tester.pumpAndSettle();
    expect(selectedSpeed, 1.5);
  });

  testWidgets(
      'SpeedDropdown bleibt im Idle/Loading-State reaktiv (lokaler State)',
      (tester) async {
    final mockBloc = MockAudioPlayerBloc();
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(Idle()));
    when(() => mockBloc.state).thenReturn(Idle());
    double selectedSpeed = 1.0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerBlocProvider.overrideWithValue(mockBloc)],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: BottomPlayerSpeedDropdown(
                  currentSpeed: 1.0,
                  speedOptions: const [0.5, 1.0, 1.5, 2.0],
                  onSpeedChanged: (v) => selectedSpeed = v,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Dropdown öffnen und 2.0x auswählen
    await tester.tap(find.byType(DropdownButton<double>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2.0x ').last);
    await tester.pumpAndSettle();
    expect(selectedSpeed, 2.0);
    // Wert bleibt im Widget sichtbar
    expect(find.text('2.0x '), findsOneWidget);
  });

  testWidgets('SpeedDropdown synchronisiert sich mit Bloc-State bei Playing',
      (tester) async {
    final mockBloc = MockAudioPlayerBloc();
    final playingState =
        Playing(const Duration(), const Duration(seconds: 60), speed: 1.5);
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(playingState));
    when(() => mockBloc.state).thenReturn(playingState);
    double selectedSpeed = 1.0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [audioPlayerBlocProvider.overrideWithValue(mockBloc)],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: BottomPlayerSpeedDropdown(
                  currentSpeed: 1.0,
                  speedOptions: const [0.5, 1.0, 1.5, 2.0],
                  onSpeedChanged: (v) => selectedSpeed = v,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Wert aus Bloc-State wird angezeigt
    expect(find.text('1.5x '), findsOneWidget);
  });
}
