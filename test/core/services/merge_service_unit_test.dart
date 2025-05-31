import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:empty_flutter_template/domain/models/podcast_model.dart';
import 'package:empty_flutter_template/domain/common/api_response.dart';
import 'package:empty_flutter_template/domain/models/podcast_collection_model.dart';
import 'package:empty_flutter_template/data/repositories/podcast_repository.dart';
import 'package:empty_flutter_template/core/utils/rss_service.dart';
import 'package:empty_flutter_template/core/placeholders/placeholder_loader_service.dart';
import 'package:empty_flutter_template/core/services/merge_service.dart';
import 'package:empty_flutter_template/domain/models/podcast_episode_model.dart';
import 'package:empty_flutter_template/core/services/merged_collection_cache_service.dart';
import 'package:empty_flutter_template/domain/models/podcast_host_collection_model.dart'
    as phc;
import 'package:empty_flutter_template/domain/models/merge_models.dart'
    show LocalJsonData, RssData;
import 'merge_service_unit_test.mocks.dart';

@GenerateMocks([PodcastRepository, RssService, PlaceholderLoaderService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MergeService UnitTest', () {
    test('Merging mit Mockdaten für 1590516386', () async {
      // Arrange
      final mockRepo = MockPodcastRepository();
      final mockRss = MockRssService();
      final mockPlaceholder = MockPlaceholderLoaderService();
      when(mockPlaceholder.loadLocalJsonData(1590516386)).thenAnswer(
        (_) async => LocalJsonData(
          collectionId: 1590516386,
          title: 'Opalia Talk',
          description: 'Der Podcast rund um Opalia',
          imageUrl: 'https://example.com/logo_opalia.png',
          author: 'Sabine Guhr-Biermann',
          contactEmail: 'kontakt@opalia.group',
          authTokenRequired: false,
          featureFlags: ['showPortfolioTab'],
        ),
      );
      when(mockRepo.fetchPodcastCollectionById(1590516386)).thenAnswer(
        (_) async => ApiResponse.success(
          PodcastCollection(
            podcasts: [
              Podcast(
                wrapperType: 'track',
                collectionId: 1590516386,
                collectionName: 'Opalia Talk',
                artistName: 'Sabine Guhr-Biermann',
                primaryGenreName: 'Health',
                artworkUrl600: 'https://example.com/artwork.png',
                feedUrl: 'https://opalia.group/feed',
                episodes: [
                  PodcastEpisode(
                    wrapperType: 'podcastEpisode',
                    trackId: 1,
                    trackName: 'Testfolge',
                    artworkUrl600: 'https://example.com/ep.png',
                    description: 'Beschreibung',
                    episodeUrl: 'https://example.com/audio.mp3',
                    trackTimeMillis: 1800000,
                    episodeFileExtension: 'mp3',
                    releaseDate: DateTime(2025, 3, 30),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      when(mockRss.fetchRssData(any)).thenAnswer(
        (_) async => RssData(
          title: 'Opalia Talk',
          description: 'Podcast rund um Opalia',
          imageUrl: 'https://example.com/logo_opalia.png',
          author: 'Sabine Guhr-Biermann',
          ownerEmail: 'kontakt@opalia.group',
        ),
      );
      final cacheService = FakeMergedCollectionCacheService();
      final mergeService = MergeService(
        podcastRepo: mockRepo,
        placeholderLoader: mockPlaceholder,
        rssService: mockRss,
        cacheService: cacheService,
      );

      // Act
      final result = await mergeService.merge(1590516386);

      // Assert
      expect(result.collectionId, 1590516386);
      expect(result.podcast.collectionName, 'Opalia Talk');
      expect(result.episodes.length, 1);
      expect(result.host!.hostName, 'Sabine Guhr-Biermann');
      expect(result.host!.description, 'Podcast rund um Opalia');
      expect(result.host!.authTokenRequired, false);
      expect(result.host!.contact.email, 'kontakt@opalia.group');
      expect(
          result.host!.branding.logoUrl, 'https://example.com/logo_opalia.png');
      expect(result.host!.features.showPortfolioTab, true);
      expect(result.host!.localization.defaultLanguageCode, isNotNull);
      expect(
          result.host!.localization.localizedTexts, isA<Map<String, String>>());
    });
    // ...weitere Tests analog übernehmen...
  });
}

// Fake für MergedCollectionCacheService, damit kein Hive benötigt wird
class FakeMergedCollectionCacheService extends MergedCollectionCacheService {
  @override
  Future<void> save(phc.PodcastHostCollection collection) async {}
  @override
  Future<phc.PodcastHostCollection?> load(int collectionId) async => null;
  @override
  Future<bool> isFresh(int collectionId, {Duration? ttl}) async => false;
  @override
  Future<void> invalidate(int collectionId) async {}
}
