import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'bottom_player_speed_dropdown.dart';

/// Zeigt Titel und Collection-Name der aktuellen Episode im Player.
class BottomPlayerTitleCollection extends StatelessWidget {
  final String title;
  final String collectionName;
  final String artworkUrl;
  final double currentSpeed;
  final List<double> speedOptions;
  final ValueChanged<double> onSpeedChanged;

  const BottomPlayerTitleCollection({
    super.key,
    required this.title,
    required this.collectionName,
    required this.artworkUrl,
    required this.currentSpeed,
    required this.speedOptions,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedCollectionName =
        _formatCollectionNameForLineBreak(collectionName);
    return Row(
      children: [
        if (artworkUrl.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.only(top: 12), // Cover nach unten eingerückt
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                artworkUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.music_note, color: Colors.grey),
                ),
              ),
            ),
          ),
        if (artworkUrl.isEmpty)
          Padding(
            padding:
                const EdgeInsets.only(top: 12), // Cover nach unten eingerückt
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.music_note, color: Colors.grey),
            ),
          ),
        const SizedBox(width: 18),
        // Titel (Marquee) und SpeedDropdown in einer Zeile
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titel (Marquee) und Collection-Name untereinander
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 22,
                        child: Marquee(
                          text: title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface.withAlpha(100),
                          ),
                          blankSpace: 24.0,
                          velocity: 28.0,
                          pauseAfterRound: const Duration(seconds: 3),
                          accelerationDuration:
                              const Duration(milliseconds: 600),
                          accelerationCurve: Curves.easeIn,
                          decelerationDuration:
                              const Duration(milliseconds: 600),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 4),
                        child: Text(
                          formattedCollectionName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(120),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    width: 16), // Mehr Luft zwischen Marquee und SpeedDropdown
                // SpeedDropdown rechtsbündig, aber mit flexibler Breite
                IntrinsicWidth(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: BottomPlayerSpeedDropdown(
                      currentSpeed: currentSpeed,
                      speedOptions: speedOptions,
                      onSpeedChanged: onSpeedChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Bricht collectionName an Trennzeichen um, falls zu lang
  String _formatCollectionNameForLineBreak(String name, {int threshold = 30}) {
    if (name.length < threshold) return name;
    final delimiters = [':', '-', '|', '/', ','];
    for (var d in delimiters) {
      if (name.contains(d)) {
        final parts = name.split(d);
        if (parts.length > 1) {
          return '${parts[0]}$d\n${parts.sublist(1).join(d).trim()}';
        }
      }
    }
    return name;
  }
}
