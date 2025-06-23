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
- [x] Refactoring: Events und States im AudioPlayerBloc als `sealed class`/`final class` (Dart 3)
- [x] Fehlerhandling: ErrorState wird als Snackbar und im UI angezeigt
- [x] Ladeindikator: LoadingDots im BottomPlayerWidget für Loading-State
- [x] Accessibility: Semantics-Labels für Transport-Buttons und Slider im Player
- [x] Tests: Alle State-Wechsel (Idle, Loading, Playing, Paused, Error) und Fehlerfälle abgedeckt
- [ ] Produktive Integration von just_audio-Backend (kein Mock im Release)
- [x] UI/UX: Mini-Player in allen States sichtbar und bedienbar, konsistentes Feedback (Snackbar, Ladeindikator)
- [ ] Automatisierte Widget-/Integrationstests für alle State-Wechsel und Fehlerfälle
- [ ] Manuelle Tests auf echten Geräten (Android/iOS)
- [ ] Dokumentation und Lessons Learned ergänzen (laufend)
- [ ] **Neue Features vorbereiten:**
    - [x] Speed Control (Abspielgeschwindigkeit)
    - [ ] Download/Offline-Playback
    - [x] Resume (Wiedergabe an letzter Position fortsetzen)
    - [ ] AirPlay/Cast-Unterstützung
    - [ ] E2E-Tests für Audio-Playback und Download
    - [x] **Lautstärke-Kontrolle im BottomPlayerWidget**

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

## Audio-Feature-Checkliste (Stand 06/2025)
- [x] Audio-Playback (Streaming, Fehlerhandling, UX, Tests)
- [x] Speed Control (Abspielgeschwindigkeit wählbar, UI/UX, State, Test)
- [ ] Download/Offline-Playback (Service, Speicher, Caching, State, Test)
- [x] Resume (Wiedergabe an letzter Position, Persistenz, State, Test)
- [ ] AirPlay/Cast (Events, States, Backend, UI)
- [ ] E2E-Tests für alle Audio-Features (Playback, Download, Resume, Fehlerfälle)
- [ ] Accessibility-Tests für alle Audio-Features
- [x] **Lautstärke-Kontrolle im BottomPlayerWidget**

## Lessons Learned (Audio-Playback, Stand 06/2025)
- Die Migration auf Dart 3 sealed/final class für Events und States erhöht die Wartbarkeit und Typsicherheit.
- Fehler und Ladezustände werden explizit als State modelliert und in der UI angezeigt (Snackbar, LoadingDots).
- Accessibility wurde durch Semantics-Labels für Buttons und Slider verbessert.
- Die Testabdeckung umfasst alle State-Wechsel und Fehlerfälle.
- Die Architektur ist vorbereitet für weitere Audio-Features (Speed, Download, Resume, AirPlay/Cast).
- **Die Audio-URL (`episodeUrl`) wird ausschließlich aus der iTunes-API übernommen und im Model gespeichert.**
- **Fehlerquellen:** Leere oder ungültige URLs werden im Bloc abgefangen und führen zu einer Snackbar/Fehlermeldung (ErrorState). Die UI zeigt diese Fehler klar an.
- **Es gibt keine Fallback-Logik auf RSS oder lokale Quellen für die Audio-URL – die iTunes-URL ist maßgeblich.**
- **Testabdeckung:** Es existieren Tests für leere, ungültige und produktive URLs. Die Fehlerfälle sind robust abgedeckt.
- **Best Practice:** Die Übergabe der episodeUrl erfolgt immer explizit beim Tap auf eine Episode. Die Detailseite und der Player verlassen sich auf die im Model gespeicherte URL.

## Entscheidungsprotokoll (07.06.2025)
- Die produktive Integration des just_audio-Backends und die Entfernung aller Mocks im Release-Build sind als nächster Meilenstein festgelegt.
- Die Lautstärke-Kontrolle wird als rudimentäres Feature im BottomPlayerWidget ergänzt und getestet.
- Die Backend-/AudioHandler-Architektur bleibt erweiterbar für Speed Control, Download/Offline, Resume und AirPlay/Cast.
- Nach Abschluss dieser Schritte erfolgt ein erneuter Review und die Priorisierung der MVP-Features für den nächsten Sprint.

---

# ToDo-Liste (PRD-Dokumentation)

- [ ] Produktives Audio-Playback (just_audio, audio_service) vollständig aktivieren und testen (siehe audio_architektur_2025.md)
