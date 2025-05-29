import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/messaging/snackbar_manager.dart';

class DemoSnackbarButton extends ConsumerWidget {
  const DemoSnackbarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(snackbarManagerProvider.notifier).showByKey('welcome_back');
      },
      child: const Text('Snackbar auslösen'),
    );
  }
}
