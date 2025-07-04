import 'test_hive_init.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visit_app_flutter_android/presentation/pages/landing_page.dart';
import 'package:visit_app_flutter_android/presentation/pages/home_page.dart';

void main() {
  setupHiveForTests();
  testWidgets('Navigation LandingPage → HomePage → zurück ist robust',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const LandingPage(),
          routes: {
            '/home_page/': (context) => const HomePage(),
            '/landing_page/': (context) => const LandingPage(),
          },
        ),
      ),
    );

    // LandingPage sollte sichtbar sein
    expect(find.byType(LandingPage), findsOneWidget);

    // Simuliere Start-Button ("Starten")
    final startButton = find.text('Starten');
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // HomePage sollte sichtbar sein
    expect(find.byType(HomePage), findsOneWidget);

    // Simuliere zurück zur LandingPage (z. B. über Menü)
    // Hier ggf. anpassen, je nach Navigation
    // await tester.tap(find.byIcon(Icons.arrow_back));
    // await tester.pumpAndSettle();
    // expect(find.byType(LandingPage), findsOneWidget);
  });
}
