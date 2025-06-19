// ...original code from storage_hold/lib/data/api/api_endpoints.dart...
// lib/data/api/api_endpoints.dart

class ApiEndpoints {
  // Basis-URL für die Lookup-API
  static const String baseUrl = "https://itunes.apple.com/lookup";

  // Statische URLs für Podcast-Sammlung und Episoden
  static String get podcastCollection => "$baseUrl?entity=podcast";

  static String podcastEpisodes(int collectionId, {required int limit}) {
    return "$baseUrl?id=$collectionId&entity=podcastEpisode&limit=$limit";
  }

  // Flexible Methode für den Podcast Lookup
  static String podcastLookup({
    required int collectionId,
    required int limit,
    // Optional: Länderspezifische Ergebnisse
    String? country,
    // Standardmäßig nach Podcast-Episoden suchen
    String entity = 'podcastEpisode',
    // Optional: Medienfilter (z. B. podcast, movie)
    String? media,
  }) {
    String url = "$baseUrl?id=$collectionId&entity=$entity&limit=$limit";

    // Optional: Füge einen Ländercode hinzu, wenn angegeben
    if (country != null) {
      url += "&country=$country";
    }

    // Optional: Füge einen Medienfilter hinzu, wenn angegeben
    if (media != null) {
      url += "&media=$media";
    }

    return url;
  }

  static String podcasts(int collectionId, {required int limit}) {
    return "$baseUrl?id=$collectionId&entity=podcastEpisode&limit=$limit";
  }
}

//  var httpsUri = Uri(
//  scheme: 'https',
//  host: 'dart.dev',
//  path: '/guides/libraries/library-tour',
//  fragment: 'numbers');
//  print(httpsUri); // https://dart.dev/guides/libraries/library-tour#numbers

/*
// Kapselung mit Uri statt String
// Für extra Robustheit kannst du später Uri statt String zurückgeben:

static Uri podcastEpisodesUri(int collectionId, {int limit = 3}) {
  return Uri.parse("$baseUrl?id=$collectionId&entity=podcastEpisode&limit=$limit");
}
 */
