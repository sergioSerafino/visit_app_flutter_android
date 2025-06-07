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
    return Row(
      children: [
        if (artworkUrl.isNotEmpty)
          ClipRRect(
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
        if (artworkUrl.isEmpty)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note, color: Colors.grey),
          ),

        const SizedBox(width: 18),
        // Titel (Marquee) und SpeedDropdown in einer Zeile
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 16), // Gesamten Block weiter nach unten verschieben
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titel (Marquee) und Collection-Name untereinander
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 22,
                            child: Marquee(
                              text: title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    theme.colorScheme.onSurface.withAlpha(100),
                              ),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              blankSpace: 24.0,
                              velocity: 28.0,
                              pauseAfterRound: const Duration(seconds: 3),
                              startPadding: 0.0,
                              accelerationDuration:
                                  const Duration(milliseconds: 600),
                              accelerationCurve: Curves.easeIn,
                              decelerationDuration:
                                  const Duration(milliseconds: 600),
                              decelerationCurve: Curves.easeOut,
                              showFadingOnlyWhenScrolling: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2, left: 4, right: 4),
                            child: Text(
                              collectionName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    theme.colorScheme.onSurface.withAlpha(120),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    // SpeedDropdown rechts
                    BottomPlayerSpeedDropdown(
                      currentSpeed: currentSpeed,
                      speedOptions: speedOptions,
                      onSpeedChanged: onSpeedChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
