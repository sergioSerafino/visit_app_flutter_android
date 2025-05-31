import 'package:dio/dio.dart';
import 'package:webfeed/webfeed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/host_model.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../application/providers/collection_provider.dart';
import '../../domain/models/contact_info_model.dart';
import '../../domain/models/branding_model.dart';
import '../../domain/models/feature_flags_model.dart';
import '../../domain/models/localization_config_model.dart';
import '../../domain/models/host_content_model.dart';
import '../../domain/models/merge_models.dart';
import 'rss_parser_service.dart';

class RssService {
  final Dio _dio;

  RssService(this._dio);

  Future<Host> fetchHostFromFeed(String rssUrl) async {
    // Robust: Folge Weiterleitungen (z.B. anchor.fm, podigee, etc.)
    final response = await _dio.get(
      rssUrl,
      options: Options(
        followRedirects: true, // Standard: true, aber explizit setzen
        maxRedirects: 5, // Erlaubt mehrere Weiterleitungen
        validateStatus: (status) =>
            status != null && status < 500, // Akzeptiere 3xx
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load RSS feed (Status: \\${response.statusCode})',
      );
    }

    final rssFeed = RssFeed.parse(response.data);

    // Anpassung: collectionId wird aus einer anderen Quelle extrahiert
    final collectionId = int.tryParse(rssFeed.itunes?.owner?.email ?? '') ?? 0;

    // Anpassung: Kategorien werden direkt als String verwendet
    final primaryGenreName = rssFeed.itunes?.categories?.first ?? 'Unknown';

    return Host(
      collectionId: collectionId,
      hostName: rssFeed.title ?? 'Unknown Host',
      description: rssFeed.description ?? 'No description available',
      contact: ContactInfo(email: rssFeed.itunes?.owner?.email ?? ''),
      branding: Branding(logoUrl: rssFeed.image?.url ?? ''),
      features: const FeatureFlags(),
      localization: const LocalizationConfig(),
      content: const HostContent(),
      primaryGenreName: primaryGenreName as String?,
      authTokenRequired: false,
      debugOnly: false,
      lastUpdated: DateTime.now(),
    );
  }

  Future<Host> fetchHostUsingCollectionId(Ref ref) async {
    final collectionId = ref.read(collectionIdProvider);

    // Abrufen der PodcastCollection über die iTunes-API
    final collectionResponse = await _dio.get(
      'https://itunes.apple.com/lookup?id=$collectionId&entity=podcast',
    );

    if (collectionResponse.statusCode != 200) {
      throw Exception('Failed to fetch PodcastCollection');
    }

    final podcastCollection = PodcastCollection.fromApiJson(
      collectionResponse.data,
    );

    final feedUrl = podcastCollection.podcasts.first.feedUrl;

    if (feedUrl == null || feedUrl.isEmpty) {
      throw Exception('Feed URL is missing in PodcastCollection');
    }

    // Abrufen des RSS-Feeds
    return fetchHostFromFeed(feedUrl);
  }

  Future<Host> fetchHostFromCollectionId(int collectionId) async {
    // Abrufen der PodcastCollection über die iTunes-API
    final collectionResponse = await _dio.get(
      'https://itunes.apple.com/lookup?id=$collectionId&entity=podcast',
    );

    if (collectionResponse.statusCode != 200) {
      throw Exception('Failed to fetch PodcastCollection');
    }

    final podcastCollection = PodcastCollection.fromApiJson(
      collectionResponse.data,
    );

    final feedUrl = podcastCollection.podcasts.first.feedUrl;

    if (feedUrl == null || feedUrl.isEmpty) {
      throw Exception('Feed URL is missing in PodcastCollection');
    }

    // Abrufen des RSS-Feeds
    return fetchHostFromFeed(feedUrl);
  }

  // Liefert RssData für eine feedUrl (nur Metadaten, kein Host)
  Future<RssData?> fetchRssData(String feedUrl) async {
    // Robust: Folge Weiterleitungen (z.B. anchor.fm, podigee, etc.)
    final parser = RssParserService();
    final response = await _dio.get(
      feedUrl,
      options: Options(
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode != 200 || response.data == null) return null;
    final metadata = await parser.parseFromString(response.data!);
    if (metadata == null) return null;
    return RssData(
      title: metadata.websiteUrl, // ggf. anpassen
      description: metadata.description,
      imageUrl: metadata.logoUrl,
      author: metadata.hostName,
      ownerEmail: metadata.contactEmail,
    );
  }
}
