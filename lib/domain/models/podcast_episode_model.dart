// Episode Model
import 'package:freezed_annotation/freezed_annotation.dart';

part 'podcast_episode_model.freezed.dart';
part 'podcast_episode_model.g.dart';

@freezed
class PodcastEpisode with _$PodcastEpisode {
  const factory PodcastEpisode({
    required String wrapperType,
    required int trackId,
    required String trackName,
    required String artworkUrl600,
    String? description,
    required String episodeUrl,
    required int trackTimeMillis,
    required String episodeFileExtension,
    required DateTime releaseDate,

    // ➕ Lokale Zusatzfelder
    @JsonKey(includeFromJson: false, includeToJson: false)
    DateTime? downloadedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? localId,
  }) = _PodcastEpisode;

  // Normales Mapping der JSON-Methode (lokale gespeichert)
  factory PodcastEpisode.fromJson(Map<String, dynamic> json) =>
      _$PodcastEpisodeFromJson(json);

  // API-Mapping – wenn JSON nicht 1:1 passt
  factory PodcastEpisode.fromApiJson(Map<String, dynamic> json) {
    return PodcastEpisode(
      wrapperType: json['wrapperType'] ?? '',
      trackId: _parseInt(json['trackId']),
      trackName: json['trackName'] ?? 'Unbekannter Titel',
      artworkUrl600: json['artworkUrl600'] ?? '',
      description: json['description'] ?? 'Keine Beschreibung verfügbar',
      episodeUrl: json['episodeUrl'] ?? '',
      trackTimeMillis: _parseInt(json['trackTimeMillis']),
      episodeFileExtension: json['episodeFileExtension'] ?? 'mp3',
      releaseDate:
          DateTime.tryParse(json['releaseDate'] ?? '') ?? DateTime.now(),
    );
  }

  // 🔐 Sicheres Parsen von int-Werten
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'wrapperType': wrapperType,
      'trackId': trackId,
      'trackName': trackName,
      'artworkUrl600': artworkUrl600,
      'description': description,
      'episodeUrl': episodeUrl,
      'trackTimeMillis': trackTimeMillis,
      'episodeFileExtension': episodeFileExtension,
      'releaseDate': releaseDate.toIso8601String(),
    };
  }
}
