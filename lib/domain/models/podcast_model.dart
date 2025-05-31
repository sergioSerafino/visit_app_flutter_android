// Podcast Model
import 'package:freezed_annotation/freezed_annotation.dart';
import '/../../domain/models/podcast_episode_model.dart';

part 'podcast_model.freezed.dart';
part 'podcast_model.g.dart';

@Freezed(toJson: false)
class Podcast with _$Podcast {
  const factory Podcast({
    required String wrapperType,
    required int collectionId,
    required String collectionName,
    required String artistName,
    required String primaryGenreName,
    required String artworkUrl600,
    String? feedUrl,
    @Default([]) List<PodcastEpisode> episodes, // Standardwert für Episoden
  }) = _Podcast;

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'wrapperType': wrapperType,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'artistName': artistName,
      'primaryGenreName': primaryGenreName,
      'artworkUrl600': artworkUrl600,
      'feedUrl': feedUrl,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}
