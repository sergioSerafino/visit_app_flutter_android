// \lib\presentation\widgets\episode_item_tile.dart
// Episode Kachel für Listen

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import '../../domain/models/podcast_episode_model.dart';
import '../../core/utils/episode_item_tile_constants.dart';
import '../../core/utils/episode_format_utils.dart';
import 'episode_play_button.dart';

class EpisodeItemTile extends StatefulWidget {
  final PodcastEpisode episode;
  final VoidCallback? onTap;

  const EpisodeItemTile({super.key, required this.episode, this.onTap});

  @override
  State<EpisodeItemTile> createState() => _EpisodeItemTileState();
}

class _EpisodeItemTileState extends State<EpisodeItemTile> {
  bool _showShimmer = false;
  Timer? _shimmerTimer;

  @override
  void initState() {
    super.initState();
    if (widget.episode.trackId < 0) {
      _showShimmer = true;
      _shimmerTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showShimmer = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _shimmerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = widget.episode.trackId < 0;
    final tileContent = InkWell(
      onTap: widget.onTap ?? () {},
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
              child: widget.episode.artworkUrl600.isNotEmpty
                  ? Image.network(
                      widget.episode.artworkUrl600,
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
                    widget.episode.trackName,
                    style: EpisodeItemTileConstants.titleStyle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.episode.description ??
                        "Keine Beschreibung verfügbar",
                    style: EpisodeItemTileConstants.descriptionStyle.copyWith(
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
                    _formatDuration(widget.episode.trackTimeMillis),
                    style: EpisodeItemTileConstants.durationStyle.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(140),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Play-Button unterhalb der Dauer
                EpisodePlayButton(
                  episode: widget.episode,
                  iconSize: 36,
                  iconColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.all(0),
                ),
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
    if (isPlaceholder && _showShimmer) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: tileContent,
      );
    }
    return tileContent;
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: EpisodeItemTileConstants.coverSize,
      height: EpisodeItemTileConstants.coverSize,
      child: Icon(Icons.podcasts,
          size: EpisodeItemTileConstants.placeholderIconSize,
          color: theme.colorScheme.primary.withAlpha(140)),
    );
  }

  String _formatDuration(int millis) {
    return EpisodeFormatUtils.formatDuration(millis);
  }
}
