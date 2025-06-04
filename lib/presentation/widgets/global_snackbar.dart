import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empty_flutter_template/application/providers/theme_provider.dart'
    as theme_prov;
import 'package:empty_flutter_template/core/messaging/snackbar_event.dart';
import 'package:empty_flutter_template/core/messaging/snackbar_manager.dart';
import 'package:empty_flutter_template/domain/models/branding_model.dart';

// Zeigt Snackbars aus zentralem Stream/Notifier
// UI-Komponente, evtl. als „GlobalLayer“ oder über app.dart
class GlobalSnackbarListener extends ConsumerWidget {
  final Widget child;
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  const GlobalSnackbarListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(theme_prov.brandingProvider);

    ref.listen<SnackbarEvent?>(snackbarManagerProvider, (previous, next) {
      if (next != null) {
        debugPrint('[Snackbar] Event empfangen: ${next.message}');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final messenger = scaffoldMessengerKey.currentState;
          if (messenger != null) {
            final formattedMessage = _formatMessageForLineBreak(next.message);
            messenger.showSnackBar(
              SnackBar(
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Immer ein Icon/Emoji-Container links anzeigen (mit Fallback)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: next.emoji != null
                            ? Text(next.emoji!,
                                style: const TextStyle(fontSize: 24))
                            : (next.icon != null
                                ? Icon(next.icon, color: Colors.white)
                                : Icon(Icons.info_outline,
                                    color: Colors.white)),
                      ),
                    ),
                    // Message immer sichtbar, mit flexiblem Zeilenumbruch
                    Expanded(
                      child: Text(
                        formattedMessage,
                        style: TextStyle(
                          fontSize: 20,
                          color: _textColorForSnackbar(next.type, branding),
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                backgroundColor: _colorForType(next.type, branding),
                duration: next.duration,
              ),
            );
            debugPrint('[Snackbar] Angezeigt: ${next.message}');
          } else {
            debugPrint('[Snackbar] ScaffoldMessenger nicht bereit!');
          }
        });
      }
    });
    return child;
  }

  Color _colorForType(SnackbarType type, Branding branding) {
    switch (type) {
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.success:
        return (/*_parseHexColor(branding.primaryColorHex) ??*/ Colors.green);
      // .withAlpha(180);
      case SnackbarType.warning:
        return Colors.orange.withAlpha(180);
      case SnackbarType.info:
        return (_parseHexColor(branding.secondaryColorHex) ?? Colors.blue);
      // .withAlpha(180);
    }
  }

  Color? _parseHexColor(String? hex) {
    if (hex == null) return null;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Color _textColorForSnackbar(SnackbarType type, Branding branding) {
    final bg = _colorForType(type, branding);
    // Schwellwert: Wenn der Hintergrund "mittelhell" ist, trotzdem weiß bevorzugen
    // (z.B. für Branding mit hellen, aber nicht weißen Farben)
    final double luminance = bg.computeLuminance();
    // 0 = schwarz, 1 = weiß. Schwelle z.B. 0.6 (Flutter-Standard ist 0.5)
    if (luminance > 0.6) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}

String _formatMessageForLineBreak(String formatMes, {int threshold = 30}) {
  if (formatMes.length < threshold) return formatMes;

  final delimiters = [
    ':',
    //'-',
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
