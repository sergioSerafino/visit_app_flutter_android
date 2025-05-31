# MergeService Prompt für ein LLM in VS Code (Code Pilot)

<!-- Siehe auch: ../doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: howto_merge_caching.md, howto_merge_decisions_and_field_sources.md -->

## Ziel
Implementiere eine Dart-Funktion `mergePodcastData`, die Daten aus drei Quellen mit folgender Priorität zusammenführt:
1. iTunes API
2. RSS Feed
3. Lokale JSON-Datei (`about.json`)

Das Ziel ist ein vollständiges Dart-Modell `PodcastHostCollection`, das Felder wie Titel, Beschreibung, Bild, Kontaktinformationen und Konfigurationsflags enthält.

## Anforderungen

### Strategie:
- **Höchste Priorität:** iTunes API (z. B. `trackName`, `collectionId`, `artworkUrl600`, `artistName`, `feedUrl`)
- **Zweite Priorität:** RSS Feed (z. B. `<title>`, `<description>`, `<itunes:image>`, `<itunes:author>`, `<itunes:owner><email>`)
- **Fallback:** Lokale JSON-Datei (z. B. `title`, `description`, `imageUrl`, `author`, `authTokenRequired`, `featureFlags`)

### Implementiere:
1. Eine Dart-Funktion `PodcastHostCollection mergePodcastData(ItunesData itunes, RssData rss, LocalJsonData local)`
2. Die Prioritätslogik für jedes Feld: `itunes.field ?? rss.field ?? local.field`
3. Optional: Flag `isManagedCollection`, gesetzt über separate ID-Liste oder wenn `authTokenRequired == true`
4. Typdefinitionen auf Basis von `json_serializable` oder `freezed`

## Beispielstruktur (vereinfacht)
```dart
PodcastHostCollection mergePodcastData(ItunesData itunes, RssData rss, LocalJsonData local) {
  const managedCollections = <int>[12345, 67890];

  return PodcastHostCollection(
    collectionId: itunes.collectionId ?? local.collectionId,
    title: itunes.trackName ?? rss.title ?? local.title ?? '',
    description: itunes.shortDescription ?? rss.description ?? local.description,
    logoUrl: itunes.artworkUrl600 ?? rss.imageUrl ?? local.imageUrl,
    author: itunes.artistName ?? rss.author ?? local.author,
    contactEmail: rss.ownerEmail ?? local.contactEmail,
    authTokenRequired: local.authTokenRequired ?? false,
    isManagedCollection: (local.authTokenRequired == true) ||
                         (itunes.collectionId != null && managedCollections.contains(itunes.collectionId!)),
    featureFlags: local.featureFlags ?? <String>[],
    lastUpdated: DateTime.now(),
  );
}
```

## Hinweise:
- Nutze `freezed` zur Definition der Modelle für `ItunesData`, `RssData`, `LocalJsonData` und `PodcastHostCollection`
- Alle drei Datenquellen gelten als erfolgreich geladen und validiert
- Nutze `??` zur Priorisierung der Felder (Null-Koaleszenz)
- Sprache: Deutsch (Kommentare im Code dürfen auf Englisch sein)
