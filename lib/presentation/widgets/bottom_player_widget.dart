// lib/presentation/widgets/bottom_player_widget.dart
// MIGRATION-HINWEIS: Diese Datei wurde aus storage_hold/lib/presentation/widgets/bottom_player_widget.dart übernommen und refaktoriert.
// Tooltips, Button-Layout und zentrale Play/Pause-Logik wurden konsolidiert. Siehe Migrationsmatrix und Review-Checkliste.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/audio_player_provider.dart';
import '../../core/services/audio_player_bloc.dart';
import 'loading_dots.dart';

class BottomPlayerWidget extends ConsumerWidget {
  final VoidCallback? onClose;
  const BottomPlayerWidget({super.key, this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final audioBloc = ref.watch(audioPlayerBlocProvider);
    final audioState = ref
        .watch(audioPlayerStateProvider)
        .maybeWhen(data: (state) => state, orElse: () => null);
    final isPlaying = audioState is Playing;
    final position = (audioState is Playing || audioState is Paused)
        ? (audioState as dynamic).position as Duration
        : Duration.zero;
    final duration = (audioState is Playing || audioState is Paused)
        ? (audioState as dynamic).duration as Duration
        : const Duration(seconds: 100);

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // Fehler-Feedback: Snackbar bei ErrorState
    if (audioState is ErrorState && audioState.message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(audioState.message),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }

    // Ladeindikator bei Loading-State
    if (audioState is Loading) {
      return SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
        child: Container(
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(65), blurRadius: 4),
            ],
          ),
          child: Center(
            child: LoadingDots(
              color: Colors.blueGrey,
              duration: const Duration(milliseconds: 320),
            ),
          ),
        ),
      );
    }

    // --- Speed Control Dropdown ---
    final double currentSpeed = (audioState is Playing)
        ? audioState.speed
        : (audioState is Paused)
            ? audioState.speed
            : 1.0;
    final List<double> speedOptions = [0.5, 1.0, 1.5, 2.0];

    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      child: Container(
        // Höhe entfernt, damit das Widget flexibel bleibt
        // height: 170,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(65), blurRadius: 4),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Flexibles Layout
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Speed Control Dropdown ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Semantics(
                  label: 'Abspielgeschwindigkeit wählen',
                  child: DropdownButton<double>(
                    value: currentSpeed,
                    items: speedOptions
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text('${s}x'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        audioBloc.add(SetSpeed(value));
                      }
                    },
                  ),
                ),
              ],
            ),
            // --- NEU: Slider mit Zeitangaben ---
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text(
                    _formatDurationMMSS(position.inMilliseconds),
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface
                          .withAlpha(160), // dezenter
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 4),
                // Semantics für Fortschrittsanzeige/Slider
                Expanded(
                  child: Semantics(
                    label:
                        'Fortschritt: ${position.inSeconds} Sekunden von ${duration.inSeconds} Sekunden',
                    value: _formatDurationMMSS(position.inMilliseconds),
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: theme.colorScheme.primary,
                        inactiveTrackColor:
                            theme.colorScheme.surfaceContainerHighest,
                        thumbColor: theme.colorScheme.primary.withAlpha(180),
                        overlayColor: theme.colorScheme.primary.withAlpha(32),
                        trackHeight: 14,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 9),
                        valueIndicatorShape:
                            const PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor:
                            theme.colorScheme.primary.withAlpha(180),
                        showValueIndicator:
                            ShowValueIndicator.onlyForContinuous,
                      ),
                      child: Slider(
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        divisions:
                            duration.inSeconds > 0 ? duration.inSeconds : null,
                        label: _formatDurationMMSS(position.inMilliseconds),
                        onChanged: (v) {
                          audioBloc.add(Seek(Duration(seconds: v.toInt())));
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 48,
                  child: Text(
                    '-${_formatDurationMMSS((duration - position).inMilliseconds)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface
                          .withAlpha(160), // dezenter
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // --- Transport-Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: '10 Sekunden zurück',
                  button: true,
                  child: IconButton(
                    icon: Icon(Icons.replay_10,
                        color: theme.colorScheme.onSurface.withAlpha(140)),
                    iconSize: 32,
                    onPressed: () {
                      final newPos = position - const Duration(seconds: 10);
                      audioBloc.add(Seek(
                          newPos > Duration.zero ? newPos : Duration.zero));
                    },
                    tooltip: '10 Sekunden zurück',
                  ),
                ),
                const SizedBox(width: 32),
                Semantics(
                  label: isPlaying ? 'Pause' : 'Wiedergabe starten',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: theme.colorScheme.onSurface.withAlpha(140),
                    ),
                    iconSize: 56,
                    onPressed: () {
                      if (isPlaying) {
                        audioBloc.add(Pause());
                      } else {
                        audioBloc.add(PlayEpisode(''));
                      }
                    },
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
                    onPressed: () {
                      final newPos = position + const Duration(seconds: 10);
                      audioBloc
                          .add(Seek(newPos < duration ? newPos : duration));
                    },
                    tooltip: '10 Sekunden vor',
                  ),
                ),
                if (onClose != null)
                  Semantics(
                    label: 'Player schließen',
                    button: true,
                    child: IconButton(
                      icon: Icon(Icons.close,
                          color: theme.colorScheme.onSurface.withAlpha(140)),
                      onPressed: onClose,
                      tooltip: 'Player schließen',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Hilfsfunktionen für Zeitformatierung ---
  String _formatDurationMMSS(int millis) {
    final seconds = (millis / 1000).round();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
