// \lib\presentation\widgets\episode_item_tile.dart
// Episode Kachel für Listen

import 'package:flutter/material.dart';
import '../../domain/models/podcast_episode_model.dart';

class EpisodeItemTile extends StatelessWidget {
  final PodcastEpisode episode;
  final VoidCallback? onTap;

  const EpisodeItemTile({super.key, required this.episode, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {}, // fallback, falls null
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cover-Bild
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: episode.artworkUrl600.isNotEmpty
                  ? Image.network(
                      episode.artworkUrl600,
                      width: 85,
                      height: 85,
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    episode.description ?? "Keine Beschreibung verfügbar",
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(180)),
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
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(180),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    heightFactor: 1,
                    widthFactor: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        size: 32,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(180),
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
    final theme = Theme.of(context);
    return Container(
      width: 85,
      height: 85,
      color: theme.colorScheme.surfaceVariant,
      child: Icon(Icons.music_note,
          size: 50, color: theme.colorScheme.onSurface.withAlpha(120)),
    );
  }

  String _formatDuration(int millis) {
    final seconds = (millis / 1000).round();
    final minutes = (seconds / 60).floor();
    return '${minutes + 1}min';
  }
}
