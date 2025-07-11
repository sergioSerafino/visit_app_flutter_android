# Schrittweise Einführung und Dokumentation der Provider-Architektur für Podcast-Caching und RSS

## Ziel
- Robuste, testbare und transparente Provider-Architektur für Podcast-Daten und RSS.
- Sicherstellung, dass die UI und UX zu keinem Zeitpunkt beeinträchtigt werden.
- Enge Dokumentation aller Schritte, Erkenntnisse und Lessons Learned.

---

## Schritt 1: Provider-Architektur vorbereiten
- Analyse der bestehenden Provider und Datenflüsse.
- Definition der neuen Provider:
  - `rssProvider` für den gezielten RSS-Abruf und Parsing.
  - `rssMergeStatusProvider` für Status und Fehlertransparenz.
  - Anpassung des `podcastCollectionProvider` für den Merge-Prozess.
- Dokumentation der geplanten Architektur und Schnittstellen.

## Schritt 2: Implementierung und Aktivierung der Provider
- Implementierung der neuen Provider im Code.
- Zunächst nur für einzelne Collections/Seiten aktivieren (z. B. Test-Collection).
- Nach jedem Schritt: UI und Datenintegrität testen.
- Status und Fehler über das Snackbar-System (`SnackbarMessages`) transparent machen.
- Erkenntnisse und Probleme direkt dokumentieren.

## Schritt 3: Ausweitung und Stabilisierung
- Nach erfolgreichem Test: Ausweitung auf weitere Collections/Seiten.
- Fortlaufende Tests (UI, Offline-Modus, HivePage).
- Lessons Learned und Best Practices ergänzen.

## Schritt 4: Abschluss und Review
- Abschlussdokumentation der Provider-Migration.
- Review der Architektur und Schnittstellen.
- Optional: Vorschläge für weitere Verbesserungen (z. B. Retry-Buttons, Debug-UI).

---

## Geplante Schnittstellen und Architektur

### 1. RSSProvider
```dart
final rssProvider = FutureProvider.family<RssData, String>((ref, feedUrl) async {
  // RSS-Abruf und Parsing
  return await RssService.fetchAndParse(feedUrl);
});
```
- Übernimmt den gezielten Abruf und das Parsing von RSS-Feeds.
- Liefert ein vollständiges RssData-Modell für die angegebene Feed-URL.

### 2. RSSMergeStatusProvider
```dart
final rssMergeStatusProvider = StateProvider<RssMergeStatus>((ref) => RssMergeStatus.pending);
```
- Hält den aktuellen Status des Merge-Prozesses (pending, success, error).
- Ermöglicht UI-Feedback und Debug-Transparenz (z. B. Snackbar).

### 3. PodcastCollectionProvider (angepasst)
```dart
final podcastCollectionProvider = FutureProvider.family<PodcastHostCollection, String>((ref, collectionId) async {
  // 1. iTunes-Daten abrufen
  final itunesData = await ItunesService.fetch(collectionId);
  // 2. Lokale JSON laden
  final localJson = await LocalJsonService.load(collectionId);
  // 3. RSS abrufen (Provider)
  final rssData = await ref.watch(rssProvider(itunesData.feedUrl).future);
  // 4. Merge durchführen
  final merged = MergeService.merge(itunesData, rssData, localJson);
  // 5. Status aktualisieren
  ref.read(rssMergeStatusProvider.notifier).state = RssMergeStatus.success;
  // 6. In Hive speichern
  await Hive.box('podcastHostCollections').put(collectionId, merged);
  return merged;
});
```
- Nutzt die neuen Provider für den Merge-Prozess.
- Aktualisiert den Merge-Status und persistiert die gemergten Daten in Hive.
- UI und andere Provider können gezielt auf Status und Daten reagieren.

### 4. SnackbarMessages (für Status/Fehler)
- Das bestehende Snackbar-System wird genutzt, um Status und Fehler aus den Providern transparent und userfreundlich anzuzeigen.
- Beispiel: Bei Fehler im RSS-Merge wird eine Snackbar mit Debug-Info angezeigt.

---

**Empfohlene Datei für Fortschritt und Lessons Learned:**
- `.documents/provider_architektur_migration.md`

**Letztes Update:** 11.07.2025
