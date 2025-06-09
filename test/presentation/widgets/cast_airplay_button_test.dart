import 'package:flutter_test/flutter_test.dart';
import 'package:empty_flutter_template/presentation/widgets/cast_airplay_button.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('CastAirPlayButton zeigt Icon und Status korrekt', (
    tester,
  ) async {
    // Nicht verfügbar
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CastAirPlayButton()),
      ),
    );
    expect(find.byIcon(Icons.cast), findsOneWidget);
    final btn1 = tester.widget<IconButton>(find.byType(IconButton));
    expect(btn1.onPressed, isNull);

    // Verfügbar, nicht verbunden
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CastAirPlayButton(
            isAvailable: true,
            onPressed: () {},
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.cast), findsOneWidget);
    final btn2 = tester.widget<IconButton>(find.byType(IconButton));
    expect(btn2.onPressed, isNotNull);

    // Verfügbar, verbunden
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CastAirPlayButton(
            isAvailable: true,
            isConnected: true,
            onPressed: () {},
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.cast_connected), findsOneWidget);
    final btn3 = tester.widget<IconButton>(find.byType(IconButton));
    expect(btn3.onPressed, isNotNull);
  });

  testWidgets('CastAirPlayButton reagiert robust auf State-Wechsel', (
    tester,
  ) async {
    // Start: nicht verfügbar
    Widget build(bool available, bool connected) => MaterialApp(
          home: Scaffold(
            body: CastAirPlayButton(
              isAvailable: available,
              isConnected: connected,
              onPressed: available ? () {} : null,
            ),
          ),
        );
    await tester.pumpWidget(build(false, false));
    expect(find.byIcon(Icons.cast), findsOneWidget);
    final btn1 = tester.widget<IconButton>(find.byType(IconButton));
    expect(btn1.onPressed, isNull);

    // Wechsel: verfügbar, nicht verbunden
    await tester.pumpWidget(build(true, false));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    expect(find.byIcon(Icons.cast), findsOneWidget);
    final btn2 = tester.widget<IconButton>(find.byType(IconButton));
    expect(btn2.onPressed, isNotNull);

    // Wechsel: verbunden
    await tester.pumpWidget(build(true, true));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    expect(find.byIcon(Icons.cast_connected), findsOneWidget);
    final btn3 = tester.widget<IconButton>(find.byType(IconButton));
    expect(btn3.onPressed, isNotNull);

    // Wechsel zurück: nicht verfügbar
    await tester.pumpWidget(build(false, false));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    expect(find.byIcon(Icons.cast), findsOneWidget);
    final btn4 = tester.widget<IconButton>(find.byType(IconButton));
    expect(btn4.onPressed, isNull);
  });
}
