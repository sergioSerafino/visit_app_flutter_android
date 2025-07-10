# Migrations- und Testplan: Schrittweise, risikoarme Umstellung des Podcast-Caching-Systems

## Ziel
- Sicherstellung, dass alle UI-Seiten (LandingPage, PodcastPage, HostsPage, HomePage, EpisodeDetailPage, ...) weiterhin reibungslos auch mit den gecachten Daten funktionieren.
- Schrittweise Migration von flacher `podcastBox`-Key-Value-Struktur hin zu strukturierter Hive-Box (`podcastHostCollections`), ohne Funktionsverlust oder Dateninkonsistenzen.

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

## Hinweise
- Nach jedem Schritt: UI und Datenintegrität testen!
- Keine "Big Bang"-Migration, sondern inkrementell und nachvollziehbar.
- Erst wenn alles stabil läuft, weitere Features (z. B. TTL, komplexe Modelle) aktivieren.

---

**Empfohlene Datei für Fortschritt und Lessons Learned:**
- `.documents/migration_plan_podcast_cache_hivebox.md`

**Letztes Update:** 10.07.2025
