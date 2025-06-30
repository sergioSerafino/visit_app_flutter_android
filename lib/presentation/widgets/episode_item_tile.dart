// \lib\presentation\widgets\episode_item_tile.dart
// Episode Kachel für Listen

import 'package:flutter/material.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../core/utils/episode_item_tile_constants.dart';
import '../../core/utils/episode_format_utils.dart';
import 'episode_play_button.dart';

class EpisodeItemTile extends StatelessWidget {
  final PodcastEpisode episode;
  final VoidCallback? onTap;

  const EpisodeItemTile({super.key, required this.episode, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = episode.trackId < 0;
    final textColor = isPlaceholder
        ? Colors.grey[500]?.withAlpha(180)
        : Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap ?? () {}, // fallback, falls null
      child: Container(
        padding: EpisodeItemTileConstants.padding,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            // Cover-Bild
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: episode.artworkUrl600.isNotEmpty
                  ? Image.network(
                      episode.artworkUrl600,
                      width: EpisodeItemTileConstants.coverSize,
                      height: EpisodeItemTileConstants.coverSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(context),
                    )
                  : _buildPlaceholder(context),
            ),

            const SizedBox(width: 16),

            // Titel + Beschreibung
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.trackName,
                    style: EpisodeItemTileConstants.titleStyle.copyWith(
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    episode.description ?? "Keine Beschreibung verfügbar",
                    style: TextStyle(color: textColor, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Zeit + Icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    _formatDuration(episode.trackTimeMillis),
                    style: TextStyle(color: textColor, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),

                // Play-Button unterhalb der Dauer
                EpisodePlayButton(
                  episode: episode,
                  iconSize: 36,
                  iconColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.all(0),
                ),
                // const SizedBox(height: 8),

                SizedBox(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    heightFactor: 1,
                    widthFactor: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        size: EpisodeItemTileConstants.iconSize,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(140),
                      ),
                      onPressed: () {
                        // Optional: show modal / actions
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    // Gleiches Grau und Icon wie ImageWithBanner, aber noch etwas kleiner
    return Container(
      width: EpisodeItemTileConstants.coverSize,
      height: EpisodeItemTileConstants.coverSize,
      color: Colors.grey[300],
      child: Icon(
        Icons.podcasts,
        size: 32, // noch kleiner für dezenteres Listen-Design
        color: Colors.grey[500],
      ),
    );
  }

  String _formatDuration(int millis) {
    return EpisodeFormatUtils.formatDuration(millis);
  }
}
