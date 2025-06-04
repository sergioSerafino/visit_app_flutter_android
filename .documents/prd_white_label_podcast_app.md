# Übersicht: Audio-Playback & Download (Stand: 04.06.2025)

| Bereich                | Status/Umsetzung (IST)                                                                 | Testabdeckung         | Offene Punkte / ToDos                                                                 |
|------------------------|----------------------------------------------------------------------------------------|-----------------------|--------------------------------------------------------------------------------------|
| **Audio-Playback**     | Architektur, UI, Provider, Mock-Services, aber keine produktive Audiofunktion für User  | Architektur-Tests, UI | Echte Audio-Playback-Funktion fehlt, keine E2E-Tests, Fehlerhandling/UX teils offen   |
| **Download/Offline**   | Noch nicht implementiert, Architektur vorbereitet (Hive, FileSystem, Caching)           | -                     | Download-Service, Offline-Playback, Speicherstrategie, E2E-Tests, UX-Feedback         |

**Priorisierung:**
1. Audio-Playback (Streaming, Fehlerhandling, UX, Tests)
2. Download/Offline-Playback (Service, Speicher, Caching, Tests)
3. AirPlay/Chromecast (nach Abschluss von 1 & 2)

---

## ToDo-Liste (Audio-Playback → Download)

### Audio-Playback (PRIO 1)
- [ ] Produktive Integration von just_audio-Backend (kein Mock im Release)
- [ ] Fehlerhandling: Alle Fehlerfälle (URL, Netzwerk, Backend) robust abfangen und als Snackbar/State anzeigen
- [ ] UI/UX: Mini-Player in allen States sichtbar und bedienbar, konsistentes Feedback (Snackbar, Ladeindikator)
- [ ] Automatisierte Widget-/Integrationstests für alle State-Wechsel und Fehlerfälle
- [ ] Manuelle Tests auf echten Geräten (Android/iOS)
- [ ] Dokumentation und Lessons Learned ergänzen

### Download/Offline-Playback (PRIO 2)
- [ ] Download-Service für Episoden-Audio implementieren
- [ ] Speicherung im FileSystem, Metadaten in Hive
- [ ] Offline-Playback-Logik im AudioPlayerBloc/Service
- [ ] Caching- und Verfallsstrategie für lokale Dateien
- [ ] UI/UX: Download-Button, Statusanzeige, Snackbar-Feedback
- [ ] Automatisierte und manuelle Tests für Offline-Playback
- [ ] Dokumentation und Lessons Learned ergänzen

---

# Bestandsaufnahme & MVP-Review (Stand: 04.06.2025)

| Muss-Kriterium                        | Status/Umsetzung (IST)                                                                 | Testabdeckung         | Offene Punkte / ToDos                                                                 |
|----------------------------------------|----------------------------------------------------------------------------------------|-----------------------|--------------------------------------------------------------------------------------|
| **Audio-Wiedergabe inkl. AirPlay/Cast**| Architektur, UI, Provider, Mock-Services, aber keine produktive Audiofunktion für User  | Architektur-Tests, UI | Echte Audio-Playback- und Download-Funktion fehlt, keine Offline-Audio, keine E2E-Tests|
| **Offline-first**                      | Caching (Hive), Fallback, Platzhalter, viele Tests, aber nicht alles wirklich offline   | Unit-/Integration     | Audio nicht offline, Kontakt nur online, Fehlerfälle/UX teils unvollständig           |
| **zentraler SnackBarManager**          | Vollständig, global, mandantenfähig, getestet                                          | Unit-/Widget-Tests    | -                                                                                    |
| **Whitelabel-Ready (Branding, Farben)**| Vollständig, Theme-Provider, Fallback, getestet                                       | Unit-/Widget-Tests    | -                                                                                    |
| **iTunes-API als Hauptdatenquelle**    | Implementiert, MergeService, Fallback, getestet                                       | Unit-/Integration     | -                                                                                    |
| **Platzhalter-Logik global**           | Überall implementiert, getestet                                                       | Unit-/Widget-Tests    | -                                                                                    |
| **Kontakt via E-Mail**                 | E-Mail-Link, Fallback, Snackbar, aber nur online                                      | Unit-/Widget-Tests    | Funktioniert nicht offline                                                           |
| **Host-Portfolio/Info-Screen**         | Vollständig, FeatureFlag, getestet                                                    | Unit-/Widget-Tests    | -                                                                                    |
| **Favoritenfunktion via Riverpod**     | Lokal gespeichert, getestet                                                           | Unit-/Widget-Tests    | -                                                                                    |
| **Admin-Modus zur Live-Änderung**      | Vollständig, getestet                                                                 | Unit-/Widget-Tests    | -                                                                                    |

