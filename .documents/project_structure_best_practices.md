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
