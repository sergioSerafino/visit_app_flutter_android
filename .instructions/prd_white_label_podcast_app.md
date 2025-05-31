<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->

# Produkt-Requirements-Dokument (PRD): White-Label-Podcast-App

## 🌍 Vision
Eine White-Labeling-App zur Unterstützung einer Podcast-Recording-Dienstleistung. 
Die App wird individuell pro Host gebrandet, gesteuert durch eine eindeutige `collectionId`. 
Ziel ist eine sofort nutzbare, intuitive App zur Repräsentation und Distribution von Audio-Inhalten, 
Kontaktaufnahme und Host-Präsenz, sowohl online als auch offline.

## ⚖️ Zielgruppen
- **Zuhörer:innen** (Endnutzer:innen)
- **Hosts / Podcaster:innen**
- **Admins / Betreiber:innen**

## ✅ Muss-Kriterien
- Eine App = ein Host (gesteuert über `collectionId`)
- Offline-first
- zentraler SnackBarManager
- Whitelabel-Ready (Branding, Farben, Inhalte)
- iTunes-API als Hauptdatenquelle
- Platzhalter-Logik global bei fehlender Verbindung
- Audio-Wiedergabe inkl. AirPlay / Chromecast
- Kontaktmöglichkeit via E-Mail
- Host-Portfolio/Info-Screen
- Favoritenfunktion via Riverpod
- Admin-Modus zur Live-Änderung der `collectionId`

| Funktion 				| Verhalten im Init-Modus (collectionId == null)						|
|-----------------------|-----------------------------------------------------------------------|
| 🎧 Podcast-Tab 		| Zeigt Platzhalter-Inhalte mit AsyncListFallback						|
| 👤 Host-Info 			| Lädt tenants/common/about.json (generisches Profil)					|
| ✉️ Kontakt 			| Funktioniert, aber ggf. mit leerer E-Mail-Adresse + Snackbar-Hinweis	|
| 🌐 Theme 				| theme.dart aus tenants/common/										|
| 🧩 FeatureFlags 		| Default-Flags (z.B. showPortfolioTab: false)							|
| 🛠 Admin-Modus 		| Aktivierbar, um collectionId manuell einzugeben						|
| 📦 Datenquellen 		| RSS/iTunes werden nicht geladen → keine API-Calls notwendig			|
| 📡 Netzwerk 			| Wird nicht benötigt – App bleibt vollständig offlinefähig				|
| 🧾 Snackbar-Events	| Default-Snackbars funktionieren normal (snackbar_config.yaml)			|

## Projektstruktur Ergänzung
```
lib/
├── core/
│   └── placeholders/
│       └── placeholder_content.dart       # zentrale Sammlung
│
├── domain/models/
│   └── host_model.dart                    # enthält isPlaceholder
│
├── application/providers/
│   └── placeholder_provider.dart          # optional, falls Provider gebraucht wird
```


## ✨ Kann-Kriterien
- Wiedergabe nach Neustart
- Transkripte
- Teilen-Button (Messages, WhatsApp, etc.)


---

## 📅 Feature Übersicht

## 🎧 Feature 1: Podcast-Funktionalität (Haupt-Tab)
- Verknüpfung via collectionId mit JSON kompatibel mit iTunes-API: Episoden (JSON), Podcast-Metadaten (Cover, Genre aus der Mediendaten-Ebene (iTunes/RSS))
- Adresse des feedUrl ist ein Feld erreichbar über collectionId -> RSS-Feed (Anchor): Beschreibung, E-Mail, Links (Konfigurations-/Plattform-Ebene (JSON/RSS))
- AsyncList mit Platzhalter-Fallback
- Audio-Wiedergabe mit Mini-Player (Bloc)
- Geschwindigkeit steuerbar
- Mirroring (AirPlay/Chromecast)
- Favoritenfunktion via Riverpod
- Preloading-Ziel: kurze Vorladezeit (~1 Minute) für schwache Netzverbindungen
- Caching-Strategie: downloadedAt per Hive gesteuert
- Discovery für AirPlay/Chromecast über systemweiten Player erfolgt – lokale Netzwerke werden unterstützt, sofern System es erkennt
- Favoriten werden lokal gespeichert, mit Riverpod & SharedPreferences
- Sync über Geräte hinweg ist in V1 nicht vorgesehen, aber als Erweiterung möglich
- Kein Tracking, keine Authentifizierung nötig – datensparsam

## 🧑 Feature 2: Host Portfolio (Zweiter Tab)
- Datenquellen: RSS + lokales `about.json`
- Strukturierte Anzeige: Branding, Angebote, Bio, Kontakt
- FeatureFlags: z.B. `showPortfolioTab`, `customStartTab`
- ScrollView mit dynamischen Cards / Abschnitten

## 📬 Feature 3: Kontaktformular
- Initial per E-Mail-Link mit Subject
- Später optional erweitert (z. B. Chat-Formular, Dialog etc.)
- Host-spezifisch durch Config / FeatureFlag gesteuert
- Fallback: Wenn kein E-Mail-Client installiert → SnackBar mit Hinweis
- Offline: Wenn kein Netz vorhanden ist, wird Versandversuch blockiert, Hinweis erscheint – kein Queueing in V1 vorgesehen
- Option auf Firebase-Auth später, derzeit ohne Login nutzbar

---

## 🚀 Technische Architektur
- OTA-Registry funktioniert über hostbare JSON-Datei (z.B. via Firebase CDN)
- Download bei App-Start (WLAN oder Mobilfunk), Caching über Hive
- Kein RemoteConfig notwendig – effizient, datensparsam und offline-tolerant

### Clean Architecture Layers
- eine saubere Clean Architecture mit Schichten: data → domain → application → presentation
- **Application**: 
- **UI Layer**: Flutter Widgets, ViewModels, Riverpod States
- **Domain Layer**: UseCases, Entities (Podcast, Host)
- **Data Layer**: Repositories, DTOs, APIs (iTunes, RSS), Hive

### DI & Modularität via GetIt
- Dynamische Umschaltung des gesamten App-Kontexts über GetIt
- Zentraler `AppConfig`-Singleton
- Sigleton Audio-Player-Instanz

### State Management
- **Riverpod** für globale States (Favoriten, AppConfig, Auth)
- **Bloc** für Audio-Player und Transportfunktionen
- 🔄 `hostModelNotifier.reset()`
- Leert Zustand gezielt beim Collection-Wechsel
- Alle abhängigen Riverpod-Provider (z.B. FeatureFlags, HostTheme) sind `autoDispose`
- Garantiert saubere Trennung zwischen Hosts

``` 
📱 App wird gestartet
  ↓
🧠 Es liegt keine gültige collectionId vor
  ↓
📁 App lädt Fallback-Mandanten aus `tenants/common/`
  ↓
📦 Default-HostModel & Theme werden verwendet
  ↓
🎨 App startet mit generischem Branding, Platzhalter-Inhalten und aktiviertem Demo-Mode
```

