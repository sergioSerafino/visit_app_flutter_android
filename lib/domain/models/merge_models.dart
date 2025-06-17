import 'package:freezed_annotation/freezed_annotation.dart';

part 'merge_models.freezed.dart';
part 'merge_models.g.dart';

@freezed
class ItunesData with _$ItunesData {
  const factory ItunesData({
    int? collectionId,
    String? trackName,
    String? shortDescription,
    String? artworkUrl600,
    String? artistName,
    String? feedUrl,
  }) = _ItunesData;

  factory ItunesData.fromJson(Map<String, dynamic> json) =>
      _$ItunesDataFromJson(json);
}

@freezed
class RssData with _$RssData {
  const factory RssData({
    String? title,
    String? description,
    String? imageUrl,
    String? author,
    String? ownerEmail,
  }) = _RssData;

  factory RssData.fromJson(Map<String, dynamic> json) =>
      _$RssDataFromJson(json);
}

@freezed
class LocalJsonData with _$LocalJsonData {
  const factory LocalJsonData({
    int? collectionId,
    String? title,
    String? description,
    String? imageUrl,
    String? author,
    String? contactEmail,
    bool? authTokenRequired,
    List<String>? featureFlags,
    Map<String, String>? socialLinks, // NEU: Social Links lokal
  }) = _LocalJsonData;

  factory LocalJsonData.fromJson(Map<String, dynamic> json) =>
      _$LocalJsonDataFromJson(json);
}

@freezed
class PodcastHostCollection with _$PodcastHostCollection {
  const factory PodcastHostCollection({
    int? collectionId,
    String? title,
    String? description,
    String? logoUrl,
    String? author,
    String? contactEmail,
    bool? authTokenRequired,
    bool? isManagedCollection,
    List<String>? featureFlags,
    DateTime? lastUpdated,
    Map<String, String>? socialLinks, // NEU: Social Links im Zielmodell
  }) = _PodcastHostCollection;

  factory PodcastHostCollection.fromJson(Map<String, dynamic> json) =>
      _$PodcastHostCollectionFromJson(json);
}

PodcastHostCollection mergePodcastData(
  ItunesData itunes,
  RssData rss,
  LocalJsonData local,
) {
  // Beispielhafte Liste verwalteter Collections (kann extern gepflegt werden)
  const managedCollections = <int>[12345, 67890];

  return PodcastHostCollection(
    collectionId: itunes.collectionId ?? local.collectionId,
    title: itunes.trackName ?? rss.title ?? local.title ?? '',
    description:
        itunes.shortDescription ?? rss.description ?? local.description,
    logoUrl: itunes.artworkUrl600 ?? rss.imageUrl ?? local.imageUrl,
    author: itunes.artistName ?? rss.author ?? local.author,
    contactEmail: rss.ownerEmail ?? local.contactEmail ?? '',
    authTokenRequired: local.authTokenRequired ?? false,
    isManagedCollection: (local.authTokenRequired == true) ||
        (itunes.collectionId != null &&
            managedCollections.contains(itunes.collectionId!)),
    featureFlags: local.featureFlags ?? <String>[],
    lastUpdated: DateTime.now(),
    socialLinks: local.socialLinks, // NEU: Social Links übernehmen
  );
}
