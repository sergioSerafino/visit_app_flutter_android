import 'package:flutter/material.dart';

/// Cast/AirPlay-Button für Audio-Player-UI
///
/// Zeigt je nach Plattform und Verfügbarkeit einen Cast- oder AirPlay-Button an.
/// Statusanzeige: verbunden, nicht verbunden, Fehler.
///
/// Die eigentliche Integration (Discovery, Events) erfolgt später über Service/Provider.
class CastAirPlayButton extends StatelessWidget {
  final bool isAvailable;
  final bool isConnected;
  final String? statusText;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;

  const CastAirPlayButton({
    super.key,
    this.isAvailable = false,
    this.isConnected = false,
    this.statusText,
    this.onPressed,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isConnected ? Icons.cast_connected : Icons.cast,
        color: iconColor ??
            (isAvailable
                ? (isConnected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withAlpha(180))
                : Theme.of(context).disabledColor),
        size: iconSize ?? 32,
      ),
      tooltip:
          statusText ?? (isConnected ? 'Verbunden' : 'Mit Gerät verbinden'),
      onPressed: isAvailable ? onPressed : null,
    );
  }
}