## 🔄 ungefährer Datenfluss im Init-Modus
```
(no collectionId)
    ↓
TenantManager.load('common')
    ↓
lädt about.json, theme.dart, flags aus tenants/common/
    ↓
erstellt default HostModel
    ↓
aktualisiert Provider (hostModelProvider, themeProvider)
    ↓
UI initialisiert sich mit Platzhalter-Inhalten

```

## 🧱 Strukturrelevante Bausteine für den Default-Fallback

| Komponente 				| Zweck im Init-Modus 						| Pfad						 |
|---------------------------|-------------------------------------------|----------------------------|
| tenants/common/ 			| Fallback-Inhalte & Theme 					| lib/tenants/common/		 |
| app_config.dart 			| erkennt leere collectionId → lädt common 	| lib/						 |
| tenant_manager.dart 		| verwaltet collectionId & Umschaltung 		| lib/core/					 |
| MergeService 				| wird im Default-Modus nicht aktiv 		| lib/data/services/   		 |
| FeatureFlagService 		| nutzt lokal vorhandene JSON-Flags 		| lib/data/services/		 |
| snack_bar_manager.dart 	| zeigt z.B. „Demo-Modus aktiv“ 			| lib/core/messaging/ 		 |
| hostModelProvider 		| enthält generisches HostModel 			| lib/application/providers/ |

## Error Handling & Logging: zentraler SnackBarManager
- Eine zentrale Error-Handler-Klasse ( core/logging/error_handler.dart ) wird genutzt, um Fehler aus den Data Sources, Repositories und anderen UseCases zu sammeln und gegebenenfalls an die UI zu melden.
- Messenger-Erweiterungen
- Priorisierung von Nachrichten (Fehler > Info > Erfolg)
- Undo-Funktionalität
- Kontextbasierte Anzeige (z.B. nur auf bestimmten Pages)
- Message Queueing für asynchrone Operationen

## Strukturidee Messaging
```
lib/
├── core/
│   └── messaging/
│       ├── snackbar_event.dart           # Datenmodell
│       ├── snackbar_manager.dart         # Zentrale Verwaltung
│       ├── snackbar_event_factory.dart   # Dynamische Factory
│       └── snackbar_config.yaml          # Event-Mapping (z.B. nach Typ, Sprache, Mandant)
```

| Komponente / Datei 			| Zweck / Verantwortung 											| Layer					|
|-------------------------------|-------------------------------------------------------------------|-----------------------|
| snackbar_event.dart 			| Definition der SnackBar-Nachricht (Text, Typ, Dauer, Icon etc.) 	| core/messaging/		|
| snackbar_manager.dart 		| Singleton/Service zur Verwaltung & Weiterleitung der Events 		| core/messaging/ 		|
| snackbar_listener.dart 		| Lauscht auf globale App-Events, leitet relevante an Manager 		| application/			|
| global_snackbar_layer.dart 	| UI-Komponente zur Anzeige der aktuellen Nachricht 				| presentation/			|
| main.dart / app.dart 			| Einbindung des GlobalSnackBarLayer als globales UI-Overlay 		| Root-Level			|
| env.dart 						| Kann Verhalten der Snackbar im Demo/Dev-Modus steuern 			| config/				|
| constants.dart 				| Zentrale Defaults für Farben, Icons, Snackbar-Dauer 				| core/					|


## Eventfluss eines SnackBarEvents
```
[Feature] oder [UseCase]
    ↓
dispatch SnackbarEvent (z.B. über Provider, BLoC oder Listener)
    ↓
[application/listeners/snackbar_listener.dart]
    ↓
leitet Event an →
[core/messaging/snackbar_manager.dart]
    ↓
ändert internen State / Stream / Notifier
    ↓
[presentation/widgets/global_snackbar_layer.dart]
    ↓
zeigt Snackbar über ScaffoldMessenger an

```

## Verzeichnisstruktur aus halberfertiger Prototyp mit Teilen aus Feature 1 und 2
```
│   app.dart
│   main.dart
│
├───application
│   ├───controllers
│   │       collection_load_controller.dart
│   │       episode_load_controller.dart
│   │       should_load_controller.dart
│   │
│   ├───listeners
│   │       snackbar_listener.dart
│   │
│   └───providers
│           app_mode_provider.dart
│           collection_provider.dart
│           data_mode_provider.dart
│           episode_controller_provider.dart
│           onboarding_status_provider.dart
│           podcast_provider.dart
│           provides_a_snackbar_event.dart
│           repository_provider.dart
│           theme_provider.dart
│
├───config
│       app_routes.dart
│       app_theme.dart
│       app_theme_defaults.dart
│       app_theme_mapper.dart
│       di.dart
│       env.dart
│       tenant_branding_service.dart
│       tenant_loader_service.dart
│
├───core
│   │   constans.dart
│   │
│   ├───extensions
│   │       podcast_collection_debug_extension.dart
│   │
│   ├───logging
│   │       logger_config.dart
│   │
│   ├───messaging
│   │       messaging_types.dart
│   │       snackbar_config.yaml
│   │       snackbar_event.dart
│   │       snackbar_manager.dart
│   │
│   ├───placeholders
│   │       placeholder_content.dart
│   │       placeholder_loader_service.dart
│   │
│   ├───services
│   │       merge_service.dart
│   │
│   ├───storage
│   │       shared_prefs_service.dart
│   │
│   └───utils
│           network_cache_manager.dart
│           podcast_collection_parser.dart
│           rss_parser_service.dart
│           rss_service.dart
│           tenant_asset_loader.dart
│           validation.dart
│
├───data
│   ├───api
│   │       api_client.dart
│   │       api_endpoints.dart
│   │       local_cache_client.dart
│   │
│   └───repositories
│           api_podcast_repository.dart
│           cached_podcast_repository.dart
│           mock_podcast_repository.dart
│           podcast_repository.dart
│
├───domain
│   ├───common
│   │       api_response.dart
│   │       api_response.freezed.dart
│   │       api_result.dart
│   │
│   ├───enums
│   │       collection_load_state.dart
│   │       data_source_type.dart
│   │       episode_load_state.dart
│   │       repository_source_type.dart
│   │
│   ├───models
│   │       branding_model.dart
│   │       branding_model.freezed.dart
│   │       branding_model.g.dart
│   │       collection_meta_model.dart
│   │       collection_meta_model.freezed.dart
│   │       collection_meta_model.g.dart
│   │       contact_info_model.dart
│   │       contact_info_model.freezed.dart
│   │       contact_info_model.g.dart
│   │       data_origin_model.dart
│   │       data_origin_model.freezed.dart
│   │       data_origin_model.g.dart
│   │       feature_flags_model.dart
│   │       feature_flags_model.freezed.dart
│   │       feature_flags_model.g.dart
│   │       host_content_model.dart
│   │       host_content_model.freezed.dart
│   │       host_content_model.g.dart
│   │       host_model.dart
│   │       host_model.freezed.dart
│   │       host_model.g.dart
│   │       link_model.dart
│   │       link_model.freezed.dart
│   │       link_model.g.dart
│   │       localization_config_model.dart
│   │       localization_config_model.freezed.dart
│   │       localization_config_model.g.dart
│   │       podcast_collection_model.dart
│   │       podcast_collection_model.freezed.dart
│   │       podcast_collection_model.g.dart
│   │       podcast_episode_model.dart
│   │       podcast_episode_model.freezed.dart
│   │       podcast_episode_model.g.dart
│   │       podcast_host_collection_model.dart
│   │       podcast_host_collection_model.freezed.dart
│   │       podcast_host_collection_model.g.dart
│   │       podcast_model.dart
│   │       podcast_model.freezed.dart
│   │       podcast_model.g.dart
│   │
│   ├───service
│   │       merge_service.dart
│   │
│   └───usecases
│           fetch_podcast_collection_usecase.dart
│
├───l10n
│       intl_de.arb
│
├───presentation
│   ├───pages
│   │       episode_detail_page.dart
│   │       home_page.dart
│   │       hosts_page.dart
│   │       landing_page.dart
│   │       launch_screen.dart
│   │       onboarding_page.dart
│   │       podcast_page.dart
│   │       preferences_page.dart
│   │       snackbar_debug_page.dart
│   │       splash_page.dart
│   │
│   └───widgets
│       │   bottom_player_widget.dart
│       │   button_icon_navigation.dart
│       │   collection_input_widget.dart
│       │   collection_input_wrapper.dart
│       │   cover_image_widget.dart
│       │   custom_text_field.dart
│       │   episode_item_tile.dart
│       │   global_snackbar.dart
│       │   home_header.dart
│       │   image_with_banner.dart
│       │   loading_dots.dart
│       │   rss_debug_viewer.dart
│       │   splash_cover_image.dart
│       │   sticky_info_header.dart
│       │   welcome_header.dart
│       │
│       └───async
│               async_ui_helper.dart
│               async_value_widget.dart
│
└───tenants
    ├───collection_0123456789
    │   │   host_model.json
    │   │   podcast_collection.json
    │   │   theme.dart
    │   │
    │   └───assets
    │           logo.png
    │           opalia_talk_logo.png
    │           opalia_talk_reduced.png
    │
    ├───collection_9876543210
    │   │   host_model.json
    │   │   podcast_collection.json
    │   │   theme.dart
    │   │
    │   └───assets
    │           logo.png
    │
    └───common
        │   host_model.json
        │   podcast_collection.json
        │   theme.dart
        │
        └───assets
                visit22.png
```


