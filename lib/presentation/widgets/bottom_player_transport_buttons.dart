import 'package:flutter/material.dart';

/// Transport-Buttons für den Audio-Player (Zurück, Play/Pause, Vor, Reset, Lautstärke)
class BottomPlayerTransportButtons extends StatelessWidget {
  final bool isPlaying;
  final bool isPlayPauseButtonEnabled;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onRewind;
  final VoidCallback onForward;
  final Widget volumeButton;

  const BottomPlayerTransportButtons({
    super.key,
    required this.isPlaying,
    required this.isPlayPauseButtonEnabled,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onReset,
    required this.onRewind,
    required this.onForward,
    required this.volumeButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset-Button
        IconButton(
          icon: Icon(Icons.refresh,
              color: theme.colorScheme.onSurface.withAlpha(140)),
          iconSize: 24,
          tooltip: 'Player zurücksetzen',
          onPressed: onReset,
        ),
        const SizedBox(width: 8),
        // Zentrale Transport-Buttons
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: '10 Sekunden zurück',
                button: true,
                child: IconButton(
                  icon: Icon(Icons.replay_10,
                      color: theme.colorScheme.onSurface.withAlpha(140)),
                  iconSize: 32,
                  onPressed: onRewind,
                  tooltip: '10 Sekunden zurück',
                ),
              ),
              const SizedBox(width: 32),
              Semantics(
                label: isPlaying ? 'Pause' : 'Wiedergabe starten',
                button: true,
                child: IconButton(
                  key: const Key('player_play_pause_button'),
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: theme.colorScheme.onSurface.withAlpha(140),
                    size: 56,
                  ),
                  iconSize: 56,
                  onPressed: isPlayPauseButtonEnabled ? onPlayPause : null,
                  tooltip: isPlaying ? 'Pause' : 'Wiedergabe starten',
                ),
              ),
              const SizedBox(width: 32),
              Semantics(
                label: '10 Sekunden vor',
                button: true,
                child: IconButton(
                  icon: Icon(Icons.forward_10,
                      color: theme.colorScheme.onSurface.withAlpha(140)),
                  iconSize: 32,
                  onPressed: onForward,
                  tooltip: '10 Sekunden vor',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Lautstärke-Button (Overlay)
        volumeButton,
      ],
    );
  }
}
