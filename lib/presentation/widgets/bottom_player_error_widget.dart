import 'package:flutter/material.dart';

/// Fehleranzeige für den Audio-Player.
class BottomPlayerErrorWidget extends StatelessWidget {
  final ThemeData theme;
  final String message;
  final VoidCallback? onClose;

  const BottomPlayerErrorWidget({
    super.key,
    required this.theme,
    required this.message,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(80),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              if (onClose != null) ...[
                const SizedBox(height: 16),
                Semantics(
                  label: 'Player schließen',
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: onClose,
                    tooltip: 'Player schließen',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
