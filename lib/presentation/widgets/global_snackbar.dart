import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/messaging/snackbar_event.dart';
import '../../core/messaging/snackbar_manager.dart';

class GlobalSnackbarListener extends ConsumerWidget {
  final Widget child;
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  const GlobalSnackbarListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SnackbarEvent?>(snackbarManagerProvider, (previous, next) {
      if (next != null) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(next.message),
            duration: next.duration,
            backgroundColor: _colorForType(next.type),
          ),
        );
      }
    });
    return child;
  }

  Color _colorForType(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.success:
        return Colors.green;
      case SnackbarType.warning:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
