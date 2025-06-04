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
