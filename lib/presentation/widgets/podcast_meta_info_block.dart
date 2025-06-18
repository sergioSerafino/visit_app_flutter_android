import 'package:flutter/material.dart';
import '../../domain/models/podcast_model.dart';
import 'podcast_meta_info_tile.dart';

/// Widget für die Anzeige aller Podcast-Metadaten (Titel, Artist, Admin-Felder) als Block.
class PodcastMetaInfoBlock extends StatelessWidget {
  final Podcast podcast;
  final bool showAdminFields;
  const PodcastMetaInfoBlock(
      {super.key, required this.podcast, this.showAdminFields = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PodcastMetaInfoTile(
            label: 'Podcast Titel', value: podcast.collectionName),
        PodcastMetaInfoTile(label: 'Artist', value: podcast.artistName),
        if (showAdminFields) ...[
          PodcastMetaInfoTile(label: 'Feed URL', value: podcast.feedUrl ?? '-'),
          PodcastMetaInfoTile(
              label: 'PodcastId', value: podcast.collectionId.toString()),
        ],
      ],
    );
  }
}