**Hinweise:**
- Die Tabelle wird fortlaufend gepflegt und ist Referenz für alle Reviews und MVP-Entscheidungen.
- Priorität für nächsten Meilenstein: Echte Audio-Wiedergabe (inkl. Offline-Playback und E2E-Tests).
- Für alle offenen Punkte sind konkrete ToDos und Testfälle zu ergänzen.

## Fragen & ToDo-Checkliste: Audio-Playback-Integration (Schritt 1)

**Technische Fragen:**
- Wird das just_audio-Backend im Release-Build wirklich produktiv genutzt, oder ist noch irgendwo ein Mock/Stub aktiv?
- Sind alle relevanten Fehlerfälle (z.B. ungültige URL, Netzwerkfehler, Backend-Fehler) im Bloc und in der UI robust abgefangen und getestet?
- Werden alle Audio-Events (Play, Pause, Stop, Seek, Fehler) korrekt im Bloc verarbeitet und an die UI weitergegeben?
- Ist die aktuelle Implementierung kompatibel mit allen Zielplattformen (Android, iOS, ggf. Web/Desktop)?
- Wie werden verschiedene Audioformate und Streaming-URLs (z.B. HLS, MP3) behandelt?

**UX-/UI-Fragen:**
- Gibt es ein konsistentes User-Feedback (Snackbar, Fehleranzeige, Ladeindikator), wenn Audio nicht abgespielt werden kann?
- Ist der Mini-Player/BottomPlayerWidget in allen relevanten States (Idle, Loading, Playing, Paused, Error) sichtbar und bedienbar?
- Wie wird mit mehreren Play-Requests (z.B. schneller Tap auf verschiedene Episoden) umgegangen?

**Test- und Qualitätsfragen:**
- Existieren automatisierte Widget-/Integrationstests, die echtes Audio-Playback (mit Test-URL) durchspielen?
- Werden alle State-Wechsel (Idle → Loading → Playing → Paused → Error → Idle) in Tests abgedeckt?
- Sind alle relevanten Streams (position, duration, playerState) im Test korrekt gemockt und geprüft?
- Gibt es manuelle Tests/Checklisten für Audio auf echten Geräten (Android/iOS)?

**Architektur-/Erweiterbarkeitsfragen:**
- Ist die Architektur so vorbereitet, dass AirPlay/Cast später einfach ergänzt werden kann (Events, States, Backend)?
- Sind alle Abhängigkeiten (just_audio, Provider, Bloc) sauber gekapselt und update-sicher?
- Wie wird mit Lifecycle-Events (App im Hintergrund, App geschlossen) umgegangen?

**Empfehlung:**
Diese Fragen und ToDos vor Umsetzung von Schritt 1 beantworten oder dokumentieren, um eine stabile, produktive Audio-Playback-Integration zu gewährleisten.

---

# Produkt-Requirements-Dokument (PRD): White-Label-Podcast-App

## Vision
Eine White-Labeling-App zur Unterstützung einer Podcast-Recording-Dienstleistung. Die App wird individuell pro Host gebrandet, gesteuert durch eine eindeutige `collectionId`.

## Zielgruppen
- Zuhörer:innen (Endnutzer:innen)
- Hosts / Podcaster:innen
- Admins / Betreiber:innen

## Muss-Kriterien
- Eine App = ein Host (gesteuert über `collectionId`)
- Offline-first
- Whitelabel-Ready (Branding, Farben, Inhalte)
- iTunes-API als Hauptdatenquelle
- Audio-Wiedergabe inkl. AirPlay / Chromecast
- Favoritenfunktion via Riverpod
- Admin-Modus zur Live-Änderung der `collectionId`

## Projektstruktur-Ergänzung
- Zentrale Platzhalter-Logik in `core/placeholders/`
- Mandanten-Assets in `tenants/`

## Tipps
- Halte Anforderungen und Architektur synchron
- Nutze Copilot Chat für Doku- und Architekturfragen
