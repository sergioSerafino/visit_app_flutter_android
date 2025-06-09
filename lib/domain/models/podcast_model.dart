// Podcast Model
import 'package:freezed_annotation/freezed_annotation.dart';
import 'podcast_episode_model.dart';

part 'podcast_model.freezed.dart';
part 'podcast_model.g.dart';

@freezed
class Podcast with _$Podcast {
  const factory Podcast({
    required String wrapperType,
    required int collectionId,
    required String collectionName,
    required String artistName,
    required String primaryGenreName,
    required String artworkUrl600,
    String? feedUrl,
    @Default([]) List<PodcastEpisode> episodes,
  }) = _Podcast;

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);
}
