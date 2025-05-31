import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/collection_provider.dart';
import '../../core/messaging/snackbar_event.dart';
import '../../core/messaging/snackbar_manager.dart';
import '../../domain/models/branding_model.dart';

// Zeigt Snackbars aus zentralem Stream/Notifier
// UI-Komponente, evtl. als „GlobalLayer“ oder über app.dart
class GlobalSnackbarListener extends ConsumerWidget {
  final Widget child;
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  const GlobalSnackbarListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(brandingProvider);

    ref.listen<SnackbarEvent?>(snackbarManagerProvider, (previous, next) {
      if (next != null) {
        final formattedMessage = _formatMessageForLineBreak(next.message);
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                if (next.emoji != null)
                  Text(next.emoji!, style: const TextStyle(fontSize: 24)),
                if (next.emoji != null) const SizedBox(width: 12),
                if (next.icon != null && next.emoji == null)
                  Icon(next.icon, color: Colors.white),
                if (next.icon != null && next.emoji == null)
                  const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedMessage,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            backgroundColor: _colorForType(next.type, branding),
            duration: next.duration,
          ),
        );
      }
    });
    return child;
  }

  Color _colorForType(SnackbarType type, Branding branding) {
    switch (type) {
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.success:
        return _parseHexColor(branding.primaryColorHex) ?? Colors.green;
      case SnackbarType.warning:
        return Colors.orange;
      default:
        return _parseHexColor(branding.secondaryColorHex) ?? Colors.blue;
    }
  }

  Color? _parseHexColor(String? hex) {
    if (hex == null) return null;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

String _formatMessageForLineBreak(String formatMes, {int threshold = 30}) {
  if (formatMes.length < threshold) return formatMes;

  final delimiters = [
    ':',
    '-',
    '|',
    '/',
    ',',
    '!',
    '?',
  ]; // beliebig erweiterbar
  for (var d in delimiters) {
    if (formatMes.contains(d)) {
      final parts = formatMes.split(d);
      if (parts.length > 1) {
        return '${parts[0]}$d\n${parts.sublist(1).join(d).trim()}';
      }
    }
  }
  return formatMes;
}
