import 'package:flutter/material.dart';

/// Overlay für Lade- und Preload-Zustände im Player.
class BottomPlayerOverlay extends StatelessWidget {
  final Widget playerContent;
  final ThemeData theme;
  final bool showLoadingOverlay;

  const BottomPlayerOverlay({
    super.key,
    required this.playerContent,
    required this.theme,
    required this.showLoadingOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        playerContent,
        if (showLoadingOverlay)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: LinearProgressIndicator(
                minHeight: 4,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(
                    theme.colorScheme.primary.red,
                    theme.colorScheme.primary.green,
                    theme.colorScheme.primary.blue,
                    0.18,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
