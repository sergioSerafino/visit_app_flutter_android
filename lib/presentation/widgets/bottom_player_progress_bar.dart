import 'package:flutter/material.dart';

/// Fortschrittsbalken für den Audio-Player (Slider + Zeit-Anzeige)
/// Kapselt die Logik für Position, Dauer und Slider-Interaktion.
class BottomPlayerProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final bool hasValidDuration;
  final ValueChanged<Duration> onSeek;

  const BottomPlayerProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.hasValidDuration,
    required this.onSeek,
  });

  String _formatDurationMMSS(int millis) {
    final totalSeconds = (millis / 1000).round();
    final hours = (totalSeconds ~/ 3600);
    final minutes = ((totalSeconds % 3600) ~/ 60);
    final seconds = totalSeconds % 60;
    return '${hours.toString()}h '
        '${minutes.toString().padLeft(2, '0')}m '
        '${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leftTime = _formatDurationMMSS(position.inMilliseconds);
    final rightTime = hasValidDuration
        ? '-${_formatDurationMMSS((duration - position).inMilliseconds)}'
        : '0h 0m 0s';
    final isSliderEnabled = hasValidDuration;
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(
            leftTime,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withAlpha(140),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Semantics(
            label: hasValidDuration
                ? 'Fortschritt: ${position.inSeconds} Sekunden von ${duration.inSeconds} Sekunden'
                : 'Kein Fortschritt verfügbar',
            value: leftTime,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: theme.colorScheme.primary.withAlpha(140),
                inactiveTrackColor:
                    theme.colorScheme.surfaceContainerHighest.withAlpha(140),
                thumbColor: theme.colorScheme.primary.withAlpha(180),
                overlayColor: theme.colorScheme.primary.withAlpha(32),
                trackHeight: 14,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: theme.colorScheme.primary.withAlpha(180),
                showValueIndicator: ShowValueIndicator.onlyForContinuous,
              ),
              child: Slider(
                value: hasValidDuration && position.inSeconds >= 0
                    ? position.inSeconds.clamp(0, duration.inSeconds).toDouble()
                    : 0.0,
                max: hasValidDuration ? duration.inSeconds.toDouble() : 1.0,
                divisions: hasValidDuration ? duration.inSeconds : null,
                label: leftTime,
                onChanged: isSliderEnabled
                    ? (v) => onSeek(Duration(seconds: v.toInt()))
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 85,
          child: Text(
            rightTime,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withAlpha(140),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
