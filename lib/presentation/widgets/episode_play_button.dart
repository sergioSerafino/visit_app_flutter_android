import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../application/providers/audio_player_provider.dart';
import '../../application/providers/current_episode_provider.dart';
import '../../core/services/audio_player_bloc.dart';
import '../../core/messaging/snackbar_manager.dart';

/// Universeller Play/Pause-Button für Episoden
class EpisodePlayButton extends ConsumerWidget {
  final PodcastEpisode episode;
  final double iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;

  const EpisodePlayButton({
    Key? key,
    required this.episode,
    this.iconSize = 44,
    this.iconColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioBloc = ref.watch(audioPlayerBlocProvider);
    final audioStateAsync = ref.watch(audioPlayerStateProvider);
    final audioState = audioStateAsync.asData?.value;
    final currentEpisode = ref.watch(currentEpisodeProvider);
    final isActiveEpisode = currentEpisode?.trackId == episode.trackId;
    final isPlaying = isActiveEpisode && audioState is Playing;
    final isPaused = isActiveEpisode && audioState is Paused;
    final isLoading = audioState is Loading;
    final isError = audioState is ErrorState;
    final hasValidUrl = episode.episodeUrl.isNotEmpty;
    final isPlayPauseButtonEnabled = hasValidUrl && !isLoading && !isError;
    final color = iconColor ?? Theme.of(context).colorScheme.primary;

    if (isLoading && isActiveEpisode) {
      // Lade-Indikator wie im BottomPlayerTransportButtons
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: color,
          ),
        ),
      );
    }

    return IconButton(
      key: const Key('episode_play_pause_button'),
      icon: Icon(
        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
        color: color,
        size: iconSize,
      ),
      iconSize: iconSize,
      padding: padding ?? EdgeInsets.zero,
      alignment: Alignment.center,
      constraints: const BoxConstraints(),
      onPressed: isPlayPauseButtonEnabled
          ? () {
              final notifier = ref.read(currentEpisodeProvider.notifier);
              if (!isActiveEpisode) {
                audioBloc.add(Stop());
                notifier.state = episode;
                audioBloc.add(PlayEpisode(episode.episodeUrl));
              } else {
                audioBloc.add(TogglePlayPause());
              }
            }
          : null,
      tooltip: isPlaying ? 'Pause' : 'Wiedergabe starten',
    );
  }
}