## 🌐 Datenquellen
- **iTunes Search API** (public): Episoden, Metadaten (per `collectionId`)
- **RSS (Anchor.fm)**: Beschreibung, E-Mail, Links
- **Lokale JSON (z.B. `about.json`)**: Branding, Angebote, Kontaktinfos
- Konfliktlösung: bei Widersprüchen gelten Werte aus `about.json` als vorrangig, dann iTunes, zuletzt RSS
- RSS wird bei App-Start geladen, aber durch lokale Kopie bei erneutem Öffnen gecacht
- Netzstrategie: Fetch erfolgt über Dio mit Timeout + Fallback zur Hive-Kopie

## 📦 Datenarten
| Art 						| Beispiele 								| Speicherziel 						| Technologie
|---------------------------|-------------------------------------------|-----------------------------------|------------------------------------------------------------|
| Einstellungen 			| Darkmode, Favoriten, Auth-Daten			| dauerhaft, klein 					| SharedPreferences (evtl. flutter_secure_storage für E-Mail)|
| Podcasts & Episoden 		| API-Daten, Listen	von Podcasts/Episoden	| lokal halten, ändern selten		| Hive (perfekt für strukturierte JSON-artige Objekte)		 |
| Offline-Episoden 			| Audio-Dateien, Downloads					| mit "Verfallslogik", viel Platz	| Dateisystem + Hive für Metadaten							 |
| Kommunikation (Anfragen)	| form data, evtl. Chat? 					| flüchtig /serverseitig			| ggf. über Firestore oder direkt per REST 					 |

## 🗂 CollectionRegistryService
- Ein eigenständiger Dienst zur Verwaltung der verfügbaren `collectionId`-Konfigurationen:
- Lädt `collections.json` via Remote-Endpunkt
- Nutzt TTL-Cache (Default: 24h) per Hive
- Verwendet bei Fehlern/Offline-Fall automatisch Fallback-Kopie
- Eingesetzt bei App-Start und Admin-Host-Wechsel

## 🔁 Datenfluss
```
collectionId → iTunes Lookup → RSS Abruf → Merge JSON → PodcastHostCollection → Hive + UI
collectionId → iTunes Lookup → HRSS Abruf → Merge JSON → PodcastHostCollection → Hive + UI
[QR-Code] → collectionId → iTunes Lookup → RSS Abruf → Merge JSON → PodcastHostCollection → Hive + UI
[QR-Code] → collectionId → iTunes Lookup → RSS Abruf → Merge JSON → PodcastHostCollection → Hive + UI
```

## 🧬 MergeService (kritisch vs nice-to-have)
- Führt `about.json`, RSS und iTunes zusammen
- Felder wie `hostName`, `logoUrl`, `contactEmail` als "systemkritisch" markiert
- Weitere Felder wie `themeMode`, `localizedTexts` gelten als optional
- Speichert `fetchedSources` + Timestamps zur Fehleranalyse

## ✈️ Offline-First-Strategie:
- Offline-Modus umfasst gespeicherte Episoden, UI-Elemente (Tabs, Header), Hostinfos und zuletzt gültige Feeddaten
- Hintergrundsync über Mobilfunk ist aktuell nicht vorgesehen, aber durch Cache-Aktualisierung beim App-Start vorbereitet

## Caching-Strategie für Offline-Episoden:
- Neben den Metadaten in Hive werden die Audiodateien im Dateisystem speichern.
- Ein zusätzlicher Service (z. B. OfflineEpisodeManager) soll prüfen, ob die Dateien noch gültig sind (z. B. mittels eines Verfallsdatums) und sie bei Bedarf löschen.

## 🧬 FeatureFlags
- FeatureFlags sind bei App-Start aktualisierbar, werden lokal persistiert
- OTA-Update über JSON-File – kein RemoteConfig nötig, aber kombinierbar
- Flags wirken auf Tabs, DefaultTab, Sichtbarkeit von Buttons und Content Cards

Definieren UI- oder Feature-Verhalten appweit:
- `showPortfolioTab`
- `enableContactForm`
- `showPodcastGenre`
- `customStartTab`
- "Audio-Transport" `...`

