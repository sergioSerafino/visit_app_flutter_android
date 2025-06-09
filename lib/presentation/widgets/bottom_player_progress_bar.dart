import 'package:flutter/material.dart';

/// Fortschrittsbalken für den Audio-Player (Slider + Zeit-Anzeige)
/// Kapselt die Logik für Position, Dauer und Slider-Interaktion.
class BottomPlayerProgressBar extends StatefulWidget {
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

  @override
  State<BottomPlayerProgressBar> createState() =>
      _BottomPlayerProgressBarState();
}

class _BottomPlayerProgressBarState extends State<BottomPlayerProgressBar> {
  late Duration _position;
  late Duration _duration;
  bool _isDragging = false;
  Duration? _pendingPosition;

  @override
  void initState() {
    super.initState();
    _position = widget.position;
    _duration = widget.duration;
  }

  @override
  void didUpdateWidget(covariant BottomPlayerProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nur bei aktivem Stream synchronisieren
    if (widget.hasValidDuration && !_isDragging && _pendingPosition == null) {
      if (_position != widget.position || _duration != widget.duration) {
        setState(() {
          _position = widget.position;
          _duration = widget.duration;
        });
      }
    }
    // Nach Drag: Wenn der State-Position der Pending entspricht, Drag zurücksetzen
    if (_pendingPosition != null &&
        (widget.position - _pendingPosition!).inSeconds.abs() < 1) {
      setState(() {
        _isDragging = false;
        _pendingPosition = null;
      });
    }
    // NEU: Im Idle/Loading-State (hasValidDuration==false) immer auf 0 synchronisieren
    if (!widget.hasValidDuration && _position != Duration.zero) {
      setState(() {
        _position = Duration.zero;
        _duration = widget.duration;
      });
    }
  }

  String _formatDurationMMSS(int millis) {
    final totalSeconds = (millis / 1000).round();
    final hours = (totalSeconds ~/ 3600);
    final minutes = ((totalSeconds % 3600) ~/ 60);
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours}h '
          '${minutes.toString().padLeft(2, '0')}m '
          '${seconds.toString().padLeft(2, '0')}s';
    } else {
      return '${minutes}m '
          '${seconds.toString().padLeft(2, '0')}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leftTime = _formatDurationMMSS(_position.inMilliseconds);
    final rightTime = widget.hasValidDuration
        ? '-${_formatDurationMMSS((_duration - _position).inMilliseconds)}'
        : '0h 0m 0s';
    final isSliderEnabled = widget.hasValidDuration;
    return Transform.translate(
      offset: const Offset(0, 8), // Leicht nach unten verschoben
      child: Row(
        children: [
          SizedBox(
            width: 70,
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
              label: widget.hasValidDuration
                  ? 'Fortschritt: ${_position.inSeconds} Sekunden von ${_duration.inSeconds} Sekunden'
                  : 'Kein Fortschritt verfügbar',
              value: leftTime,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: theme.colorScheme.primary.withAlpha(140),
                  inactiveTrackColor:
                      theme.colorScheme.surfaceContainerHighest.withAlpha(140),
                  thumbColor: theme.colorScheme.primary.withAlpha(180),
                  overlayColor: theme.colorScheme.primary.withAlpha(24),
                  trackHeight: 14,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 9),
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: theme.colorScheme.primary.withAlpha(180),
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Slider(
                  value: isSliderEnabled
                      ? (_isDragging
                          ? _position.inSeconds.toDouble()
                          : widget.position.inSeconds
                              .clamp(0, widget.duration.inSeconds)
                              .toDouble())
                      : 0.0, // Im Idle/Loading-State immer 0.0
                  max: isSliderEnabled
                      ? widget.duration.inSeconds.toDouble()
                      : 1.0,
                  divisions: isSliderEnabled ? widget.duration.inSeconds : null,
                  label: leftTime,
                  onChanged: isSliderEnabled
                      ? (v) {
                          setState(() {
                            _position = Duration(seconds: v.toInt());
                            _isDragging = true;
                          });
                        }
                      : null, // Im Idle/Loading-State nicht bedienbar
                  onChangeEnd: isSliderEnabled
                      ? (v) {
                          final newPos = Duration(seconds: v.toInt());
                          _pendingPosition = newPos;
                          widget.onSeek(newPos);
                          if (!isSliderEnabled) {
                            setState(() {
                              _isDragging = false;
                              _pendingPosition = null;
                              _position = newPos;
                            });
                          }
                        }
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 82,
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
      ),
    );
  }
}
