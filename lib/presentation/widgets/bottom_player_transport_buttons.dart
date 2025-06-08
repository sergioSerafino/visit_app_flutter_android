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
  final bool isLoading;

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
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset-Button
          IconButton(
            icon: Icon(Icons.refresh,
                color: theme.colorScheme.onSurface.withAlpha(140)),
            iconSize: 24,
            tooltip: 'Player zurücksetzen',
            onPressed: isLoading ? null : onReset,
          ),
          const SizedBox(width: 8),
          // Zentrale Transport-Buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
              child: IntrinsicWidth(
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
                        onPressed: isLoading ? null : onRewind,
                        tooltip: '10 Sekunden zurück',
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Play/Pause oder Loader
                    if (isLoading)
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: Center(
                          child: Semantics(
                            label: 'Wird geladen…',
                            button: true,
                            child: AbsorbPointer(
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color:
                                    theme.colorScheme.onSurface.withAlpha(140),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Semantics(
                        label: isPlaying ? 'Pause' : 'Wiedergabe starten',
                        button: true,
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Center(
                            child: IconButton(
                              key: const Key('player_play_pause_button'),
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                                color:
                                    theme.colorScheme.onSurface.withAlpha(140),
                                size: 56,
                              ),
                              iconSize: 56,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              constraints: const BoxConstraints(),
                              onPressed:
                                  isPlayPauseButtonEnabled ? onPlayPause : null,
                              tooltip:
                                  isPlaying ? 'Pause' : 'Wiedergabe starten',
                            ),
                          ),
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
                        onPressed: isLoading ? null : onForward,
                        tooltip: '10 Sekunden vor',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Lautstärke-Button (Overlay)
          AbsorbPointer(
            absorbing: isLoading,
            child: volumeButton,
          ),
        ],
      ),
    );
  }
}
