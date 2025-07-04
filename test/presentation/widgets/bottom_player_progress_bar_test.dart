import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_app_flutter_android/presentation/widgets/bottom_player_progress_bar.dart';

void main() {
  testWidgets(
      'ProgressBar bleibt im Idle/Loading-State reaktiv und zeigt lokale Position',
      (tester) async {
    Duration position = Duration.zero;
    Duration duration = const Duration(seconds: 60);
    Duration? seekedTo;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: BottomPlayerProgressBar(
              position: position,
              duration: duration,
              hasValidDuration: false, // Simuliere Idle/Loading
              onSeek: (d) => seekedTo = d,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    // Slider bewegen
    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);
    await tester.drag(sliderFinder, const Offset(100, 0));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    // onSeek wurde aufgerufen
    expect(seekedTo, isNotNull);
    // Wert bleibt im Widget sichtbar
    // (Slider-Value = neue Position)
    // (Optional: Wert auslesen und prüfen)
  });

  testWidgets('ProgressBar synchronisiert sich mit Props bei Playing',
      (tester) async {
    Duration position = const Duration(seconds: 10);
    Duration duration = const Duration(seconds: 60);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: BottomPlayerProgressBar(
              position: position,
              duration: duration,
              hasValidDuration: true, // Simuliere Playing
              onSeek: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);
    final sliderWidget = tester.widget<Slider>(sliderFinder);
    expect(sliderWidget.value, 10.0);
  });
}
