// lib/presentation/widgets/bottom_player_widget.dart
// MIGRATION-HINWEIS: Diese Datei wurde aus storage_hold/lib/presentation/widgets/bottom_player_widget.dart übernommen und refaktoriert.
// Tooltips, Button-Layout und zentrale Play/Pause-Logik wurden konsolidiert. Siehe Migrationsmatrix und Review-Checkliste.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/audio_player_provider.dart';
import '../../core/services/audio_player_bloc.dart';

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

    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      child: Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(65), blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.replay_10,
                  color: theme.colorScheme.onSurface.withAlpha(140)),
              iconSize: 32,
              onPressed: () {
                final newPos = position - const Duration(seconds: 15);
                audioBloc
                    .add(Seek(newPos > Duration.zero ? newPos : Duration.zero));
              },
              tooltip: '15 Sekunden zurück',
            ),
            const SizedBox(width: 32),
            // Play/Pause Button (zentral, deutlich größer)
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: theme.colorScheme.primary,
              ),
              iconSize: 56,
              onPressed: () {
                if (isPlaying) {
                  audioBloc.add(Pause());
                } else {
                  audioBloc.add(const PlayEpisode(''));
                }
              },
              tooltip: isPlaying ? 'Pause' : 'Wiedergabe starten',
            ),
            const SizedBox(width: 32),
            IconButton(
              icon: Icon(Icons.forward_10,
                  color: theme.colorScheme.onSurface.withAlpha(140)),
              iconSize: 32,
              onPressed: () {
                final newPos = position + const Duration(seconds: 15);
                audioBloc.add(Seek(newPos < duration ? newPos : duration));
              },
              tooltip: '15 Sekunden vor',
            ),
            if (onClose != null)
              IconButton(
                icon: Icon(Icons.close,
                    color: theme.colorScheme.onSurface.withAlpha(140)),
                onPressed: onClose,
                tooltip: 'Player schließen',
              ),
          ],
        ),
      ),
    );
  }
}