## 🧩 FeatureFlagSet & FeatureFlagService (überarbeitet)
- Enthält typisierte Properties (z.B. `bool get enableContactForm`)
- Getter statt `Map<String, dynamic>`
- Einbindung in Provider-Struktur via Riverpod
- Erweiterbar ohne UI zu brechen

## 🎧 AudioPlaybackService
- Verwaltet zentrale `just_audio` Instanz
- Fehler automatisch per Snackbar ausgegeben
- Kompatibel mit AirPlay/Chromecast
- Bereit für Erweiterung (Streaming, DRM etc.)

## Beispiel anhand von "Play Button gedrückt"
- Zusammenhang BloC + GetIt + Clean Arch
```
UI (play_button.dart)  
↓
dispatch(PlayerPlayRequested(audioEpisode))   
↓
application/blocs/player/player_bloc.dart   
↓
→ ruft playAudioUseCase(audioEpisode)   
↓
domain/usecases/play_audio_usecase.dart   
↓
→ nutzt AudioRepository.play(audioEpisode)   
↓
data/audio/audio_repository_impl.dart   
↓
→ spricht GetIt<AudioPlayerService> an   
↓
just_audio spielt los, ggf. mit AirPlay/Cast
```

## ⭐️ Favoriten-Funktion
- Favoriten werden lokal gespeichert, mit Riverpod & SharedPreferences
- Sync über Geräte hinweg ist in V1 nicht vorgesehen, aber als Erweiterung möglich
- Kein Tracking, keine Authentifizierung nötig – datensparsam

## 🔐 Security & Datenschutz
- Keine personenbezogenen Daten werden erhoben oder gespeichert
- DSGVO-konform durch System-Client-Nutzung bei Kontakt (z.B. Mail)
- HTTPS wird für alle API- und Registry-Calls vorausgesetzt
- Kein AuthToken nötig – Auth ist optional für spätere Features

## 🛠️ Admin-Modus

- strategisches Konzept mit dem HostModel als zentrales KontextObjekt:
```Ziel: Dass sich nach der Erkennung der collectionld 
   (z. B. durch die Eingabe über QR) alle relevanten Inhalte und UI-Verhalten 
   automatisch auf den jeweiligen Host beziehen.```
   
| Mechanismus mit Schritten im Ablauf der App                               |
|---------------------------------------------------------------------------|
| 1 . collectionId wird erkannt (beim Start, via QR, RemoteConfig etc.)		|
| 2 . Passendes JSON-Objekt wird geladen (HostModel + PodcastCollection)	|
| 3 . Beide werden lokal in Hive gespeichert								|
| 4 . HostModel wird als zentrales „Kontextobjekt“ in der App gehalten		|
| 5 . UI & Business Logic greifen auf das aktive HostModel zu				|

- Diagramm zur KomponentenStruktur mit HostModel:
```
 +----------------------------+
 |        App Start           |
 +----------------------------+            
				|            
				v
 +----------------------------+		  +----------------------------+       
 | collectionId Resolver      |<----->| RemoteConfig / QR / Dev-Env|
 +----------------------------+       +----------------------------+            
				|            
				v
 +----------------------------+       +----------------------------+
 | PodcastCollection Loader   |<----->| RSS / Feed API             |
 +----------------------------+       +----------------------------+            
				|            
				v
 +----------------------------+       +----------------------------+
 | HostModel Loader           |<----->| host_{collectionId}.json   |
 +----------------------------+       | via Dio                    |            
				|                     |----------------------------+            
				v
 +----------------------------+
 | Hive Storage: hostInfoBox  |	
 +----------------------------+            
				|            
				v
 +----------------------------+
 | hostModelProvider (Riverpod)
 +----------------------------+            
				|            
				v
 +----------------------------+
 | UI Layer (Tabs, Farben, Titel, Inhalte)
 +----------------------------+
```

- die Eingabe einer neuen `collectionId` via TextField im AppBar `action`-Bereich rechts von `title` (Tab 1)
- Getriggert wird der dynamischen Wechsel über EnvironmentManager
- Validierung gegen bereits über Hive deployte collectionIds in einer Collection-Registry (z.B. Firebase/Supabase)
- Retry-Logik: Bei fehlender Verbindung wird die letzte gültige Registry-Kopie aus Hive verwendet
- Wechselprozess zeigt visuelles Feedback per SnackBar
- Bei Fehlschlag oder Timeout → User-Feedback, kein Absturz


---

## 🚪 White-Labeling & Multi-Host-Support (Zukunftssicher)
- OTA-Registry funktioniert über hostbare JSON-Datei (z.B. via Firebase CDN)
- Download bei App-Start (WLAN oder Mobilfunk), Caching über Hive
- Kein RemoteConfig notwendig – effizient, datensparsam und offline-tolerant

### Architektur für Multi-Host-Fähigkeit
- **collectionId = zentrale Steuer-ID**
- Jede ID repräsentiert eine vollständige Host-Konfiguration
- ```
lib/
  └── collections/
  ├── collection_anna/
  │   ├── theme.dart
  │   ├── about.json
  │   ├── assets/
```
- Datenmodel für Infos ergänzed zu RSS aus `about.JSON`


## Zusammenführung von Datenquellen für eine collection
- in der Ausgangslage ergeben sich anhand von `collectionId` Daten aus zwei unterschiedlichen Quellen:
```
1. RSS-Daten (z. B. als Map<String, dynamic> nach dem Parsen)
2. JSON-Konfiguration (ebenfalls Map<String, dynamic>)
```
- RSS / iTunes Lookup: "öffentliche" und allgemein verfügbare Podcast—Metadaten für Basiseintrage, Beschreibung, Cover, E-Mail
- about.json (remote via Dio + Hive gecacht)
- App-spezifische, UI-relevante und visuelle Zusatzinfos

| Feld 						| Typ 					| Herkunft	| Beschreibung						|
|---------------------------|-----------------------|-----------|-----------------------------------|
| primaryColorHex 			| String? 				| JSON     	| UI-Farbe 1						|
| secondaryColorHex 		| String? 				| JSON		| UI-Farbe 2						|
| themeMode 				| String? 				| JSON 		| "light", "dark", "system"			|
| headerlmageUrl 			| String? 				| JSON		| Optionales zusätzliches Titelbild	|
| impressumUrl 				| String? 				| JSON		| Link zum Impressum/Datenschutz	|
| socialLinks 				| Map<String‚ String>? 	| JSON 		| z. B. lnstagram, LinkedIn			|
| showPortfolioTab 			| bool? 				| JSON 		| Feature-Flag						|
| enableContactForm 		| bool? 				| JSON 		| Feature-Flag						|
| showPodcastGenre 			| bool? 				| JSON 		| Steuerung für Genre-Anzeige		|
| customStartTab 			| String? 				| JSON 		| "episodes" / "home" etc.			|
| localizedTexts 			| Map<String‚ String>? 	| JSON 		| für Buttontexte, Begrüßung,		|
| Labels authTokenRequired 	| bool? 				| JSON 		| Schutzmechanismus aktiv?			|
| debugOnly 				| bool? 				| JSON 		| Nur in Debug sichtbar?			|
| lastUpdated 				| DateTime? 			| JSON 		| Timestamp für Syncprüfung			|

