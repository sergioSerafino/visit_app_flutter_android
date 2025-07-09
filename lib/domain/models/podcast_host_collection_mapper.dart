import 'podcast_host_collection_model.dart';
import 'podcast_host_collection_hive_adapter.dart';
import 'podcast_model.dart';
import 'podcast_hive_adapter.dart';
import 'podcast_episode_model.dart';
import 'podcast_episode_hive_adapter.dart';
import 'host_model.dart';
import 'host_hive_adapter.dart';
import 'collection_meta_model.dart';
import 'collection_meta_hive_adapter.dart';

import 'contact_info_model.dart';
import 'contact_info_hive_adapter.dart';
import 'branding_model.dart';
import 'branding_hive_adapter.dart';
import 'feature_flags_model.dart';
import 'feature_flags_hive_adapter.dart';
import 'localization_config_model.dart';
import 'localization_config_hive_adapter.dart';
import 'host_content_model.dart';
import 'host_content_hive_adapter.dart';
import 'link_model.dart';
import 'link_hive_adapter.dart';

import '../enums/data_source_type.dart';
import 'data_origin_model.dart';

/// Mapper für die Konvertierung zwischen Freezed-Modell und Hive-Modell
class PodcastHostCollectionMapper {
  static HivePodcastHostCollection toHive(PodcastHostCollection model) {
    return HivePodcastHostCollection(
      collectionId: model.collectionId,
      podcast: PodcastMapper.toHive(model.podcast),
      episodes: model.episodes.map(PodcastEpisodeMapper.toHive).toList(),
      host: model.host != null ? HostMapper.toHive(model.host!) : null,
      downloadedAt: model.downloadedAt,
      meta: CollectionMetaMapper.toHive(model.meta),
    );
  }

  static PodcastHostCollection fromHive(HivePodcastHostCollection hive) {
    return PodcastHostCollection(
      collectionId: hive.collectionId,
      podcast: PodcastMapper.fromHive(hive.podcast),
      episodes: hive.episodes.map(PodcastEpisodeMapper.fromHive).toList(),
      host: hive.host != null ? HostMapper.fromHive(hive.host!) : null,
      downloadedAt: hive.downloadedAt,
      meta: CollectionMetaMapper.fromHive(hive.meta),
    );
  }
}

class PodcastMapper {
  static HivePodcast toHive(Podcast model) => HivePodcast(
        wrapperType: model.wrapperType,
        collectionId: model.collectionId,
        collectionName: model.collectionName,
        artistName: model.artistName,
        primaryGenreName: model.primaryGenreName,
        artworkUrl600: model.artworkUrl600,
        feedUrl: model.feedUrl,
      );
  static Podcast fromHive(HivePodcast hive) => Podcast(
        wrapperType: hive.wrapperType,
        collectionId: hive.collectionId,
        collectionName: hive.collectionName,
        artistName: hive.artistName,
        primaryGenreName: hive.primaryGenreName,
        artworkUrl600: hive.artworkUrl600,
        feedUrl: hive.feedUrl,
        episodes: const [], // Muss ggf. separat gemappt werden
      );
}

class PodcastEpisodeMapper {
  static HivePodcastEpisode toHive(PodcastEpisode model) => HivePodcastEpisode(
        wrapperType: model.wrapperType,
        trackId: model.trackId,
        trackName: model.trackName,
        artworkUrl600: model.artworkUrl600,
        description: model.description,
        episodeUrl: model.episodeUrl,
        trackTimeMillis: model.trackTimeMillis,
        episodeFileExtension: model.episodeFileExtension,
        releaseDate: model.releaseDate,
        downloadedAt: model.downloadedAt,
        localId: model.localId,
      );
  static PodcastEpisode fromHive(HivePodcastEpisode hive) => PodcastEpisode(
        wrapperType: hive.wrapperType,
        trackId: hive.trackId,
        trackName: hive.trackName,
        artworkUrl600: hive.artworkUrl600,
        description: hive.description,
        episodeUrl: hive.episodeUrl,
        trackTimeMillis: hive.trackTimeMillis,
        episodeFileExtension: hive.episodeFileExtension,
        releaseDate: hive.releaseDate,
        downloadedAt: hive.downloadedAt,
        localId: hive.localId,
      );
}

