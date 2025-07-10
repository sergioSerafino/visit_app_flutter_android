# Dokumentation: Nutzung von Hive und podcastBox in der White-Label-Podcast-App

## Übersicht
In der App wird Hive als lokale Datenbank für die Speicherung von Podcast- und Episoden-Daten verwendet. Die zentrale Hive-Box für Podcasts/Episoden wird im Code meist als `podcastBox` bezeichnet. Sie dient als Cache für komplette Podcast-Collections, um Offline-Fähigkeit und schnelle Ladezeiten zu gewährleisten.

---

## Key-Value-Struktur der podcastBox

- **Key:**
  - Die `collectionId` (meist als String, z. B. "12345")
- **Value:**
  - Ein serialisiertes Objekt vom Typ `PodcastCollection` oder `Podcast` (inkl. aller Felder und Episoden)

### Beispielhafte Felder im Value (PodcastCollection/Podcast):
| Feld              | Typ                    | Beschreibung                        |
|-------------------|------------------------|--------------------------------------|
| collectionId      | int                    | Eindeutige ID der Sammlung           |
| collectionName    | String                 | Name der Podcast-Sammlung            |
| artistName        | String                 | Name des Hosts/Künstlers             |
| primaryGenreName  | String                 | Genre                                |
| artworkUrl600     | String                 | Cover-URL                            |
| feedUrl           | String?                | RSS-Feed-URL (optional)              |
| episodes          | List<PodcastEpisode>   | Liste aller Episoden                 |

**Jede Episode enthält u. a.:**
| Feld              | Typ        | Beschreibung                |
|-------------------|------------|-----------------------------|
| trackId           | int        | Eindeutige Episoden-ID      |
| trackName         | String     | Titel der Episode           |
| artworkUrl600     | String     | Cover-URL der Episode       |
| episodeUrl        | String     | Audio-URL                   |
| trackTimeMillis   | int        | Dauer in Millisekunden      |
| releaseDate       | DateTime   | Veröffentlichungsdatum      |
| description       | String     | Beschreibung                |

---

## Typischer Ablauf
- Beim Laden einer Collection wird das komplette PodcastCollection-Objekt unter dem Key `collectionId` in der Box gespeichert:
  ```dart
  await Hive.box('podcastBox').put(collectionId.toString(), podcastCollection);
  ```
- Beim Abruf wird über den Key (`collectionId`) das gesamte Objekt geladen und in der App verwendet:
  ```dart
  final podcast = Hive.box('podcastBox').get(collectionId.toString());
  ```

---

## Hinweise
- Es werden keine verschachtelten oder komplexen Strukturen als Key verwendet, sondern immer ein einfacher, flacher Key (meist die CollectionId als String).
- Die Adapter-Dateien (z. B. `host_content_hive_adapter.g.dart`) dienen nur der Serialisierung/Deserialisierung und zählen nicht zur eigentlichen Nutzungsweise.
- Die Box kann beliebig viele PodcastCollections enthalten, jeweils unter ihrem eigenen Key.

---

## Persistenz oder temporäres Caching?

**Analyse (nur Code, keine *.md):**
- Die Nutzung der podcastBox im Code dient primär als **temporärer Cache** für Podcast- und Episoden-Daten.
- Die Daten werden nach dem Laden aus der API oder anderen Quellen in Hive gespeichert, um sie bei erneutem App-Start oder bei fehlender Verbindung schnell verfügbar zu machen (Offline-Fähigkeit).
- Es gibt keine explizite Langzeitpersistenz oder Backup-Strategie – die Daten werden überschrieben, wenn neue Daten geladen werden.
- Die App ist auf die Existenz der podcastBox angewiesen: Fehlt sie, funktioniert das Offline- und Fallback-Verhalten nicht wie vorgesehen.
- Die Persistenz ist also auf die Lebensdauer der App-Installation und den lokalen Speicher beschränkt (kein Sync, kein Export, kein Cloud-Backup).

**Fazit:**
- Die podcastBox wird aktuell als temporärer, aber persistenter Cache genutzt, nicht als dauerhafte Datenbank im klassischen Sinne.
- Ihr Zweck ist es, die App offlinefähig und schnell zu machen, nicht aber eine dauerhafte Archivierung oder Synchronisation zu gewährleisten.

---

## Fazit
Die Nutzung von Hive und der podcastBox ist klassisch und flach: Jeder Key entspricht einer Collection, der Value ist das vollständige Model als Map/Objekt. Die Architektur ist so gestaltet, dass sie einfach erweiterbar und für Offline-Szenarien robust ist.

---

*Stand: 10.07.2025*