- Kombninierte Daten aus RSS via iTunes-JSON erreicht über collectionId

| Feld 					| Typ 		| Herkunft 		| RSS-Tag									| Beschreibung                                  |
|-----------------------|-----------|---------------|-------------------------------------------|-----------------------------------------------|
| collectionId 			| int 		| systemintern 	| nicht im RSS, sondern im iTunes-API Lookup| Technischer Schlüssel für Host-Zuordnung		| 
| hostName 				| String 	| RSS 			| <itunes:author> oder <author>				| Podcast-Author (z. B. itunes:author)			| 
| description 		| String 	| RSS 			| <itunes:summary> oder <description>		| Kurze App-Beschreibung						| 
| contactEmail 			| String? 	| RSS 			| <itunes:email> innerhalb <itunes:owner>	| Aus <itunes:email>							| 
| websiteUrl 			| String? 	| RSS 			| <link>									| Hauptseite des Hosts							| 
| logoUrl 				| String? 	| RSS 			| <itunes:image href="..."> o. <image><url>	| Cover des Podcasts							| 
| defaultLanguageCode 	| String? 	| RSS 			| <language>								| z. B. de, en									| 
| primaryGenreName 		| String? 	| iTunes Lookup | nicht im RSS, sondern im iTunes-API Lookup| z. B. „Spirituality"							| 

- App lädt über eine Registry-Liste dynamisch neue Konfigurationen etwa wie:

```json
{
  "collectionId": "abc123",
  "rssUrl": "https://anchor.fm/rss/abc123",
  "contactEmail": "info@abc-podcast.de",
  "featureFlags": { ... },
  "branding": { ... }
}
```

- Globaler Zugriff soll über Riverpod Provider (Application Layer) eine Automatik herstellen:
```dart
	final hostModelProvider : StateProvider<HostModel?>((ref) => null);
```
- Sobald collectionld gesetzt ist —> HostModel laden —> Provider aktualisieren —> App passt sich dynamisch an.
- Dann greift die UI überall z. B. so:
```dart
	final host = ref.watch(hostModelProvider);
	Text(host?.hostName ?? 'PodcastApp' );
```
- Theme-Steuerung der Theme-Daten wie etwa Farben können zentral in einem Theme-Provider aus dem HostModel abgeleitet werden:
```dart
	ThemeData getCustomTheme(HostModel host) {  
		return ThemeData(    
			primaryColor: Color(_parseHex(host.primaryColorHex)),    
			...  
		);
	}
```

- Lokale Speicherung mit Hive als -> Hive Box hostInfoBox:
- HostModel + PodcastCollection zusammen unter "collectionId" cachen und z.B. so laden:
```dart
	final hostModel = await Hive.box('hostInfoBox').get(collectionId.toString());
```
- Eine Verbindung zur PodcastCollection:
```
Da Podcast.collectionId identisch ist mit HostModel.collectionId , 
  können beide logisch gekoppelt werden.
Variante:
- Entweder als zwei getrennte Hive-Boxen ( hosts , collections )
- Oder als ein kombiniertes Objekt ApplnstanceData mit:
dart
	class AppInstanceData {  
		final HostModel host;  
		final PodcastCollection podcasts;
	}
```

- Mit einem hostModelProvider können für eine Automatische UI-Steuerung alle UI-Entscheidungen abgeleitet werden:

|UI-Element 		| Steuerung													|
|-------------------|-----------------------------------------------------------|
| Farben, Logo 		| über host.primaryColorHex, host.logoUrl					|
| AppBar-Titel 		| über host.hostName										|
| Startseite 		| über host.customStartTab									|
| Kontaktseite 		| über host.contactEmail, host.websiteUrl					|
| Impressum-Link 	| über host.impressumUrl									|
| Sichtbarkeit Tabs | über host.showPortfolioTab, host.enableContactForm		|
| Sprachwahl 		| über host.defaultLanguageCode								|

- Umschalt-Mechanismus getreu nach:
```dart
void switchToCollection(AppConfig config) {
  GetIt.I.reset(dispose: true);
  GetIt.I.registerSingleton<AppConfig>(config);
  GetIt.I.registerSingleton<HostRepository>(HostRepoImpl(config));
  GetIt.I.registerSingleton<EpisodeRepository>(EpisodeRepoImpl(config));
  // Weitere Services registrieren ...
}
```

- UI refresh durch Rebuild / Notifier
- schemenhafter ungefertiger App-Flow von QR bis UI-Anpassung als Diagramm:
```
[QR-Code gescannt / App gestartet]        
				|        
				v
[collectionId erkannt (z.B. 12345)]        
				|        
				v
[HostModel & PodcastCollection laden]        
				|        
				+---> [HostModel aus Hive?] ---- Ja ---> [Benutzen]        
				|                                           
				|                                      
				No                                        
				|                                         
				+---> [HostModel von API laden]                           
				|                    
				v         
	[JSON parsed → HostModel]                    
				|                    
				v         
	[Speichern in Hive & Provider]                    
				|                    
				v    
[UI wird durch Provider gesteuert]                    
				|        
	+---------------------------+        
	| Farben aus host.primaryColorHex        
	| AppBar-Titel = host.hostName        
	| StartTab = host.customStartTab        
	| Sichtbare Tabs = Flags im HostModel        
	| Kontaktseite = host.contactEmail        
	+---------------------------+
```

- Admins können live Hosts wechseln (im MVP dieser App nur im Environment-Modus für Devs)

---

## 📊 Deployment & Plattformen
- Flutter (iOS / Android)
- Initiale Konfiguration baked in: default `collectionId`
- OTA-Konfig-Updates optional durch RemoteConfig / Supabase API

---

## ⚖️ Zusammenfassung
Diese App stellt ein flexibel konfigurierbares Podcast-System dar, 
das durch eine saubere Trennung von Datenquellen, Service-Strukturen 
und UI-Logik individuell je Host anpassbar ist. Die Architektur ist 
skalierbar und bereitet den Weg für eine spätere Multi-Host-Fähigkeit 
ohne Re-Deployment.

Für die entwicklung genutzt werden ChangeNotifier & Provider für sauberes State-Management.
UI (Widgets) sind von der Geschäftslogik (Services, Repositories) getrennt.
Es wird auf `abstract` und `implements` gesetzt, um Abhängigkeiten flexibel zu halten.
Enge Kopplung zwischen Klassen werden durch Dependency Injection (Provider, GetIt) vermieden.
Factory-Methoden oder Dependency Injection werden für testbaren Code eingesetzt.


---