class HostMapper {
  static HiveHost toHive(Host model) => HiveHost(
        collectionId: model.collectionId,
        hostName: model.hostName,
        description: model.description,
        contact: ContactInfoMapper.toHive(model.contact),
        branding: BrandingMapper.toHive(model.branding),
        features: FeatureFlagsMapper.toHive(model.features),
        localization: LocalizationConfigMapper.toHive(model.localization),
        content: HostContentMapper.toHive(model.content),
        primaryGenreName: model.primaryGenreName,
        authTokenRequired: model.authTokenRequired,
        debugOnly: model.debugOnly,
        lastUpdated: model.lastUpdated,
        hostImage: model.hostImage,
        sectionTitles: model.sectionTitles,
      );
  static Host fromHive(HiveHost hive) => Host(
        collectionId: hive.collectionId,
        hostName: hive.hostName,
        description: hive.description,
        contact: ContactInfoMapper.fromHive(hive.contact),
        branding: BrandingMapper.fromHive(hive.branding),
        features: FeatureFlagsMapper.fromHive(hive.features),
        localization: LocalizationConfigMapper.fromHive(hive.localization),
        content: HostContentMapper.fromHive(hive.content),
        primaryGenreName: hive.primaryGenreName,
        authTokenRequired: hive.authTokenRequired,
        debugOnly: hive.debugOnly,
        lastUpdated: hive.lastUpdated,
        hostImage: hive.hostImage,
        sectionTitles: hive.sectionTitles,
      );
}

class ContactInfoMapper {
  static HiveContactInfo toHive(ContactInfo model) => HiveContactInfo(
        email: model.email,
        websiteUrl: model.websiteUrl,
        impressumUrl: model.impressumUrl,
        socialLinks: model.socialLinks,
      );
  static ContactInfo fromHive(HiveContactInfo hive) => ContactInfo(
        email: hive.email,
        websiteUrl: hive.websiteUrl,
        impressumUrl: hive.impressumUrl,
        socialLinks: hive.socialLinks ?? {},
      );
}

class BrandingMapper {
  static HiveBranding toHive(Branding model) => HiveBranding(
        primaryColorHex: model.primaryColorHex,
        secondaryColorHex: model.secondaryColorHex,
        headerImageUrl: model.headerImageUrl,
        themeMode: model.themeMode,
        logoUrl: model.logoUrl,
        assetLogo: model.assetLogo,
      );
  static Branding fromHive(HiveBranding hive) => Branding(
        primaryColorHex: hive.primaryColorHex,
        secondaryColorHex: hive.secondaryColorHex,
        headerImageUrl: hive.headerImageUrl,
        themeMode: hive.themeMode,
        logoUrl: hive.logoUrl,
        assetLogo: hive.assetLogo,
      );
}

class FeatureFlagsMapper {
  static HiveFeatureFlags toHive(FeatureFlags model) => HiveFeatureFlags(
        showPortfolioTab: model.showPortfolioTab,
        enableContactForm: model.enableContactForm,
        showPodcastGenre: model.showPodcastGenre,
        customStartTab: model.customStartTab,
      );
  static FeatureFlags fromHive(HiveFeatureFlags hive) => FeatureFlags(
        showPortfolioTab: hive.showPortfolioTab,
        enableContactForm: hive.enableContactForm,
        showPodcastGenre: hive.showPodcastGenre,
        customStartTab: hive.customStartTab,
      );
}

class LocalizationConfigMapper {
  static HiveLocalizationConfig toHive(LocalizationConfig model) =>
      HiveLocalizationConfig(
        defaultLanguageCode: model.defaultLanguageCode,
        localizedTexts: model.localizedTexts,
      );
  static LocalizationConfig fromHive(HiveLocalizationConfig hive) =>
      LocalizationConfig(
        defaultLanguageCode: hive.defaultLanguageCode,
        localizedTexts: hive.localizedTexts ?? {},
      );
}

class HostContentMapper {
  static HiveHostContent toHive(HostContent model) => HiveHostContent(
        bio: model.bio,
        mission: model.mission,
        rss: model.rss,
        links: model.links?.map(LinkMapper.toHive).toList(),
      );
  static HostContent fromHive(HiveHostContent hive) => HostContent(
        bio: hive.bio,
        mission: hive.mission,
        rss: hive.rss,
        links: hive.links?.map(LinkMapper.fromHive).toList() ?? [],
      );
}

class LinkMapper {
  static HiveLink toHive(Link model) => HiveLink(
        title: model.title,
        url: model.url,
      );
  static Link fromHive(HiveLink hive) => Link(
        title: hive.title ?? '',
        url: hive.url ?? '',
      );
}

class CollectionMetaMapper {
  // Für Demo: Nur podcastOrigin wird persistiert, die anderen werden leer gesetzt
  static HiveCollectionMeta toHive(CollectionMeta model) => HiveCollectionMeta(
        source: model.podcastOrigin.source.name,
        version: model.podcastOrigin.updatedAt,
        lastSynced: DateTime.tryParse(model.podcastOrigin.updatedAt),
      );
  static CollectionMeta fromHive(HiveCollectionMeta hive) => CollectionMeta(
        podcastOrigin: DataOrigin(
          source: DataSourceType.values.firstWhere(
              (e) => e.name == (hive.source ?? 'local'),
              orElse: () => DataSourceType.local),
          updatedAt: hive.version ?? '',
          isFallback: false,
        ),
        episodeOrigin: DataOrigin(
          source: DataSourceType.local,
          updatedAt: hive.version ?? '',
          isFallback: false,
        ),
        hostOrigin: null,
      );
}
