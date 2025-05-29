import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/widgets/demo_snackbar_button.dart';
import 'presentation/widgets/global_snackbar.dart';

// Einstiegspunkt für das leere Flutter-Template.
// Hier können App-Initialisierung und grundlegende Konfiguration erfolgen.

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalSnackbarListener(
      child: MaterialApp(
        scaffoldMessengerKey: GlobalSnackbarListener.scaffoldMessengerKey,
        title: 'empty_flutter_template',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(
            child: DemoSnackbarButton(),
          ),
        ), // Leeres Widget als Ausgangspunkt
      ),
    );
  }
}

// Beispiel für einen auskommentierten Provider (siehe Doku):
// final exampleProvider = Provider<int>((ref) => 0);
