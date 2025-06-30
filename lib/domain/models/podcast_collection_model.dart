// PodcastCollection Model
import 'package:freezed_annotation/freezed_annotation.dart';

import 'podcast_episode_model.dart';
import 'podcast_model.dart';

part 'podcast_collection_model.freezed.dart';
part 'podcast_collection_model.g.dart';

@Freezed(fromJson: true, toJson: false)
class PodcastCollection with _$PodcastCollection {
  const PodcastCollection._(); // Privater Konstruktor für Getter

  const factory PodcastCollection({
    required List<Podcast> podcasts,
    DateTime? downloadedAt,
  }) = _PodcastCollection;

  // Hier wird die standardmäßige `fromJson()`-Methode von Freezed benutzt
  factory PodcastCollection.fromJson(Map<String, dynamic> json) =>
      _$PodcastCollectionFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'podcasts': podcasts.map((p) => p.toJson()).toList(),
      if (downloadedAt != null) 'downloadedAt': downloadedAt!.toIso8601String(),
    };
  }

  factory PodcastCollection.fromApiJson(Map<String, dynamic> json) {
    final resultsRaw = json['results'];

    if (resultsRaw is! List) {
      // 🛑 Schutz: results ist nicht mal ein Array
      return PodcastCollection.empty();
    }

    // 🔒 Schutz: Nur Maps verarbeiten
    List<Map<String, dynamic>> results =
        resultsRaw.whereType<Map<String, dynamic>>().toList();

    if (results.isEmpty) {
      // 🔕 Kein valides JSON in results → leer zurück
      return PodcastCollection.empty();
    }

    // 🧩 Podcasts + Episoden sortiert mappen
    List<Podcast> podcasts =
        results.where((item) => item['kind'] == 'podcast').map((item) {
      // 🔍 Alle zugehörigen Episoden zur Collection finden
      final episodes = results
          .where(
            (ep) =>
                ep['kind'] == 'podcast-episode' &&
                ep['collectionId'] == item['collectionId'],
          )
          .map(PodcastEpisode.fromJson)
          .toList();

      return Podcast.fromJson({
        ...item,
        'feedUrl': item['feedUrl'] ?? '',
      }).copyWith(episodes: episodes);
    }).toList();

    return PodcastCollection(podcasts: podcasts);
  }

  // Getter für alle Episoden
  List<PodcastEpisode> get allEpisodes =>
      podcasts.expand((p) => p.episodes).toList();

  // Falls kein Datenstrom vorhanden ist, gib eine leere Collection zurück
  factory PodcastCollection.empty() => const PodcastCollection(podcasts: []);
}

// Erweiterung: isPlaceholder-Getter für PodcastCollection
extension PodcastCollectionX on PodcastCollection {
  bool get isPlaceholder => podcasts.any((p) => p.collectionId == -1);
}
