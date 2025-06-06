# Projektstruktur & Prinzipien (Flutter)

## Empfohlene Struktur
```
lib/
  domain/         # Modelle, Enums, UseCases
  data/           # Repositories, API-Clients
  application/    # StateNotifier, Provider, Events
  presentation/   # Pages, Widgets, UI-Logik
  config/         # Themes, DI, Routen
  core/           # Logger, Utilities, SharedPrefs
  tenants/        # Mandanten: JSON + Assets
  main.dart
```

## Prinzipien
- Clean Architecture Layer (Domain – Data – Application – Presentation)
- SOLID, Interface-gesteuerte UseCases & Repositories
- Feature-basierte Modularität
- Riverpod oder BLoC für State-Management
- Dependency Injection (`get_it`, `injectable`)
- Trennung von Business-Logik und UI

## Tipps
- Halte die Struktur konsistent und dokumentiert (README in jedem Hauptordner)
- Nutze `.instructions` und `.documents` für Anleitungen und Doku
- Nutze Copilot Chat für Refactoring- und Architekturfragen (`@workspace`)

## Zusammenhang: Models (data) und Entitäten (domain)
- Im data-Layer werden Datenmodelle (DTOs) für externe Quellen (z. B. APIs, Datenbanken) definiert.
- Diese Models werden in Entitäten des domain-Layers überführt, um die Business-Logik unabhängig von Datenquellen zu halten.
- Nach der Verarbeitung können Entitäten wieder in Models/DTOs zurücktransformiert werden (z. B. für Speicherung oder Übertragung).
- Vorteil: Klare Trennung, bessere Testbarkeit und Unabhängigkeit der Kernlogik.

**Beispiel:**
- `data/user_model.dart` (DTO für API)
- `domain/user_entity.dart` (Entität für Business-Logik)
- Mapping zwischen Model und Entität erfolgt meist in Repository-Implementierungen.

## Erweiterte Struktur für große Projekte (Beispiel)

Für größere, skalierbare Flutter-Projekte empfiehlt sich eine feinere Unterteilung der Layer und Ordner. Beispielstruktur:

```
lib/
  app.dart
  main.dart
  application/
    controllers/      # State- und Logik-Controller
    listeners/        # Event-Listener (z. B. Snackbar)
    providers/        # State- und Service-Provider
  config/             # Routen, Theme, DI, Umgebungen
  core/
    extensions/       # Erweiterungen für Models, Collections etc.
    logging/          # Logging-Konfiguration
    messaging/        # Messaging, Snackbar-Events
    placeholders/     # Platzhalter-Content & Loader
    services/         # Technische Services (Audio, Caching, etc.)
    storage/          # SharedPrefs, Storage-Services
    utils/            # Utilities, Parser, Validatoren
  data/
    api/              # API-Clients, Endpunkte
    repositories/     # Repositories (API, Cache, Mock)
  domain/
    common/           # Gemeinsame Typen, Responses
    enums/            # Enums für States, Typen
    models/           # Entitäten, Value Objects (mit Freezed, G.dart)
    service/          # Domänenspezifische Services
    usecases/         # UseCases
  l10n/               # Lokalisierung
  presentation/
    pages/            # UI-Seiten
    widgets/          # UI-Komponenten
      async/          # Asynchrone UI-Helper
  tenants/            # Mandanten: JSON, Assets, Themes
```

**Hinweise:**
- Diese Struktur eignet sich besonders für Multi-Branding, White-Label-Apps und große Teams.
- Die Trennung von Models (data) und Entitäten (domain) sowie das Mapping erfolgt wie oben beschrieben.
- Siehe auch die Best Practices und Prinzipien in diesem Dokument.
- Für Details zur Audio-Architektur (Trennung AudioHandler/BLoC/Backend, Testbarkeit, Provider) siehe [../docs/audio_architektur_2025.md](../docs/audio_architektur_2025.md).