## SnackBar Konfiguration als `snackbar_events.yaml`
```
snackbar_events:
  # Audio
  audio_resaved:
    duration: short
    icon: replay
    message_key: audio.resaved
    type: success
  offline_audio_expired:
    duration: long
    icon: warning
    message_key: audio.expired
    type: warning
  offline_download_success:
    duration: short
    icon: download_done
    message_key: audio.download_success
    type: success

  # ⚠️ Admin / Collection
  collectionId_invalid:
    duration: long
    icon: error_outline
    message_key: collection.invalid
    type: error
  collection_updated:
    duration: short
    icon: library_add
    message_key: collection.updated
    type: success
  welcome_back:
    duration: short
    icon: home
    message_key: collection.welcome_back
    type: info

  # 🧪 Demo / Dev-Modus
  demo_mode_active:
    duration: long
    icon: warning
    message_key: environment.demo_warning
    type: warning

  # 💾 Favoriten & Cache
  favorite_expired_keep_flag:
    duration: short
    icon: info
    message_key: favorites.expired_keep_flag
    type: info
  favorite_removed:
    duration: short
    icon: favorite_border
    message_key: favorites.removed
    type: info
  favorite_retained:
    duration: short
    icon: favorite
    message_key: favorites.retained
    type: info
  favorite_saved:
    duration: short
    icon: favorite
    message_key: favorites.saved
    type: success
  favorite_set_permanent:
    duration: short
    icon: star
    message_key: favorites.permanent
    type: success
  favorite_valid_until:
    duration: short
    icon: schedule
    message_key: favorites.valid_until
    type: info
  favorites_updated:
    duration: short
    icon: favorite
    message_key: favorites.updated
    type: success
  file_deleted_expired:
    duration: short
    icon: delete_forever
    message_key: storage.file_deleted
    type: info
  cache_cleared:
    duration: short
    icon: delete_sweep
    message_key: settings.cache_cleared
    type: info
  storage_optimized:
    duration: short
    icon: cleaning_services
    message_key: storage.optimized
    type: info
  unfavorited_deleted_auto:
    duration: short
    icon: delete
    message_key: storage.unfavorited_deleted
    type: info

  # 🧑‍💼 Host / Einstellungen
  host_data_fetch_failed:
    duration: long
    icon: error
    message_key: host.fetch_failed
    type: error
  host_info_saved:
    duration: short
    icon: update
    message_key: host.info_saved
    type: success
  host_profile_updated:
    duration: short
    icon: person
    message_key: host.profile_updated
    type: success
  manual_update_triggered:
    duration: short
    icon: refresh
    message_key: host.manual_update
    type: info
  update_failed_offline:
    duration: short
    icon: wifi_off
    message_key: host.update_failed_offline
    type: warning
  settings_saved:
    duration: short
    icon: check_circle
    message_key: settings.saved
    type: success

  # 🧾 Eingabe / UI
  input_invalid:
    duration: short
    icon: error
    message_key: input.invalid
    type: error

  # ✅ Login / Auth
  login_failed:
    duration: long
    icon: error
    message_key: login.failed
    type: error
  login_success:
    duration: short
    icon: check_circle
    message_key: login.success
    type: success

  # 🌐 Netzwerk / Verbindung
  network_error:
    duration: long
    icon: cloud_off
    message_key: error.network_general
    type: error
  network_offline:
    duration: long
    icon: wifi_off
    message_key: network.no_connection
    type: error
  offline_mode_enabled:
    duration: short
    icon: cloud_off
    message_key: network.offline_mode
    type: info

  # 🚀 Onboarding
  onboarding_done:
    duration: long
    icon: celebration
    message_key: onboarding.done
    type: success
  onboarding_restarted:
    duration: short
    icon: restart_alt
    message_key: onboarding.restarted
    type: info
```

## Beispiel snackbar_config.yaml (Mandantenfähig)
```
default:
  login_success:
    type: success
    message: "Welcome back, {username}!"
    icon: check_circle
    duration: short

  error_network:
    type: error
    message: "Network error occurred. Please check your connection."
    icon: wifi_off
    duration: long

mandanten:
  collection_anna:
    login_success:
      message: "Hallo {username}, schön dich zu sehen!"
  collection_julian:
    login_success:
      message: "Willkommen zurück, {username}!"

```

## Internationale texte (intl_de.arb Beispiel)
```
{
  "collection.invalid": "Ungültige collectionId – bitte prüfen.",
  "network.no_connection": "Keine Verbindung verfügbar – bitte später erneut versuchen.",
  "network.offline_mode": "Offline-Modus aktiviert.",
  "audio.download_success": "Folge jetzt offline verfügbar – für 7 Tage",
  "favorites.saved": "Favorit gespeichert – Audio bleibt für 6 Monate erhalten",
  "favorites.removed": "Favorit entfernt – Folge wird nach 7 Tagen gelöscht",
  "storage.file_deleted": "Nicht mehr offline verfügbar – Speicherplatz freigegeben",
  "favorites.permanent": "Du hast einen Favorit für dich entdeckt – dieser wird dauerhaft übernommen.",
  "favorites.expired_keep_flag": "Diese Folge war ein Favorit – Das Audio wird gelöscht, aber deine Auswahl als Favorit bleibt erhalten.",
  "favorites.valid_until": "Favorit gespeichert – Audio bis [Datum] verfügbar.",
  "audio.expired": "Audio-Datei wurde entfernt – du kannst diese jedoch erneut laden.",
  "audio.resaved": "Audio erneut gespeichert – verfügbar für 6 Monate.",
  "storage.optimized": "Dein Speicher wurde optimiert – alles sauber.",
  "storage.unfavorited_deleted": "Nicht favorisierte Folge wurde automatisch gelöscht, um Speicher zu sparen.",
  "favorites.retained": "Favorit bleibt erhalten – nur die Offline-Version wurde entfernt.",
  "settings.saved": "Deine Einstellungen wurden übernommen.",
  "input.invalid": "Bitte überprüfe deine Angaben.",
  "onboarding.done": "Willkommen – deine App ist einsatzbereit!",
  "onboarding.restarted": "Du kannst das Onboarding jederzeit in den Einstellungen wiederholen.",
  "host.info_saved": "Neues in der Host-Ansicht verfügbar.",
  "host.profile_updated": "Host-Profil wurde aktualisiert.",
  "host.update_failed_offline": "Keine neuen Host-Daten – bist du online?",
  "collection.updated": "Sammlung aktualisiert – neue Episode(n) verfügbar.",
  "collection.welcome_back": "Willkommen zurück! Deine Sammlung ist geladen.",
  "host.manual_update": "Host-Daten wurden aktualisiert.",
  "host.fetch_failed": "Konnte Host-Daten nicht laden – bitte später erneut versuchen.",
  "environment.demo_warning": "Demo-Modus: Änderungen werden nicht gespeichert.",
  "login.success": "Erfolgreich eingeloggt.",
  "login.failed": "Login fehlgeschlagen. Bitte versuche es erneut.",
  "error.network_general": "Netzwerkfehler aufgetreten. Bitte Verbindung prüfen.",
  "favorites.updated": "Favoriten wurden aktualisiert.",
  "settings.cache_cleared": "Cache erfolgreich gelöscht."
}

```

