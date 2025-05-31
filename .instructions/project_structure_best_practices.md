# 📱 storage_hold – Architektur & Projektstrategie

> Dieses Dokument beschreibt die projektbezogene Architektur, Designentscheidungen und Entwicklungsrichtlinien.  
> Es basiert auf Clean Architecture, Riverpod, get_it und Hive. Viele Konzepte stammen aus [Reso Coder](https://resocoder.com/).

---

<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: architecture_clean_architecture.md -->

## 📦 Projektstruktur

lib/
├── domain/ → Modelle, Enums, UseCases
├── data/ → Repositories, API-Clients
├── application/ → StateNotifier, Provider, Events
├── presentation/ → Pages, Widgets, UI-Logik
├── config/ → Themes, DI, Routen
├── core/ → Logger, Utilities, SharedPrefs
├── tenants/ → Mandanten: JSON + Assets
└── main.dart


---

## 🧱 Architekturprinzipien

- Clean Architecture Layer (Domain – Data – Application – Presentation)
- SOLID durch Interface-gesteuerte UseCases & Repositories
- Feature-basierte Modularität
- Hive als persistente Datenbank für Offlinefähigkeit
- Riverpod als reaktives State-Management
- `get_it` + `injectable` für Dependency Injection
- Dynamische Themes & Features (Audio, Flags, Mandanten) als Services

---

## 🧩 Wichtige Services (intern)

| Service                | Aufgabe                                        |
|------------------------|-----------------------------------------------|
| `AudioPlayerService`   | Wiedergabesteuerung (zustandsbehaftet, BLoC-artig) |
| `ThemeController`      | Dynamisches Laden von Themes pro Mandant      |
| `FeatureFlagService`   | Aktivierung/Deaktivierung von Features        |
| `HiveCacheService`     | Speichert Favoriten, Downloads, Metadaten     |
| `TenantLoaderService`  | Lädt assets/configs je nach Mandanten-ID      |

---

## ✅ Projektbezogene Best Practices

- Business-Logik nie in Widgets: Nur über `UseCases` und Services.
- State-Management via Riverpod: Für Formulare, Routen, globale Zustände.
- Wiederverwendbare UI-Komponenten im Verzeichnis `presentation/widgets`.
- Testfokus auf UseCases & Services: mit `flutter_test` und `mockito`.
- Mandantenstruktur strikt trennen: `tenants/<host_id>/assets/`, JSON als Quelle.
- Routen & Themes dynamisch über Provider bereitstellen.

---

## 🧪 Testing-Strategie

- Unit Tests: Für UseCases, Services (`flutter_test`)
- Widget Tests: Für UI-Komponenten im `presentation`-Layer
- Integrationstests (optional): via `patrol` oder `integration_test`
- Beispiel-Datei: `test/domain/usecases/load_collection_test.dart`

---

## 🚀 Entwicklungs-Setup

```
git clone https://github.com/sergioSerafino/storage_hold.git
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## 🔮 Geplante Erweiterungen
- Authentifizierungs-Flow mit Firebase o. ä.
- AirPlay & ChromeCast-Unterstützung
- Mandanten-Runtime-Umschaltung ohne App-Restart
- GitHub Actions CI/CD-Setup
- Remote Feature Activation mit Remote Config

## 🔗 Architekturelle Grundlage
- Reso Coder Clean Architecture Guide in `achitecture.md`
- Riverpod 2.0 für modernes State-Management
- get_it + injectable zur zentralen und testbaren DI
- Hive für performante & typisierte lokale Datenhaltung

---

## Architektur- und Projektstruktur-Update (Stand: 31.05.2025)

**Hinweis für die Weiterentwicklung:**
- Die Projektstruktur und Layer-Trennung sind verbindlich und müssen bei jeder Erweiterung beachtet werden.
- Neue Features, UseCases, Provider und Services immer nach den Prinzipien aus `.instructions/architecture_clean_architecture.md` und diesem Dokument anlegen.
- Änderungen an der Struktur oder Architektur immer sofort dokumentieren und in die Doku-Matrix eintragen.
- Die Doku-Matrix (`.instructions/doku_matrix.md`) ist der zentrale Einstiegspunkt für alle HowTos, Architektur- und Entscheidungsdokumente.

**Empfohlene Vorgehensweise:**
1. Vor jeder Erweiterung: Abgleich mit diesem Dokument und der Architektur-Doku.
2. Änderungen und neue Patterns dokumentieren und in die Matrix aufnehmen.
3. Layer-Struktur und Modularität niemals aufweichen – Business-Logik bleibt in UseCases und Services.

---

