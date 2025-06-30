// lib/core/placeholders/placeholder_content.dart
// Zentrale Placeholder-Modelle für die App

import '../../domain/models/host_content_model.dart';
import '../../domain/models/localization_config_model.dart';
import '../../domain/models/feature_flags_model.dart';
import '../../domain/models/branding_model.dart';
import '../../domain/models/contact_info_model.dart';

import '../../domain/models/host_model.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../domain/models/podcast_model.dart';
import '../../domain/models/podcast_episode_model.dart';

class PlaceholderContent {
  static Host get hostModel => Host(
        collectionId: -1,
        hostName: "__placeholder__",
        description: "Lade Inhalte...",
        primaryGenreName: "Unbekannt",
        contact: const ContactInfo(
          email: "",
          websiteUrl: "",
          impressumUrl: "",
          socialLinks: {},
        ),
        branding: const Branding(
          primaryColorHex: "#CCCCCC",
          secondaryColorHex: "#AAAAAA",
          themeMode: "system",
          headerImageUrl: "",
          logoUrl: "assets/placeholder/logo.png",
        ),
        features: const FeatureFlags(
          showPortfolioTab: false,
          enableContactForm: false,
          showPodcastGenre: false,
          customStartTab: "episodes",
        ),
        localization: const LocalizationConfig(
          defaultLanguageCode: "de",
          localizedTexts: {
            "welcomeText": "Willkommen!",
            "contactButton": "Kontakt",
          },
        ),
        content: const HostContent(bio: "", mission: "", rss: "", links: []),
        debugOnly: true,
        lastUpdated: DateTime.now(),
      );

  static PodcastCollection get podcastCollection => PodcastCollection(
        podcasts: [
          Podcast(
            wrapperType: "track",
            collectionId: -1,
            collectionName: "Noch keine Sammlung geladen",
            artistName: "Host noch nicht geladen",
            primaryGenreName: "Genre",
            artworkUrl600: "assets/placeholder/podcast.png",
            feedUrl: "",
            episodes: [placeholderEpisode],
          ),
        ],
      );

  static PodcastEpisode get placeholderEpisode => PodcastEpisode(
        wrapperType: "podcastEpisode",
        trackId: -1,
        trackName: "Aktuell keine Inhalte verfügbar.",
        artworkUrl600: "assets/placeholder/episode.png",
        description: "Sobald neue Episoden abrufbar sind, findest du sie hier.",
        episodeUrl: "",
        trackTimeMillis: 0,
        episodeFileExtension: "mp3",
        releaseDate: DateTime.now(),
      );

  static List<PodcastEpisode> get placeholderEpisodes => List.generate(
        5,
        (index) => PodcastEpisode(
          wrapperType: "podcastEpisode",
          trackId: -1 - index, // Eindeutige negative IDs für Platzhalter
          trackName: "Aktuell keine Inhalte verfügbar (Folge ${index + 1}).",
          artworkUrl600: "assets/placeholder/episode.png",
          description:
              "Sobald neue Episoden abrufbar sind, findest du sie hier.",
          episodeUrl: "",
          trackTimeMillis: 0,
          episodeFileExtension: "mp3",
          releaseDate: DateTime.now(),
        ),
      );

  //Bonus: Wenn du model.isPlaceholder brauchst, prüfe auf collectionId == -1 oder trackId == -1.
}
