# Datenpersistenz, Netzwerkabruf und Caching-Strategie in der White-Label-Podcast-App

## 1. Zielsetzung
- Robuste, nachvollziehbare Persistenz aller zentralen Datenmodelle (Podcast, Host, Episoden, Branding, Settings, ...)
- Für den Offline-First Ansatz und die Persitierung der Daten einen Top-Down Analyse der Abrufe: Netzwerkabruf → Merge → Persistenz (Hive) → Provider → UI
- Prioritäten: API (iTunes) > RSS > JSON > Local/Cache > Placeholder
- Da Datenabfragen Ressourcen kosten sollte schon der Fetch an sich  für Validierungen durch Timestamps nachvollziehbar sein (
  Bsp.-Szenario: beim Abruf nach dem Appstart wurden zwar die iTunes Daten aus der API aber nicht die RSS-Meta Daten für ein vollständige PodcastHostCollection-Entität erhalten. Da wäre ein übergeordneter Abgleich über vorherige Abrufe hilfreich damit in Abgrenzung zu dem vorherigen Abruf bei erneuten Abrufen die fehlenden Daten gezielt mit 'neuerer `timestamp`' angestrengt werden können) 
- Jede Entität erhält einen Timestamp (z.B. `downloadedAt`), um Frische und Merge-Strategien zu steuern

## 2. Netzwerkabruf & Provider-Architektur
- Abruf erfolgt immer über zentrale Provider (z.B. `podcastCollectionProvider`, `podcastEpisodeProvider`)
- Provider nutzen ein Repository-Pattern (API, RSS, Local, Mock)
- Reihenfolge: 
  1. Prüfe lokalen Cache (Hive, TTL)
  2. Wenn Cache frisch: sofort verwenden
  3. Sonst: API-Abruf (iTunes), dann RSS (über feedUrl aus iTunes), dann Merge mit JSON (about.json)
  4. Nach jedem erfolgreichen Abruf: Speichern in Hive inkl. Timestamp
  5. Bei Fehler/Offline: Fallback auf letzten Hive-Stand, dann Placeholder

## 3. Datenmodelle & Hive-Adapter
- Für jede Entität wird ein Hive-Adapter entwickelt:
  - HiveTypeId(0): HiveHost
  - HiveTypeId(1): HivePodcast
  - HiveTypeId(2): HiveEpisode
  - HiveTypeId(3): HiveSettings
  - HiveTypeId(4): HiveBranding
  - ...
- Die Modelle enthalten alle Felder, die aus iTunes, RSS und JSON gemergt werden können
- Jedes Modell erhält ein Feld `downloadedAt` (DateTime)
- Merge- und Mapping-Logik im `MergeService` (siehe Doku)

## 4. Caching- und Merge-Strategie
- MergeService priorisiert: about.json > iTunes > RSS
- Nach jedem Merge wird das Ergebnis persistent gespeichert (Hive)
- Bei jedem Abruf wird geprüft, ob ein frischer Cache existiert (TTL, z.B. 12h)
- Paging für Episoden: eigene Box pro CollectionId + PageIndex, Value = {data, timestamp}

## 5. Beispielhafter Datenfluss
```
collectionId → iTunes Lookup → RSS Abruf → Merge JSON → PodcastHostCollection → Hive + UI
```
- collectionId ist der Schlüssel für alle Daten (Host, Podcast, Episoden, Branding, ...)
- Die UI greift ausschließlich über Provider auf die gemergten und persistenten Modelle zu

## 6. Offene Fragen & ToDos
- Welche Felder sind für alle Modelle Pflicht, welche optional?
- Wie werden Konflikte (z.B. unterschiedliche Werte in RSS/iTunes/JSON) gelöst?
- Wie werden Migrationen/Schema-Änderungen in Hive gehandhabt?
- Wie werden Timestamps und TTLs für verschiedene Entitäten sinnvoll gesetzt?
- Wie werden Favoriten, Einstellungen und andere User-Daten persistent verwaltet?

## 7. Nächste Schritte
1. Analyse aller Netzwerkabrufe und Provider (API, RSS, JSON, Local)
2. Entwicklung und Registrierung aller Hive-Adapter für die zentralen Modelle
3. Implementierung/Review der Merge- und Persistenz-Logik
4. Testfälle für alle Fallback- und Offline-Szenarien
5. Dokumentation und Lessons Learned fortlaufend ergänzen

---

*Letzte Aktualisierung: 09.07.2025*
