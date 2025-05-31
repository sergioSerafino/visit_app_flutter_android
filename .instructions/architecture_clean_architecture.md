# 📚 instructions.md

> Sammlung bewährter Flutter-Prinzipien & Architekturstrategien  
> Basierend auf den Tutorial-Serien von [Reso Coder](https://resocoder.com/)

---

<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: project_structure_best_practices.md, howto_feature_flags.md -->

## 🏗 Clean Architecture & Test-Driven Development (TDD)

### 🔧 Struktur & Prinzipien:
- Trennung in: `domain`, `data`, `presentation`
- `domain`: Entitäten, Use Cases, abstrakte Repositories
- `data`: Datenquellen (remote/local), konkrete Repositories
- `presentation`: UI + State Management (z. B. BLoC)

### ✅ Best Practices:
- Arbeite mit reinen Dart-Klassen (keine Flutter-Widgets in Domain/Data)
- Schreibe zuerst Tests (TDD: Red → Green → Refactor)
- Verwende `dartz` für funktionale Fehlerbehandlung (`Either`, `Option`)
  - Alternativ: Eigene `sealed` Result-Typen (Dart 3) oder Pakete wie `result_pod` nutzen
  - Dart 3 sealed classes und Pattern Matching machen eigene Fehler-/Erfolgstypen komfortabel

---

## 🔥 Firebase & Domain-Driven Design (DDD)

### 🔧 Inhalte:
- Authentifizierung mit Firebase & ValueObjects
- Modellierung des Zustands (Sign-In-Formular)
- Architektur mit Fassade & Fehlerbehandlung

### ✅ Best Practices:
- `ValueObject` für Validierung (z. B. `EmailAddress`, `Password`)
- Verwende eine Fassade, um Firebase von der Domain zu isolieren
- Fehler über `Either<AuthFailure, Unit>` zurückgeben

---

## 🧱 BLoC (Business Logic Component) Pattern

### 🔧 Themen:
- Einführung in `flutter_bloc`
- Zustandspersistenz mit `hydrated_bloc`
- Dynamisches Theming & Routing
- Manuelles BLoC-Bauen von Grund auf

### ✅ Best Practices:
- Trenne `Event` → `State` sauber
- Verwende `BlocBuilder` nur wo nötig
- Vermeide Business-Logik in der UI

---

## 🧪 Testing in Flutter

### 🔧 Inhalte:
- Unit-, Widget- und Integrationstests
- Test-Setup mit `flutter_test`, `mocktail`, `bloc_test`
- Testfälle für Use Cases, Repositories, UI

### ✅ Best Practices:
- Teste Use Cases isoliert
- Widget-Tests mit `pumpWidget` & `find`-Matcher
- Integrationstests mit `flutter_driver` oder `integration_test`

---

## 🎨 UI & Animation

### 🔧 Themen:
- Responsive Design mit `LayoutBuilder` und `MediaQuery`
- SVG-Animationen mit Rive
- Navigation mit verschachteltem Routing
- ShowCaseView zur Nutzerführung
- Gestaffelte Animationen (`Staggered Animations`)
- Lokale Benachrichtigungen mit `awesome_notifications`

### ✅ Best Practices:
- Verwende MediaQuery oder `flutter_responsive_framework`
- Animationen per `AnimationController` oder Packages
- Nutze ShowcaseView für Onboarding

---

## 🧠 Funktionale Programmierung in Dart & Flutter

### 🔧 Inhalte:
- Verwendung von `Option`, `Either`, `Failure` (z. B. aus dartz)
- Alternativ: Eigene `sealed` Result-Typen (Dart 3) oder Pakete wie `result_pod`
- Eingabevalidierung mit `ValueObject`
- `fold`, `map`, `flatMap` zur Datenverarbeitung

### ✅ Best Practices:
- Keine `null`, verwende stattdessen `Option` oder eigene Option-Typen
- Frühzeitige Validierung durch ValueObjects
- Fehlerhandling über `Either` oder eigene Result-Typen
- Dart 3 sealed classes ermöglichen idiomatische Fehlerbehandlung ohne externe Pakete

---

## 🧪 UI-Testing mit Patrol

### 🔧 Vorgehen:
- Nutzung von `patrol`-Paket für automatisierte Tests
- Simulation nativer Dialoge, Benachrichtigungen & App-Flows

```dart
patrolTest('Login test', ($) async {
  await $.pumpWidgetAndSettle(MyApp());
  await $(#loginButton).tap();
});
```

### ✅ Best Practices:
- Tags & Selektoren systematisch vergeben
- Teststruktur: Arrange – Act – Assert
- CI/CD-Integration für kontinuierliche Qualität

---

## 🔁 Riverpod 2.0

### 🔧 Inhalte:
- Nutzung von `StateProvider`, `FutureProvider`, `Notifier`
- Trennung von UI und Logik
- Reaktive & skalierbare Architektur

### ✅ Best Practices:
- Business-Logik nicht in Widgets
- Provider außerhalb des Widget-Trees deklarieren
- Nutze `.ref` für dynamisches Listening

---

## 🧱 Modularisierung großer Flutter-Projekte

### 🔧 Vorgehen:
- Trennung nach `features`, `core`, `shared`, `infrastructure`
- Verwende Dart Packages pro Modul (z. B. `feature_auth`, `core_widgets`)
- Eindeutige Imports, z. B. `import 'package:core/core.dart';`

### ✅ Best Practices:
- Abhängigkeiten nur in eine Richtung
- Klare Kommunikation über Interfaces
- DI über `get_it` oder `injectable` einsetzen

---

## 📦 App-Architektur mit `get_it` & `injectable`

### 🔧 Vorgehen:
1. Pakete:
   ```yaml
   get_it:
   injectable:
   injectable_generator:
   build_runner:
   ```

2. Setup:
   ```dart
   final getIt = GetIt.instance;

   @InjectableInit()
   Future<void> configureInjection(String env) async {
     await $initGetIt(getIt, environment: env);
   }
   ```

3. Annotationen:
   ```dart
   @injectable
   class AuthService implements IAuthService {}
   ```

4. Code-Generierung:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### ✅ Best Practices:
- Unterschiedliche Implementierungen je nach Umgebung (`test`, `dev`, `prod`)
- Keine manuelle Instanziierung – alles über DI
- Klare Trennung zwischen Interface und Implementierung

---

## How-To: Feature, UseCase, Provider hinzufügen

### 1. Neues Feature anlegen
- Lege einen neuen Ordner im passenden Layer an (z. B. `lib/domain/usecases/` oder `lib/presentation/pages/`).
- Benenne das Feature nach der Funktionalität (z. B. `load_favorites`).

### 2. UseCase erstellen (Domain-Layer)
- Erstelle eine abstrakte Klasse oder Funktion im Domain-Layer, z. B.:
  ```dart
  abstract class LoadFavoritesUseCase {
    Future<List<Favorite>> call();
  }
  ```
- Implementiere die konkrete Logik im Data-Layer.

### 3. Provider anlegen (Application-Layer)
- Lege einen Riverpod-Provider für den UseCase oder das Feature an:
  ```dart
  final loadFavoritesProvider = FutureProvider<List<Favorite>>((ref) {
    final useCase = ref.watch(loadFavoritesUseCaseProvider);
    return useCase();
  });
  ```

### 4. UI anbinden (Presentation-Layer)
- Nutze den Provider in Widgets/Pages:
  ```dart
  final favorites = ref.watch(loadFavoritesProvider);
  ```
- Zeige Lade-, Fehler- und Erfolgszustände an.

### 5. Test schreiben
- Schreibe einen Unit-Test für den UseCase (siehe Teststrategie oben).
- Schreibe ggf. einen Widget-Test für die UI.

### 6. Dokumentation
- Ergänze ggf. die Doku (README, architecture.md, instructions.md) um das neue Feature.

---

Diese How-To-Anleitung gilt als Standard-Vorgehen für neue Features, UseCases und Provider in diesem Projekt. Halte dich an die Layer-Trennung und die Namenskonventionen!

---

## 🗂️ CollectionId-Provider & Caching (Refactoring Schritt 1)

- Die aktive CollectionId wird jetzt über einen eigenen Hive-basierten Service (`CollectionIdStorage`) verwaltet und persistiert.
- Ein StateNotifierProvider (`collectionIdProvider`) kapselt das Laden/Speichern der CollectionId und ermöglicht State-Reset sowie Branding-Update bei CollectionId-Wechsel.
- Grundlage für Registry, Validierung, TTL-Cache und weitere Clean-Architecture-Schritte.
- Siehe `.instructions/collectionid_refactoring_step1.md` für Details und Beispielcode.

---

## 🗂 MergeService, Datenquellen & Caching/Offline (Refactoring Step 2)
- MergeService kapselt und priorisiert iTunes, RSS, Local JSON als Datenquellen
- Persistenter Cache für gemergte PodcastHostCollection-Objekte (Hive, TTL, Fallback)
- Neuer Service: `MergedCollectionCacheService`
- Offline-Strategie: Bei Fehlern/Offline wird letzte gültige Kopie aus Hive verwendet
- Testbarkeit: CacheService kann gemockt werden
- Siehe `.instructions/merge_caching_step2.md` für Details und Beispiele

---

## 📨 Messaging/Snackbar & FeatureFlags (Refactoring Step 3)
- SnackbarManager als StateNotifierProvider, YAML-Konfiguration, Factory für Events
- FeatureFlagsProvider als StateNotifierProvider mit Caching (Hive, TTL, Fallback)
- Teststrategie: Messaging und FeatureFlags werden isoliert getestet
- Siehe `.instructions/messaging_featureflags_step3.md` für Details und Beispiele

---

## 📄 Paging- und Listen-Caching (Refactoring Step 4)
- Hive-Schema: Box 'episodePagesBox', Key 'collectionId_pageIndex', Value: { data: [...], timestamp: ... }
- Service: EpisodePagingCacheService (Hive, TTL, Save/Load/Invalidate pro Seite)
- Provider: episodePagingProvider (StateNotifier, verwaltet Episodenliste, Paging-Status, Fehler)
- Teststrategie: Mock für Netzwerk/Cache, Tests für Cache leer/frisch/abgelaufen, Seiten kombinieren
- Siehe `.instructions/paging_caching_step4.md` für Details und Beispiele

---

## 🗂 CollectionRegistry & CollectionId-Validierung (Refactoring Step 5)
- Service: CollectionRegistryService (Hive, TTL, Remote-Fetch, Fallback)
- Provider: collectionRegistryProvider (AsyncNotifier, lädt Registry, prüft Gültigkeit)
- Integration: CollectionId-Provider prüft bei Änderung, ob neue Id gültig ist (sonst Fehler/Snackbar)
- Siehe `.instructions/collection_registry_step5.md` für Details und Beispiele

---

## 🎨 Offene UI/Design-Optimierungen (Stand: 27.05.2025)
- Apple-gerechter Look (Cupertino, native iOS-Transitions)
- 4/8/12pt-Raster für Abstände, Schriftgrößen, UI-Elemente
- Dynamische Typografie, Theme-Optimierung
- Responsive Design, Accessibility
- Siehe `.instructions/ui_design_todo.md` für Details und ToDos

---

## 📌 Nächste Themenvorschläge (optional)

- CI/CD mit GitHub Actions & Codemagic
- Flutter Web & Desktop mit Clean Architecture
- Feature Flags & Remote Config
- Internationale Flutter-Projekte mit i18n/l10n

---

## 🛠 DEV/ENV-Flag für Fehlerausgabe
- Fehler und Debug-Ausgaben (z. B. ungültige CollectionId) werden nur im Dev- oder ENV-Modus an Entwickler ausgegeben
- Im Produktivmodus bleibt die User-Experience ruhig und vertrauenswürdig
- Nutze `kDebugMode` aus `package:flutter/foundation.dart` für Debug-Ausgaben, Logging und Dev-Only-Features
- Im Release-Mode bleibt die App ruhig und gibt keine internen Fehler/Debug-Infos an den User
- Siehe `.instructions/dev_env_flag.md` für Details und Beispiele

---

## 📜 Teststrategie

### 🔧 Ziele:
- Hohe Testabdeckung für alle Use Cases, Repositories und UI-Komponenten
- Sicherstellung der Datenintegrität und fehlerfreien Benutzerführung

### ✅ Testarten:
- **Unit-Tests:** Isolierte Tests für Funktionen, Klassen und Methoden.
- **Widget-Tests:** Überprüfung von UI-Komponenten und deren Interaktionen.
- **Integrationstests:** Testen des Zusammenspiels mehrerer Komponenten oder Systeme.

### 🔄 Vorgehen:
1. Schreibe Tests parallel zur Entwicklung neuer Features oder Bugfixes.
2. Führe alle Tests regelmäßig in der CI/CD-Pipeline aus.
3. Überprüfe die Testberichte und behebe ggf. aufgetretene Fehler.

### 📚 Test-Tools:
- `flutter_test`: Für Unit- und Widget-Tests.
- `mocktail`: Zum Erstellen von Mock-Objekten in Tests.
- `bloc_test`: Speziell für das Testen von BLoCs entwickelt.
- `integration_test`: Für das Testen der gesamten App-Integration.

### 🔍 Besondere Anforderungen:
- **Serialisierung/Deserialisierung & Integrationspfade:**
  - Für alle Modelle, die persistent gespeichert oder über Netzwerk/Cache transportiert werden (z.B. PodcastCollection, Podcast, PodcastEpisode), muss die Serialisierung/Deserialisierung durch Integrationstests abgesichert werden.
  - Bei jeder Änderung an Datenmodellen, Caching- oder Merge-Logik ist ein Test zu ergänzen, der prüft, dass ein Objekt nach `toJson` → `jsonEncode` → `jsonDecode` → `fromJson` exakt erhalten bleibt.
  - Beispiel: Siehe `itunes_fetch_serialization_integration_test.dart` und Paging-Cache-Integrationstests.
  - Ziel: Datenintegrität und Kompatibilität mit iTunes, RSS, lokalen Caches und allen Merge-Services dauerhaft sicherstellen.

---

## 🧪 Teststrategie: Provider-Mocking & Asynchrone Initialisierung (Mai 2025)

- Viele StateNotifierProvider initialisieren ihren State asynchron (z.B. durch _load() im Konstruktor).
- Im Test muss auf die State-Änderung gewartet werden, bevor geprüft wird (sonst bleibt der State im Initialzustand).
- **Pattern:**
  - ProviderContainer mit passenden Overrides für alle abhängigen Provider (z.B. Storage, Cache, CollectionId).
  - Für StateNotifierProvider, die asynchron initialisieren, im Test mit `container.listen` auf State-Änderung warten oder einen kurzen Delay (`await Future.delayed(...)`) einbauen.
  - Beispiel siehe `.instructions/messaging_featureflags_step3.md`.
- TestCollectionIdStorage implementiert CollectionIdStorage, damit keine echten Hive-Zugriffe erfolgen.
- TestCollectionIdNotifier setzt einen festen State, damit der Test deterministisch bleibt.
- Für komplexere Fälle empfiehlt sich ein `Completer` und ein Listener auf den Provider-State.
- Dieses Pattern ist für alle Provider mit asynchroner Initialisierung oder externen Abhängigkeiten (Hive, Netzwerk) wiederverwendbar.

---

## 📦 GenericPagingCacheService: Nutzung und Erweiterbarkeit
- **Generischer Paging-/Caching-Service:**
  - Der Service `GenericPagingCacheService<T>` ermöglicht Paging- und Caching-Logik für beliebige Listen (z.B. Episoden, Suchergebnisse, Hosts).
  - Für neue Listenarten: Einfach passenden `fromJson`/`toJson`-Mapper angeben und Service/Provider analog zu `EpisodePagingCacheService` aufbauen.
  - Beispiel und Nutzung siehe `episode_paging_cache_service.dart` und zugehörige Provider/Tests.
  - Ziel: Code-Wiederverwendung, Testbarkeit und Clean Architecture für alle Listenarten.

---

## 📌 Feature-Flag-Strategie

- **Feature-Flag-Strategie:**
  - FeatureFlags werden pro CollectionId als eigenes Modell verwaltet und per Hive gecacht (siehe FeatureFlagsCacheService).
  - Zugriff und State-Management erfolgt über einen eigenen StateNotifierProvider.
  - Fallback-Logik (z.B. Fetch aus API oder MergeService) sollte ergänzt und getestet werden, falls Flags nicht im Cache sind.
  - Testempfehlung: Provider und CacheService mit Unit- und Integrationstests abdecken (Cache, Fallback, TTL, Fehlerfälle).

---

## Begriffsdefinitionen: Placeholder vs. Fallback

- **Placeholder:**
  - Synonym für den initialen Zustand der App (White-Label-Startzustand).
  - Wird genutzt, wenn noch keine echten Daten (API, RSS, JSON, Cache) verfügbar sind.
  - Beispiele: Demo-/Default-Daten, leere Collections, Standard-Branding, FeatureFlags.empty().
  - Garantiert, dass die App immer lauffähig und präsentierbar ist – auch ohne externe Datenquellen.

- **Fallback:**
  - Bedeutet: Zurückgreifen auf eine alternative Datenquelle, wenn die bevorzugte Quelle fehlschlägt oder leer ist.
  - Beispiele:
    - Fallback auf Cache, wenn API nicht erreichbar ist.
    - Fallback auf Placeholder, wenn weder API noch Cache Daten liefern.
    - Fallback auf lokale JSON, wenn RSS-Feed fehlschlägt.
  - Fallback ist immer eine Notlösung im Fehler- oder Ausfallfall, während Placeholder der garantierte Startzustand ist.

### Datenfluss & Prioritäten (Beispiel FeatureFlags, Collections)
- **Priorität:** API > Cache > JSON > Placeholder
- **White-Labeling:** Placeholder ist immer der initiale Zustand, Fallback ist die Notfall-Strategie.
- **Empfehlung:** Bei jeder neuen Datenquelle/Modell immer klar dokumentieren, was Placeholder und was Fallback ist.

---

## 🎧 AudioPlaybackService: BLoC & Riverpod Integration (Mai 2025)

- Die Audio-Wiedergabe wird als eigenständiger BLoC (AudioPlayerBloc) umgesetzt, der die Business-Logik (Play, Pause, Stop, Seek, Fehler, Progress) kapselt.
- Der BLoC ist unabhängig von der UI und dem Audio-Backend (z.B. just_audio) und folgt SOLID-Prinzipien.
- Die Integration in die App erfolgt über einen Riverpod-Provider (z.B. StateNotifierProvider oder BlocProvider via riverpod_bloc).
- Vorteile:
  - Klare Trennung von UI, State und Logik
  - Testbarkeit (Unit-Tests für Bloc, Mocking des Audio-Backends)
  - Erweiterbarkeit (z.B. für AirPlay, Cast, Queue, etc.)
- Beispielstruktur:

```dart
// Event
sealed class AudioPlayerEvent {}
class PlayEpisode extends AudioPlayerEvent { final String url; }
class Pause extends AudioPlayerEvent {}
class Stop extends AudioPlayerEvent {}
// ...

// State
sealed class AudioPlayerState {}
class Idle extends AudioPlayerState {}
class Loading extends AudioPlayerState {}
class Playing extends AudioPlayerState { final Duration position; }
class Paused extends AudioPlayerState { final Duration position; }
class Error extends AudioPlayerState { final String message; }
// ...

// Bloc
class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> { ... }

// Riverpod-Integration
final audioPlayerBlocProvider = Provider<AudioPlayerBloc>((ref) => AudioPlayerBloc(...));
```

- Die UI (z.B. Mini-Player) konsumiert den State über Riverpod und dispatcht Events an den Bloc.
- Siehe auch `.instructions/instructions.md` und `bloc_tutorial_24.md` für Patterns und Best Practices.

---

# ---
# AirPlay/Chromecast-Architektur-Notiz (Mai 2025)
#
# Recherche-Ergebnisse und Architektur-Entscheidung:
#
# 1. Flutter unterstützt AirPlay/Chromecast nur über Plugins oder eigene Plattformkanäle.
# 2. Für Chromecast: Empfohlene Pakete: cast, flutter_chrome_cast, googlecast. Medien müssen kompatibel sein (HLS/DASH).
# 3. Für AirPlay: Empfohlene Pakete: flutter_to_airplay, flutter_ios_airplay. Nur iOS/macOS, meist über AVPlayer.
# 4. MirrorCasting (Screen): systemseitig, nicht direkt steuerbar.
# 5. UI/UX: Cast/AirPlay-Button, Statusanzeige, Fallback bei Nichtverfügbarkeit.
# 6. Architektur: AudioPlayerBloc/Service so gestalten, dass Casting-Events/Status unterstützt werden. UI-Widget für Cast/AirPlay-Button vorsehen. Plattformabhängige Implementierung über Plugin/Channel. Teststrategie: Mocking für Cast/AirPlay-Status, Integrationstests für UI-Logik.
#
# Umsetzung: Architektur und UI (DetailEpisodePage, BottomPlayerWidget) so gestalten, dass AirPlay/Chromecast als optionale Features ergänzt werden können. Integration schrittweise (erst Chromecast, dann AirPlay).
#
# ---
# (Siehe auch .instructions/instructions.md und architecture.md)

## 📡 AirPlay/Chromecast: Plattformübergreifende Strategie (Mai 2025)

### Plattform-Support
- **Chromecast/Google Cast:**
  - Aktive Flutter-Pakete: [`cast`](https://pub.dev/packages/cast), [`flutter_chrome_cast`](https://pub.dev/packages/flutter_chrome_cast), [`googlecast`](https://pub.dev/packages/googlecast)
  - Einschränkungen: Teilweise experimentell, Fokus auf Android/iOS, Medien müssen kompatibel sein (HLS/DASH empfohlen)
  - Empfehlung: Zuerst Chromecast-Integration mit aktuellem Paket (z.B. `cast`), UI/Architektur so gestalten, dass ein Wechsel/Upgrade möglich bleibt
- **AirPlay:**
  - Flutter-Pakete: [`flutter_to_airplay`](https://pub.dev/packages/flutter_to_airplay), [`flutter_ios_airplay`](https://pub.dev/packages/flutter_ios_airplay)
  - Einschränkungen: Nur iOS/macOS, meist keine direkte Mediensteuerung, sondern Hinweis auf iOS Control Center
  - Empfehlung: AirPlay-Button in der UI, Hinweistext/Snackbar für User, ggf. später native Integration

### Architektur-Empfehlung
- **Abstraktion:**
  - Audio-Backend (lokal/Streaming/Cast) und Geräteauswahl über Interface (z.B. `IAudioPlayerBackend`)
  - UI (z.B. BottomPlayerWidget) zeigt Cast/AirPlay-Buttons optional, Status reaktiv, Events an Service/Bloc
  - Mediensteuerung (Play, Pause, Seek) bleibt gekapselt/testbar, Wechsel zwischen lokalem Player und Cast/AirPlay möglich
- **Integration:**
  - Schrittweise: 1. Architektur & UI vorbereiten, 2. Chromecast (Android/iOS), 3. AirPlay (iOS)
  - Mock-Implementierung für Cast/AirPlay bis stabiles Paket verfügbar ist

### Teststrategie
- Mocking für Cast/AirPlay-Status und Geräte
- Widget-/Integrationstests für UI-Logik und Statuswechsel
- Manuelle Tests für AirPlay (iOS Control Center)

### Lessons Learned
- Flutter-Ökosystem für Cast/AirPlay ist noch nicht vollständig stabil, aber produktiv nutzbar mit Workarounds
- Architektur und UI sollten auf Erweiterbarkeit und Austauschbarkeit der Pakete ausgelegt sein
- Plattformunterschiede (Android/iOS) und User Experience (Fallback, Hinweise) immer berücksichtigen

---
(Stand: 29.05.2025, Architektur-Review AirPlay/Chromecast)

---

## Testrobustheit & Lessons Learned: AudioPlayer, Cast/AirPlay, Widget-Tests (Mai 2025)

### Widget- und Integrationstests: Best Practices & Stolperfallen
- **Mocking von Future<void>-Methoden:**
  - Bei allen AudioPlayer-Backends (z.B. just_audio) müssen Methoden wie `play`, `pause`, `stop`, `seek`, `setUrl` im Mock explizit als `Future<void>` überschrieben werden (z.B. `@override Future<void> play() => Future.value();`).
  - Andernfalls entstehen Typfehler (`type 'Null' is not a subtype of type 'Future<void>'`), die von Mocktail nicht automatisch abgefangen werden.
- **Keine doppelten Mocktail-Stubs:**
  - Wenn Methoden in der Mock-Klasse überschrieben sind, dürfen keine zusätzlichen `when(...).thenAnswer(...)`-Stubs für diese Methoden gesetzt werden, sonst schlägt Mocktail fehl.
- **UI-State-Wechsel robust testen:**
  - Nach State-Wechseln (Idle → Playing → Paused → Error → Idle) immer `await tester.pumpAndSettle()` nutzen, um asynchrone UI-Updates sicher abzuwarten.
  - Fehlertexte und Icons sollten mit WidgetPredicate/RegExp gesucht werden, nicht mit exakten Strings oder Icon-Objekten (robust gegen UI-Änderungen).
- **Progressbar im Idle-State:**
  - Nach Stop zeigt das BottomPlayerWidget im Idle-State eine graue Progressbar mit Wert 0.0 an. Die Tests müssen dies explizit prüfen (`expect(progressIndicators.first.value, 0.0);`).
- **Cast/AirPlay-Button:**
  - Der CastAirPlayButton muss in allen States (Idle, Playing, Error) sichtbar und korrekt testbar sein. State-Wechsel (isAvailable, isConnected) werden im Test dynamisch simuliert.

### Troubleshooting & Teststrategie
- **Fehlerquellen:**
  - Typfehler durch fehlendes Mocking von Future-Methoden.
  - UI-Änderungen führen zu fehlschlagenden exakten Icon/Text-Assertions.
  - Asynchrone State-Updates werden ohne `pumpAndSettle` nicht korrekt erkannt.
- **Empfohlene Strategie:**
  - Mock-Klasse für Backend-Services immer mit expliziten async-Overrides.
  - Widget-Tests mit WidgetPredicate/RegExp für flexible UI-Prüfung.
  - Nach jedem State-Wechsel pumpAndSettle nutzen.
  - Testrobustheit regelmäßig gegen UI- und Architekturänderungen prüfen.

### Abgleich mit LLM-Instructions & Teststrategie
- Tests gelten nur als bestanden, wenn sie im Test-Runner grün sind (siehe `.instructions/instructions.md`).
- Testrobustheit ist ein zentrales Qualitätsmerkmal für alle neuen Features und Refactorings.
- Erkenntnisse und Troubleshooting-Schritte werden laufend in diesem Abschnitt dokumentiert.

---

# Accessibility & Semantics-Labels: Lessons Learned (28.05.2025)

## Accessibility-Strategie für BottomPlayerWidget
- Alle wichtigen UI-Elemente (Play, Pause, Stop, Seek, Close, Cast/AirPlay) sind mit Semantics-Labels versehen.
- Die Fortschrittsanzeige (Progressbar) erhält im Playing-State ein Semantics-Label mit aktuellem Fortschritt (z.B. "Fortschritt: 10 Sekunden von 60 Sekunden").
- Die Labels sind im Flutter-Semantics-Tree sichtbar und werden von Screenreadern (VoiceOver, TalkBack) erkannt.

## Teststrategie & Limitationen
- Widget- und Integrationstests prüfen die Semantics-Labels für Buttons und Cast/AirPlay robust mit `find.bySemanticsLabel` (alle grün).
- Für die Progressbar ist die exakte Label-Prüfung mit Flutter-Test-API limitiert, da multiline-Labels (mit Zeilenumbrüchen) nicht zuverlässig gefunden werden.
- Debug-Tests zeigen, dass das Fortschritt-Label im Semantics-Tree vorhanden ist.
- Für Accessibility-Audits und echte Nutzer:innen ist die Barrierefreiheit gewährleistet.
- Hinweis: Für vollständige Accessibility-Validierung empfiehlt sich ein manueller Test mit Screenreader.

## Lessons Learned
- Flutter-Widget-Tests sind für einfache Semantics-Labels robust, für komplexe/multiline Labels aber limitiert.
- Die Accessibility-Qualität sollte immer zusätzlich mit echten Hilfsmitteln (VoiceOver, TalkBack) geprüft werden.
- Die Teststrategie und die Limitationen sind in der Architektur- und Testdokumentation dokumentiert.

---
(Stand: 28.05.2025, Accessibility-Review für BottomPlayerWidget)

---

## Architektur- und Projektstruktur-Update (Stand: 31.05.2025)

**Wichtige Hinweise für die Weiterentwicklung:**
- Die aktuelle Architektur folgt strikt Clean Architecture und den Best Practices aus `.instructions/architecture_clean_architecture.md` und `.instructions/project_structure_best_practices.md`.
- Layer-Trennung, Modularität und LLM-Freundlichkeit sind verbindlich.
- Neue Features, UseCases, Provider und Services immer nach diesen Prinzipien anlegen und in der Doku-Matrix ergänzen.
- Bei Änderungen an der Architektur oder Projektstruktur: Diese Dokumente und die Doku-Matrix sofort aktualisieren!
- Die Doku-Matrix (`.instructions/doku_matrix.md`) ist der zentrale Einstiegspunkt für alle HowTos, Architektur- und Entscheidungsdokumente.

**Empfohlene Vorgehensweise:**
1. Vor jeder Erweiterung oder Refaktorierung: Abgleich mit den Architektur- und Struktur-Dokumenten.
2. Änderungen und neue Patterns immer dokumentieren und in die Matrix aufnehmen.
3. Die Layer-Struktur und Modularität niemals aufweichen – alle Business-Logik bleibt in UseCases und Services.