## `duration` Mapping
```
enum SnackbarDuration { short, long }

final Map<SnackbarDuration, Duration> durationMap = {
  SnackbarDuration.short: Duration(seconds: 2),
  SnackbarDuration.long: Duration(seconds: 5),
};
```

## Konzeptlogik `snackbar_event_factory.dart`
```
class SnackbarEventFactory {
  final Map<String, dynamic> _config; // geladen z.B. aus YAML oder JSON

  SnackbarEventFactory(this._config);

  SnackbarEvent create(String eventKey, {Map<String, String>? args}) {
    final event = _config[eventKey];
    if (event == null) throw ArgumentError('Unbekannter Snackbar-Key: $eventKey');

    final messageTemplate = event['message'] as String;
    final message = _interpolate(messageTemplate, args ?? {});
    
    return SnackbarEvent(
      type: _parseType(event['type']),
      message: message,
      icon: event['icon'],
      duration: _parseDuration(event['duration']),
    );
  }

  String _interpolate(String template, Map<String, String> args) {
    return args.entries.fold(template, (res, entry) =>
      res.replaceAll('{${entry.key}}', entry.value));
  }

  SnackbarType _parseType(String? type) {
    switch (type) {
      case 'error': return SnackbarType.error;
      case 'success': return SnackbarType.success;
      case 'info': return SnackbarType.info;
      case 'warning': return SnackbarType.warning;
      default: return SnackbarType.info;
    }
  }

  Duration _parseDuration(String? duration) {
    switch (duration) {
      case 'short': return Duration(seconds: 2);
      case 'long': return Duration(seconds: 5);
      default: return Duration(seconds: 3);
    }
  }
}

```

## Beispiel-Aufrufe (in z.B. UseCase oder BloC)
```
final factory = SnackbarEventFactory(configForCurrentTenant);
final event = factory.create(
  'login_success',
  args: {'username': 'Anna'}
);

snackbarManager.dispatch(event);

```


---

## Auszug ScreenFlow
```
START
│
├── SplashScreen
│   ├── Hintergrund: primaryColor
│   ├── Zentrales Logo (Platzhalter, 200x200)
│   └── Animation: "Wird geladen . . ."
│
├── HomePage
│   ├── Wieder Logo zentriert
│   ├── Dauer: 2 Sekunden
│   └── Animation verschwindet
│
├── OnboardingPage (PageView)
│   ├── Slide 1: "Onboarding-Tipp 1"
│   │    └── Button: "Weiter"
│   ├── Slide 2: "Onboarding-Tipp 2"
│   │    └── Button: "Weiter"
│   └── Slide 3: "Onboarding-Tipp 3"
│        └── Button: "Los geht's!" → LandingPage
│
├── LandingPage
│   ├── AppBar: "Willkommen bei collectionName"
│   ├── DarkMode-Toggle (rechts)
│   ├── Artwork (50 % Höhe) – `artworkUrl600`
│   ├── Button: "Start" → TabView
│   ├── Text: "eine"
│   ├── Text: "Universell Podcasten -App"
│   └── Button: "Einstellungen" → SettingsView 
│
├── SettingsView
│       └── [Noch nicht beschrieben]
│
├── TabView (BottomNavigation)
│   ├── Tab 1: "CastList"
│   │   ├── AppBar
│   │   │   ├── Titel: collectionName
│   │   │   ├── Switch (Admin-Modus)
│   │   │   │   └── Wenn aktiv: Textfeld zur Eingabe collectionId
│   │   │   └── Dropdown (3 Punkte)
│   │   ├── Banner-Bereich (~1/3 Höhe)
│   │   │   ├── artworkUrl600
│   │   │   └── Oben links: Banner mit GENRE (primaryGenreName)
│   │   └── Episodenliste
│   │       └── EpisodeItemTile[]
│   │           ├── Cover klein (links)
│   │           ├── Titel (trackName)
│   │           ├── Beschreibung (gekürzt)
│   │           ├── Dauer (formatiert)
│   │           └── Menü (⋮) mit Optionen
│   │               └── Tap → EpisodeDetailPage
│   │
│   └── Tab 2: "HostView"
│   	├── AppBar
│       └── [Noch nicht beschrieben]
│
└── EpisodeDetailPage
    ├── AppBar
    │   ├── Zurück-Pfeil
    │   └── Titel: trackName
    ├── Content (ScrollView)
    │   ├── "Erschienen am" + Datum (lokalisiert)
    │   ├── Dauer (Min + Sek)
    │   └── Beschreibung (vollständig)
    └── Bottom-Bar (Button-Zeile)
        ├── Favorit (Stern)
        ├── Play → BottomPlayer (≤ 1/3 Höhe)
        └── Download (⬇️)

END

```

---

# ✅ Test-Szenarien

## 🧩 Allgemein & Architektur

| ID   | Beschreibung                                                           | Erwartetes Ergebnis                                              |
|------|------------------------------------------------------------------------|------------------------------------------------------------------|
| TA1  | App startet ohne Netzwerkverbindung                                    | Platzhalter-Inhalte überall sichtbar                             |
| TA2  | App startet mit funktionierender collectionId                          | Inhalte zum richtigen Host geladen                               |
| TA3  | Ungültige collectionId (manuell eingegeben)                            | Snackbar mit Fehlermeldung erscheint                             |
| TA4  | collectionId dynamisch gewechselt (Admin-Modus)                        | Alle Inhalte und Branding ändern sich vollständig                |
| TA5  | App im Hintergrund, kehrt zurück                                       | Inhalte bleiben erhalten, kein Refresh nötig                     |
| TA6  | App wird neu gestartet                                                 | Letzte collectionId bleibt erhalten                              |
| TA7  | FeatureFlags deaktivieren bestimmte Tabs                               | Tabs erscheinen/verhalten sich entsprechend                      |
| TA8  | Platzhalterdaten korrekt sichtbar bei leerem lokalen Speicher          | Fallbacks greifen sauber                                         |

---

## 🎙 Feature 1: Podcast-Funktionalität

