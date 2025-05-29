// Dies ist ein grundlegender Flutter Widget-Test.
//
// Um eine Interaktion mit einem Widget in Ihrem Test durchzuführen, verwenden Sie das WidgetTester-
// Hilfsobjekt aus dem flutter_test-Paket. Zum Beispiel können Sie Tipp- und Scrollgesten senden.
// Sie können WidgetTester auch verwenden, um untergeordnete Widgets im Widget-Baum zu finden,
// Text zu lesen und zu überprüfen, ob die Werte von Widget-Eigenschaften korrekt sind.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:template/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Unsere App bauen und einen Frame auslösen.
    await tester.pumpWidget(const MyApp());

    // Überprüfen, ob unser Zähler bei 0 startet.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Das '+'-Symbol antippen und einen Frame auslösen.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Überprüfen, ob unser Zähler erhöht wurde.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
