import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestSnackbarWidget extends StatelessWidget {
  const _TestSnackbarWidget();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Test-Snackbar: Collection 123')),
            );
          },
          child: const Text('Snackbar auslösen'),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Snackbar wird direkt angezeigt', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: _TestSnackbarWidget()));
    await tester.tap(find.text('Snackbar auslösen'));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Test-Snackbar'), findsOneWidget);
  });
}