| ID   | Beschreibung                                                           | Erwartetes Ergebnis                                              |
|------|------------------------------------------------------------------------|------------------------------------------------------------------|
| TP1  | Episodenliste erfolgreich aus API geladen                              | AsyncList mit Episodenzellen erscheint                           |
| TP2  | Audio einer Episode wird gestartet                                     | Mini-Player erscheint, Audio läuft                               |
| TP3  | Audio wird pausiert                                                    | Mini-Player pausiert, Audio stoppt                               |
| TP4  | Geschwindigkeit wird verändert                                         | Audio spielt mit gewählter Geschwindigkeit                       |
| TP5  | AirPlay wird ausgewählt                                                | Audio wird korrekt gespiegelt                                   |
| TP6  | App wird während Audio geschlossen                                     | Audio pausiert oder spielt weiter (je nach Flag)                 |
| TP7  | Audio wird erneut gestartet                                            | Audio-Player setzt korrekt ein                                  |
| TP8  | Audio-Player zeigt Snackbar bei Fehlern                                | Transparente Rückmeldung für Nutzer:in                           |
| TP9  | Episode wird favorisiert                                               | Favoriten-State ändert sich, wird gespeichert                    |
| TP10 | Favoritenliste geöffnet                                                | Nur favorisierte Episoden sichtbar                              |
| TP11 | Keine Episoden abrufbar (API down)                                     | Snackbar zeigt Fehler + Platzhalterliste                        |

---

## 🧑💼 Feature 2: Host-Info / Portfolio

| ID   | Beschreibung                                                           | Erwartetes Ergebnis                                              |
|------|------------------------------------------------------------------------|------------------------------------------------------------------|
| TH1  | HostInfo-Tab geöffnet                                                  | Branding + Infos korrekt angezeigt                               |
| TH2  | Lokale about.json geladen                                              | Inhalte erscheinen dynamisch                                     |
| TH3  | FeatureFlag `showPortfolioTab` = false                                 | Tab nicht sichtbar                                               |
| TH4  | Angebote (dynamisch) korrekt geladen                                   | Cards erscheinen eingebettet                                     |
| TH5  | Kontaktinfos korrekt dargestellt                                       | E-Mail, Website-Links funktionieren                              |
| TH6  | HostInfo-ScrollView funktioniert                                       | Keine Layout-Bugs, flüssig                                       |
| TH7  | HostInfo leer (JSON fehlt)                                             | Platzhalter und Snackbar-Hinweis erscheinen                      |

---

## 📬 Feature 3: Kontaktformular

| ID   | Beschreibung                                                           | Erwartetes Ergebnis                                              |
|------|------------------------------------------------------------------------|------------------------------------------------------------------|
| TC1  | Kontaktformular geöffnet                                               | Eingabefeld + Button sichtbar                                    |
| TC2  | E-Mail-Link wird erstellt                                              | E-Mail-App öffnet sich mit vorgefüllter Mail                    |
| TC3  | E-Mail-Client nicht installiert                                        | Snackbar-Hinweis erscheint                                       |
| TC4  | FeatureFlag `enableContactForm` = false                                | Kontakt-Option nicht sichtbar                                    |
| TC5  | Kontaktversuch offline                                                 | Snackbar „Offline – später erneut versuchen“ erscheint           |

---

## 🛠 Admin-Modus

| ID   | Beschreibung                                                           | Erwartetes Ergebnis                                              |
|------|------------------------------------------------------------------------|------------------------------------------------------------------|
| TM1  | Admin-Modus per Switch aktiviert                                       | TextField für collectionId erscheint                             |
| TM2  | Neue collectionId eingegeben & validiert                               | App-Inhalte ändern sich live                                     |
| TM3  | Ungültige collectionId eingegeben                                      | Fehler-Snackbar erscheint                                        |
| TM4  | Admin-Modus deaktiviert                                                | collectionId nicht mehr änderbar                                 |
| TM5  | Mehrfaches Wechseln in Folge                                           | Kein Crash, alle Inhalte stabil ersetzt                          |
| TM6  | Admin-Modus bei Offline-Status                                         | Lokale Sammlung bleibt erhalten                                  |

---

## 🔧 Datenquellen & Speicher

| ID   | Beschreibung                                                           | Erwartetes Ergebnis                                              |
|------|------------------------------------------------------------------------|------------------------------------------------------------------|
| TD1  | iTunes-API gibt leere Liste zurück                                     | Snackbar + Platzhalter                                           |
| TD2  | RSS-Feed nicht erreichbar                                              | Lokale Fallback-Werte greifen                                    |
| TD3  | Hive-Speicher mit Episoden vorhanden                                   | Inhalte sofort sichtbar ohne Netzwerk                            |
| TD4  | Favoriten in SharedPreferences                                         | Favoriten nach Neustart erhalten                                 |
| TD5  | `about.json` beschädigt                                                | Fehlerbehandlung + Snackbar                                      |
| TD6  | collectionId dynamisch lädt RSS                                        | Inhalte aus RSS korrekt gelesen                                  |
| TD7  | Environment-Switch erfolgt korrekt                                     | GetIt neu registriert alle Services                              |

---

## 📱 UI/UX & Usability

| ID   | Beschreibung                                                           | Erwartetes Ergebnis                                              |
|------|------------------------------------------------------------------------|------------------------------------------------------------------|
| TU1  | Splashscreen mit Animation                                             | Geht nach Zeit in LandingPage über                               |
| TU2  | Onboarding korrekt durchlaufen                                         | „Los geht’s“ führt zur PodcastPage                               |
| TU3  | Navigation zwischen Tabs                                               | Kein Bug, BottomNavigationBar aktiv                              |
| TU4  | Mini-Player minimierbar und tappbar                                    | Expandiert zur Vollansicht                                       |
| TU5  | Snackbar-System                                                        | Zeigt alle Systemzustände und Fehlermeldungen sauber             |
| TU6  | Responsive Layout (Tablet vs. Phone)                                   | UI passt sich an                                                 |
| TU7  | Dark Mode                                                              | Theme wird korrekt übernommen                                    |

---

## 🚧 Fehlerbehandlung / Edge Cases

| ID   | Beschreibung                                                           | Erwartetes Ergebnis                                              |
|------|------------------------------------------------------------------------|------------------------------------------------------------------|
| TE1  | App ohne Berechtigungen gestartet                                      | Snackbar-Hinweis (z.B. Storage)                                 |
| TE2  | Kein Internet & keine gespeicherten Daten                              | Nur Platzhalter sichtbar, Hinweis erscheint                      |
| TE3  | Falsche JSON-Struktur aus API                                          | Catch + Snackbar „Fehlerhafte Daten“                             |
| TE4  | Update der App – alte collectionId bleibt                              | Kein Reset, Daten werden aktualisiert                            |

---

## Update für die Weiterentwicklung (31.05.2025)

**Hinweis:**
- Die Produktvision, Muss-Kriterien und Projektstruktur aus diesem PRD sind verbindliche Leitlinie für alle neuen Features und Weiterentwicklungen.
- Vor jeder Erweiterung: Abgleich mit diesem PRD und den Architektur-/Struktur-Dokumenten.
- Änderungen an Muss-Kriterien, Zielgruppen oder Struktur immer dokumentieren und in die Doku-Matrix eintragen.
- Die Doku-Matrix (`.instructions/doku_matrix.md`) und dieses PRD stehen im Mittelpunkt der Weiterentwicklung.

---

