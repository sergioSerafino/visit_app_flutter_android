// lib/presentation/pages/snackbar_debug_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/messaging/snackbar_manager.dart';

class SnackbarDebugPage extends ConsumerWidget {
  const SnackbarDebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Snackbar Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                ref
                    .read(snackbarManagerProvider.notifier)
                    .showByKey('demo_mode_active');
              },
              child: const Text("Snackbar anzeigen"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(snackbarManagerProvider.notifier)
                    .showByKey('offline_download_success');
              },
              child: const Text("Noch eine Snackbar anzeigen"),
            ),
            const SizedBox(height: 32),
            Text(
              "Wenn du hier klickst, sollte die Snackbar korrekt und global erscheinen.\n"
              "Sie muss über der BottomNavigationBar erscheinen (wenn vorhanden).",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
