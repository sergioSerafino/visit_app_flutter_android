# Migrations- und Testplan: Schrittweise, risikoarme Umstellung des Podcast-Caching-Systems

## Ziel
- Sicherstellung, dass alle UI-Seiten (LandingPage, PodcastPage, HostsPage, HomePage, EpisodeDetailPage, ...) weiterhin reibungslos auch mit den gecachten Daten funktionieren.
- Schrittweise Migration von flacher `podcastBox`-Key-Value-Struktur hin zu strukturierter Hive-Box (`podcastHostCollections`), ohne Funktionsverlust oder Dateninkonsistenzen.

---

## Lessons Learned & Fehlschläge
- **10.07.2025:** Erster Versuch, das produktive Caching für `podcastBox` (savePodcastCollection/savePodcastEpisodes) zu aktivieren, führte dazu, dass auf LandingPage, HomePage, PodcastPage und HostsPage nur Platzhalter angezeigt wurden und keine echten Daten aus dem Cache geladen wurden. Auf der HivePage waren keine Episoden-Daten sichtbar ("Keine Einträge vorhanden"). Die Funktionalität der App war dadurch beeinträchtigt. Das Caching wurde daraufhin wieder deaktiviert. 
- **Fazit:** Caching muss gezielt und seitenweise aktiviert und getestet werden, um unerwünschte Nebeneffekte zu vermeiden.

---

## Schritt 1: Status Quo sichern & Sichtbarkeit schaffen
- **HivePage** als Debug-/Admin-UI nutzen, um aktuelle Inhalte der `podcastBox` transparent zu machen.
- Sicherstellen, dass `savePodcastCollection` und `savePodcastEpisodes` im produktiven Code aktiviert sind (nicht auskommentiert!) und das Caching genutzt wird.
- Nach jedem erfolgreichen API-Request werden PodcastCollection und Episoden in die `podcastBox` geschrieben.
- **Test:**
  - App starten, Podcasts/Episoden laden, HivePage prüfen: Sind Einträge sichtbar?
  - UI (PodcastPage, HostsPage, etc.) muss wie gewohnt funktionieren.
  - Wenn an dieser Stelle alles wie erwartet läuft, kann eine einfache UI-Anpassung zur Verwaltung der flachen `podcastBox`-CRUD Handhabung erfolgen.

## Schritt 2: Offline-Fähigkeit testen
- **Internetverbindung trennen** (Flugmodus).
- App neu starten oder relevante Seiten öffnen.
- **Test:**
  - Werden gecachte Daten aus der `podcastBox` angezeigt?
  - Funktioniert die UI weiterhin ohne Fehler?
  - HivePage zeigt weiterhin die gecachten Daten.

## Schritt 3: Refactoring vorbereiten
- **Analyse:**
  - Welche Methoden/Seiten greifen direkt/indirekt auf die `podcastBox` zu?
  - Welche Daten werden wie gecacht (Collection, Episoden, Metadaten)?
- **Doku:**
  - Übersicht der aktuellen Cache-Keys und -Strukturen in `.documents/hive_podcastbox_nutzung.md` ergänzen.

## Schritt 4: Migration auf strukturierte Hive-Box (z. B. `podcastHostCollections`)
- **Implementierung:**
  - `LocalCacheClient` so anpassen, dass intern die neue strukturierte Box verwendet wird.
  - Methoden wie `savePodcastCollection`, `getPodcastCollection` etc. auf die neue Box umstellen.
  - Bestehende API für Provider/Repositories beibehalten.
- **Test:**
  - Schrittweise Migration: Zunächst nur einzelne Methoden/Keys umstellen und testen.
  - Nach jeder Änderung: App starten, Daten laden, HivePage/Debug-UI prüfen, Offline-Modus testen.

## Schritt 5: Konsolidierung & Erweiterung
- **Nach erfolgreicher Migration:**
  - Redundante/alte Caching-Logik entfernen.
  - Doku und Lessons Learned ergänzen.
  - Optional: Erweiterte Debug- und Admin-Tools für Cache-Management.

---

## Erkenntnisse zur Provider-Analyse und RSS-Handling
- Die zentralen Provider für die Mediendaten-Ebene sind aktuell `podcastCollectionProvider` und `podcastEpisodeProvider`.
- Ein expliziter Provider für den RSS-Abruf existiert bislang nicht. Der RSS-Download und das Merging der RSS-Daten erfolgen direkt im Repository/Service (z. B. im MergeService oder ApiPodcastRepository).
- Ursache: Die Architektur sieht vor, dass die Provider immer ein vollständiges, gemergtes Modell liefern (inkl. RSS, iTunes, JSON), sodass die UI nie mit halbfertigen Daten arbeitet. Der RSS-Abruf ist ein Teil des Merge-Prozesses und wird nicht separat als Provider gekapselt.
- Empfehlung: Für bessere Testbarkeit und Transparenz könnte ein eigener `rssProvider` oder ein expliziter RSS-Merge-Status-Provider ergänzt werden. So ließen sich Fortschritt, Fehler und Fallbacks gezielter steuern und debuggen.
- TODO: Architektur- und Doku-Review, ob ein eigener RSS-Provider sinnvoll und zukunftssicher ist.

---

## Best-Practice-Vorschlag: RSS-Abruf als eigener Provider
- Für eine robustere, testbare und transparente Architektur empfiehlt sich die Einführung eines eigenen `rssProvider` (z. B. FutureProvider.family<RssData, String>), der gezielt den RSS-Abruf übernimmt.
- Ergänzend kann ein `rssMergeStatusProvider` den Status des Merges und etwaige Fehler/Fallbacks transparent machen.
- Die Provider für die UI (z. B. podcastCollectionProvider) können dann gezielt auf den Status und die Daten des RSS-Providers reagieren und das Modell entsprechend mergen.
- Vorteil: Fortschritt und Fehler beim RSS-Abruf sind transparent und testbar, die UI kann gezielt reagieren (z. B. Ladeindikator, Fehlerhinweis, Retry-Button).
- Nach erfolgreichem Merge werden die Daten wie gewohnt in Hive persistiert.
- **Wichtig:** Das aktuelle UX- und UI-Verhalten bleibt unverändert – die UI erhält weiterhin nur vollständige, gemergte Modelle und zeigt nie halbfertige Daten.
- Die Integration des RSS-Providers ist ein optionaler, transparenter Schritt für bessere Testbarkeit und Debugging, ohne die Nutzererfahrung zu beeinträchtigen.
- Querverweise: `.documents/state_management_caching_multitenant.md`, `.instructions/howto_merge_caching.md`, `.documents/migration_plan_podcast_cache_hivebox.md`

---

## Hinweise
- Nach jedem Schritt: UI und Datenintegrität testen!
- Keine "Big Bang"-Migration, sondern inkrementell und nachvollziehbar.
- Erst wenn alles stabil läuft, weitere Features (z. B. TTL, komplexe Modelle) aktivieren.

---

**Empfohlene Datei für Fortschritt und Lessons Learned:**
- `.documents/migration_plan_podcast_cache_hivebox.md`

**Letztes Update:** 10.07.2025
