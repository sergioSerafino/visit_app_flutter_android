import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../application/providers/cast_airplay_provider.dart';
import '../../application/providers/audio_player_provider.dart';
import '../../application/providers/current_episode_provider.dart';
import '../../core/services/audio_player_bloc.dart';
import '../widgets/cast_airplay_button.dart';
import '../../core/messaging/snackbar_manager.dart';

/// Button-Row für EpisodeDetailPage: Favorisieren, Download, Cast, Play/Pause
class EpisodeActionRow extends ConsumerWidget {
  final PodcastEpisode episode;
  final String trackName;
  const EpisodeActionRow(
      {Key? key, required this.episode, required this.trackName})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(castDevicesProvider);
    final connectedDevice = ref.watch(connectedCastDeviceProvider);
    final isAvailable = devices.isNotEmpty;
    final isConnected = connectedDevice != null;
    final statusText = isConnected
        ? 'Verbunden mit {connectedDevice.name}'
        : (isAvailable ? 'Mit Gerät verbinden' : 'Kein Gerät gefunden');
    final service = ref.watch(castAirPlayServiceProvider);
    final audioBloc = ref.watch(audioPlayerBlocProvider);
    final audioStateAsync = ref.watch(audioPlayerStateProvider);
    final audioState = audioStateAsync.asData?.value;
    final currentEpisode = ref.watch(currentEpisodeProvider);
    final isActiveEpisode = currentEpisode?.trackId == episode.trackId;
    final hasEverBeenLoaded = isActiveEpisode;
    final playIconColor = !hasEverBeenLoaded
        ? Theme.of(context).colorScheme.onSurface.withAlpha(140)
        : Colors.grey[400];
    final isPlaying = isActiveEpisode && audioState is Playing;
    final isEnabled = audioState is! Loading && audioState is! ErrorState;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.star_border_outlined,
            size: 44,
            color: Colors.grey[400],
          ),
          tooltip: 'Favorisieren',
          onPressed: () {
            ref
                .read(snackbarManagerProvider.notifier)
                .showByKey('favorites_feature');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.download,
            size: 44,
            color: Colors.grey[400],
          ),
          tooltip: 'Download',
          onPressed: () {
            ref
                .read(snackbarManagerProvider.notifier)
                .showByKey('download_feature');
          },
        ),
        CastAirPlayButton(
          isAvailable: isAvailable,
          isConnected: isConnected,
          statusText: statusText,
          onPressed: isAvailable
              ? () {
                  ref
                      .read(snackbarManagerProvider.notifier)
                      .showByKey('cast_feature');
                  if (isConnected) {
                    service.disconnect();
                  } else if (devices.isNotEmpty) {
                    service.connectToDevice(devices.first);
                  } else {
                    service.discoverDevices();
                  }
                }
              : null,
          iconColor: Colors.grey[400],
          iconSize: 44,
        ),
        SizedBox(
          width: 56,
          height: 56,
          child: Center(
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: playIconColor,
                size: 56,
              ),
              iconSize: 56,
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              constraints: const BoxConstraints(),
              onPressed: isEnabled
                  ? () {
                      final notifier =
                          ref.read(currentEpisodeProvider.notifier);
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
            ),
          ),
        ),
      ],
    );
  }
}
