import 'package:flutter/material.dart';
import '../../core/utils/bottom_player_transport_buttons_constants.dart';

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
  final bool isActiveEpisode;

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
    this.isActiveEpisode = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          0, 0, 0, BottomPlayerTransportButtonsConstants.paddingBottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset-Button
          IconButton(
            icon: Icon(Icons.refresh,
                color: isActiveEpisode
                    ? BottomPlayerTransportButtonsConstants.neutralIconColor
                        .withAlpha(BottomPlayerTransportButtonsConstants
                            .neutralIconAlpha)
                    : theme.disabledColor),
            iconSize: BottomPlayerTransportButtonsConstants.resetButtonSize,
            tooltip: 'Player zurücksetzen',
            // NEU: Reset NIE blockieren, wenn Episode explizit geladen
            onPressed: isActiveEpisode ? onReset : null,
          ),
          const SizedBox(
              width: BottomPlayerTransportButtonsConstants.buttonSpacing),
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
                            color: isActiveEpisode
                                ? BottomPlayerTransportButtonsConstants
                                    .neutralIconColor
                                    .withAlpha(
                                        BottomPlayerTransportButtonsConstants
                                            .neutralIconAlpha)
                                : theme.disabledColor),
                        iconSize: BottomPlayerTransportButtonsConstants
                            .iconButtonSize,
                        onPressed:
                            isLoading || !isActiveEpisode ? null : onRewind,
                        tooltip: '10 Sekunden zurück',
                      ),
                    ),
                    const SizedBox(
                        width: BottomPlayerTransportButtonsConstants
                            .centralButtonSpacing),
                    // Play/Pause oder Loader
                    if (isLoading)
                      SizedBox(
                        width: BottomPlayerTransportButtonsConstants
                            .playPauseButtonSize,
                        height: BottomPlayerTransportButtonsConstants
                            .playPauseButtonSize,
                        child: Center(
                          child: Semantics(
                            label: 'Wird geladen…',
                            button: true,
                            child: AbsorbPointer(
                              child: CircularProgressIndicator(
                                strokeWidth:
                                    BottomPlayerTransportButtonsConstants
                                        .loaderStrokeWidth,
                                color: isActiveEpisode
                                    ? theme.colorScheme.onSurface.withAlpha(140)
                                    : theme.disabledColor,
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
                          width: BottomPlayerTransportButtonsConstants
                              .playPauseButtonSize,
                          height: BottomPlayerTransportButtonsConstants
                              .playPauseButtonSize,
                          child: Center(
                            child: IconButton(
                              key: const Key('player_play_pause_button'),
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                                color: isActiveEpisode
                                    ? theme.colorScheme.onSurface.withAlpha(140)
                                    : theme.disabledColor,
                                size: BottomPlayerTransportButtonsConstants
                                    .playPauseButtonSize,
                              ),
                              iconSize: BottomPlayerTransportButtonsConstants
                                  .playPauseButtonSize,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              constraints: const BoxConstraints(),
                              onPressed:
                                  isPlayPauseButtonEnabled && isActiveEpisode
                                      ? onPlayPause
                                      : null,
                              tooltip:
                                  isPlaying ? 'Pause' : 'Wiedergabe starten',
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                        width: BottomPlayerTransportButtonsConstants
                            .centralButtonSpacing),
                    Semantics(
                      label: '10 Sekunden vor',
                      button: true,
                      child: IconButton(
                        icon: Icon(Icons.forward_10,
                            color: isActiveEpisode
                                ? BottomPlayerTransportButtonsConstants
                                    .neutralIconColor
                                    .withAlpha(
                                        BottomPlayerTransportButtonsConstants
                                            .neutralIconAlpha)
                                : theme.disabledColor),
                        iconSize: BottomPlayerTransportButtonsConstants
                            .iconButtonSize,
                        onPressed:
                            isLoading || !isActiveEpisode ? null : onForward,
                        tooltip: '10 Sekunden vor',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
              width: BottomPlayerTransportButtonsConstants.buttonSpacing),
          // Lautstärke-Button (Overlay)
          AbsorbPointer(
            absorbing: isLoading || !isActiveEpisode,
            child: IconTheme(
              data: IconThemeData(
                color: isActiveEpisode
                    ? BottomPlayerTransportButtonsConstants.neutralIconColor
                        .withAlpha(BottomPlayerTransportButtonsConstants
                            .neutralIconAlpha)
                    : theme.disabledColor, // Wie die anderen Buttons
              ),
              child: volumeButton,
            ),
          ),
        ],
      ),
    );
  }
}
