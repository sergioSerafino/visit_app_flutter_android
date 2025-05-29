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
