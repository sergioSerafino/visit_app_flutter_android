// filepath: g:/ProjekteFlutter/empty_flutter_template/_migration_src/storage_hold/lib/core/utils/podcast_collection_parser.dart
// /utils/podcast_collection_parser.dart
import '../../../domain/models/podcast_collection_model.dart';
import '../../../domain/models/podcast_episode_model.dart';
import '../../../domain/models/podcast_model.dart';
//item['wrapperType'] == 'track'
//ep['wrapperType'] == 'podcastEpisode' &&

class PodcastCollectionParser {
  static PodcastCollection parsePodcastData(Map<String, dynamic> json) {
    final resultsRaw = json['results'];

    if (resultsRaw is! List) {
      throw const FormatException('Invalid API format: results is not a List');
    }

    final results = resultsRaw.whereType<Map<String, dynamic>>().toList();

    if (results.isEmpty) {
      throw const FormatException('No valid results in API response');
    }

    // 🧩 Schritt 1: Podcasts filtern
    final podcasts =
        results.where((item) => item['wrapperType'] == 'track').map((
      podcastJson,
    ) {
      final collectionId = podcastJson['collectionId'];

      // 🔗 Episoden zu dieser CollectionId suchen
      final episodes = results
          .where(
            (ep) =>
                ep['wrapperType'] == 'podcastEpisode' &&
                //ep['kind'] == 'podcast-episode' &&
                ep['collectionId'] == collectionId,
          )
          .map(PodcastEpisode.fromApiJson)
          .toList();

      return Podcast.fromJson({
        ...podcastJson,
        'feedUrl': podcastJson['feedUrl'] ?? '',
      }).copyWith(episodes: episodes);
    }).toList();

    return PodcastCollection(podcasts: podcasts);
  }
}
