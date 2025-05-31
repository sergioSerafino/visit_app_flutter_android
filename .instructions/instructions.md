# 📱 LLM Instructions

Hier findest du spezielle Anweisungen und Guidelines für Large Language Models (LLMs) und Automatisierungstools, die mit diesem Projekt interagieren.

---

## Doku-Übersicht
- **.instructions/README.md**: Einstieg, Projektüberblick, Quickstart.
- **architecture.md**: Architektur, Patterns, technische Konzepte, How-Tos. Enthält jetzt einen eigenen Abschnitt "How-To: Feature, UseCase, Provider hinzufügen".
- **.instructions/instructions.md** (diese Datei): LLM-/Automatisierungsanweisungen, spezielle Hinweise für KI-Tools.
- **bloc_tutorial_24.md**: Modernes BLoC-Pattern, Dart 3, Best Practices.
- **mvp_prd_chatGPT.md**: Soll-Ist-Vergleich, MVP-Features.
- **implementierungsvorschlag_merge_service.md**: # MergeService Prompt für ein LLM in VS Code
- **.instructions/merge_decisions_and_field_sources.md**: # MergeService: Entscheidungsdokumentation & Feldherkunft
- **.instructions/rss_redirects_and_merge_learnings.md**: # Erkenntnisse & Empfehlungen zur robusten RSS-Feed-Verfolgung (Redirects)
- **.instructions/collectionid_refactoring_step1.md**: # Schritt 1: Refactoring CollectionId-Provider & Caching
- **.instructions/merge_caching_step2.md**: # Schritt 2: MergeService, Datenquellen & Caching/Offline
- **.instructions/messaging_featureflags_step3.md**: # Schritt 3: Messaging/Snackbar, FeatureFlags, Teststrategie
- **.instructions/paging_caching_step4.md**: # Schritt 4: Paging- und Listen-Caching für Episoden (Hive, TTL, Provider)
- **.instructions/ui_design_todo.md**: # Offene UI/Design-Optimierungen (Stand: 27.05.2025)
- **.instructions/collection_registry_step5.md**: # Schritt 5: CollectionRegistryService & CollectionId-Validierung
- **.instructions/dev_env_flag.md**: # DEV/ENV-Flag für Fehlerausgabe

---

## Einstieg & How-To für neue Features
- Lies zuerst die Doku-Übersicht oben und die Hinweise in architecture.md.
- Für neue Features, UseCases oder Provider folge dem "How-To"-Abschnitt in architecture.md.
- Halte dich an die Layer-Trennung und Namenskonventionen.
- Nutze Riverpod für State-Management und Dependency Injection.
- Schreibe zu jedem neuen UseCase/Service einen passenden Test (siehe Teststrategie in architecture.md). 
- Nutze Websites zum entwickeln: https://pub.dev/packages/*

---

## Hinweise für LLMs
- Beachte die Clean Architecture-Struktur (siehe architecture.md)
- Halte dich an die Prinzipien (siehe architecture.md)
- Halte dich an die Namenskonventionen und Layer-Trennung
- Nutze Riverpod für State-Management
- Teste UseCases und Services bevorzugt
- Vergleiche den IST Zustand der App mit dem Soll Zustand in ../mvp_prd_chatGPT.md 
- Hier gilt bei Allem: stelle im Zweifelsfall vorher bitte lieber an mich eine Rückfrage bevor du etwas einfach abschaffst
- Nehme dir soviel Zeit wie du brauchst
- **Hinweis für LLMs (Mai 2025):**
  - Frage bei Refactorings oder neuen Features zwischendurch aktiv nach, ob die Änderungen im laufenden App-Betrieb wie beabsichtigt funktionieren oder ob Anpassungen/Abstimmungen nötig sind. So können wir sicherstellen, dass die Umsetzung und das Nutzererlebnis den Erwartungen entsprechen.

---

## DEV/ENV-Flag-Integration geprüft (Mai 2025):
- Alle relevanten Services (MergeService, FeatureFlags, Hive-CRUD, Registry) geben Fehler/Debug-Ausgaben nur im DEV-Modus (`kDebugMode`) aus oder verzichten im Fehlerfall auf User-Ausgaben.
- Prüfung auf ungeschützte `print`/Log-Ausgaben und Exception-Handling durchgeführt. Ergebnis: Keine ungewollten Ausgaben im Release-Modus, Clean Architecture bleibt gewahrt.
- Siehe auch `.instructions/dev_env_flag.md` und Architektur-Doku.

---

## Begriffsdefinitionen: Placeholder vs. Fallback

- **Placeholder:**  
  - Synonym für den initialen Zustand der App, der immer vorhanden ist (z.B. Demo-/Default-Daten, leere Collections, Standard-Branding).
  - Wird genutzt, wenn noch keine echten Daten (API, RSS, JSON, Cache) verfügbar sind.
  - Dient als „sicherer Startpunkt“ für jede White-Label-Instanz.
  - initialer Zustand, White-Label-Start

- **Fallback:**  
  - Bedeutet: „Zurückgreifen auf eine alternative Datenquelle, wenn die bevorzugte Quelle fehlschlägt oder leer ist“.
  - Beispiele:  
    - Fallback auf Cache, wenn API nicht erreichbar ist.
    - Fallback auf Placeholder, wenn weder API noch Cache Daten liefern.
    - Fallback auf lokale JSON, wenn RSS-Feed fehlschlägt.
  - Fallback ist also immer eine „Notlösung“ im Fehler- oder Ausfallfall, während Placeholder der garantierte Startzustand ist.
  - Notfall-Strategie bei Fehlern/Ausfällen.

Weitere Details und Beispiele findest du in den oben genannten Anleitungsdateien im Projektstamm.

---

## Testausführung & Test-Ergebnisse

- Ein Test gilt nur dann als **bestanden**, wenn er im Test-Runner (z.B. `flutter test`) erfolgreich durchläuft (grün).
- Ein Test, der nicht ausgeführt wird oder fehlschlägt, ist als **nicht bestanden** zu behandeln – unabhängig davon, ob der Code syntaktisch korrekt ist.
- Wenn Tests nicht laufen (z.B. wegen Testumgebung, Flutter/Dart-Version, IDE), sollte der User gezielt mit einem workaround vertraut gemacht werden, welchen dieser in seiner Umgebung zu prüfen hat oder den Test manuell auszuführen.
Zur Fehler suche kann dazu ein Blick in das Dokument **test_output.txt** herangezogen werden!
- Die LLM kann dich gezielt bitten, einen Test im Terminal auszuführen (z.B. `flutter test test/...`) und das Ergebnis zu posten, damit die Teststrategie und die Codequalität sichergestellt werden können.

---

## Best Practice: Hive-Test-Setup für Provider/Services

Um Testfehler durch fehlende Hive-Initialisierung oder Seiteneffekte zu vermeiden, ist folgendes Setup für alle Hive-abhängigen Tests verbindlich:

```dart
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('Dein Hive-Test', () async {
    final box = await Hive.openBox('testBox');
    // ... Testlogik ...
    await box.close();
    await Hive.deleteBoxFromDisk('testBox');
  });
}
```

- Für reine Logiktests: Hive-abhängige Services durch Mocks/Fakes ersetzen (siehe `feature_flags_provider_test.dart`).
- Dieses Pattern ist in allen neuen und bestehenden Tests anzuwenden, die Hive nutzen.
- Siehe auch `.instructions/messaging_featureflags_step3.md` und `.instructions/paging_caching_step4.md` für weitere Testmuster.

---

## Projekt-Review & Priorisierung (Mai 2025)

- Vor größeren UI/UX- oder Architekturmaßnahmen empfiehlt sich ein strukturierter Review des Projektstands:
  - **Funktionalität:** Welche Kernfeatures laufen stabil? Wo gibt es Lücken oder Bugs?
  - **User-Flow:** Gibt es Brüche, Wartezeiten, unklare Fehlermeldungen oder fehlende Rückmeldungen?
  - **PRD-Abgleich:** Sind alle Muss-Kriterien aus dem PRD/MVP erfüllt? Gibt es Features, die technisch da sind, aber im UI nicht sichtbar/benutzbar sind?
  - **Barrierefreiheit & UX:** Sind alle wichtigen UI-Elemente zugänglich und verständlich?
  - **Technische Basis:** Ist die Architektur konsistent? Sind alle kritischen Services/Provider testbar und getestet?
  - **Offene TODOs:** Gibt es offene Punkte, bekannte Bugs oder technische Schulden?
- Ein strukturierter Status-Report/Checkliste (siehe unten) hilft, die wichtigsten nächsten Schritte zu identifizieren und zu priorisieren.
- Erst danach gezielt UI/UX, neue Features, Testabdeckung oder Refactoring angehen.

### Beispiel-Checkliste für Review
- [ ] Alle Muss-Kriterien aus PRD/MVP erfüllt
- [ ] Alle Kern-User-Flows funktionieren stabil (Start, Collection-Wechsel, Podcast hören, Kontakt, etc.)
- [ ] Fallback- und Placeholder-Logik überall abgedeckt und getestet
- [ ] UI/UX: Keine groben Brüche, alle wichtigen Elemente zugänglich
- [ ] Architektur: Clean, testbar, keine kritischen TODOs
- [ ] Testabdeckung: Alle kritischen Services/Provider mit Unit-/Integrationstests
- [ ] Offene Bugs/TODOs dokumentiert und priorisiert

---

## Review-Strategie: Abgleich mit IST-Zustand der Codebase (Mai 2025)

- Jeder Review und jede Priorisierung muss immer im Abgleich mit dem tatsächlichen IST-Zustand der aktuellen Codebase erfolgen.
- Die Checkliste und der Status-Report sollen nicht nur die Doku und das PRD/MVP berücksichtigen, sondern explizit prüfen:
  - **Welche Features, Services, Provider, UI-Elemente und Tests sind tatsächlich im Code vorhanden?**
  - **Welche sind nur als Architekturplatzhalter, TODO oder in der Doku vorgesehen, aber noch nicht implementiert?**
  - **Welche Features sind im Code, aber noch nicht in der UI/UX sichtbar oder nutzbar?**
- Bei jedem Review ist ein Abgleich zwischen Doku/PRD und Codebase zu dokumentieren (z.B. "AudioService: Im PRD als Muss, im Code aber noch nicht vorhanden!").
- Ziel: Ein umfassendes, ehrliches Bild des Projektstands, das sowohl die technische Realität als auch die Produktvision abbildet.
- Die Review-Checkliste ist entsprechend zu ergänzen:

### Ergänzte Beispiel-Checkliste für Review (IST-/SOLL-Abgleich)
- [ ] Alle Muss-Kriterien aus PRD/MVP **und** Codebase erfüllt (Abgleich dokumentiert)
- [ ] Alle Kern-User-Flows funktionieren stabil (Code & UI geprüft)
- [ ] Fallback- und Placeholder-Logik überall abgedeckt und getestet (Code & Test geprüft)
- [ ] UI/UX: Keine groben Brüche, alle wichtigen Elemente zugänglich (Code & UI geprüft)
- [ ] Architektur: Clean, testbar, keine kritischen TODOs (Code geprüft)
- [ ] Testabdeckung: Alle kritischen Services/Provider mit Unit-/Integrationstests (Code & Test geprüft)
- [ ] Offene Bugs/TODOs dokumentiert und priorisiert (Code & Doku geprüft)
- [ ] **Abgleich: Features, die im PRD/MVP gefordert, aber im Code (noch) nicht vorhanden sind, sind explizit zu listen!**

---

## AirPlay/Chromecast: Plattformübergreifende Strategie (Mai 2025)

- **Chromecast/Google Cast:**
  - Empfohlene Pakete: [`cast`](https://pub.dev/packages/cast), [`flutter_chrome_cast`](https://pub.dev/packages/flutter_chrome_cast), [`googlecast`](https://pub.dev/packages/googlecast)
  - Fokus: Android/iOS, Medien müssen kompatibel sein (HLS/DASH empfohlen)
  - Integration: Zuerst Chromecast, UI/Architektur so gestalten, dass ein Wechsel/Upgrade möglich bleibt
- **AirPlay:**
  - Empfohlene Pakete: [`flutter_to_airplay`](https://pub.dev/packages/flutter_to_airplay), [`flutter_ios_airplay`](https://pub.dev/packages/flutter_ios_airplay)
  - Fokus: iOS/macOS, meist keine direkte Mediensteuerung, sondern Hinweis auf iOS Control Center
  - Integration: AirPlay-Button in der UI, Hinweistext/Snackbar für User
- **Architektur:**
  - Audio-Backend und Geräteauswahl über Interface (z.B. `IAudioPlayerBackend`)
  - UI zeigt Cast/AirPlay-Buttons optional, Status reaktiv, Events an Service/Bloc
  - Mediensteuerung bleibt gekapselt/testbar, Wechsel zwischen lokalem Player und Cast/AirPlay möglich
- **Teststrategie:**
  - Mocking für Cast/AirPlay-Status und Geräte
  - Widget-/Integrationstests für UI-Logik und Statuswechsel
  - Manuelle Tests für AirPlay (iOS Control Center)
- **Lessons Learned:**
  - Flutter-Ökosystem für Cast/AirPlay ist noch nicht vollständig stabil, aber produktiv nutzbar mit Workarounds
  - Architektur und UI sollten auf Erweiterbarkeit und Austauschbarkeit der Pakete ausgelegt sein
  - Plattformunterschiede (Android/iOS) und User Experience (Fallback, Hinweise) immer berücksichtigen

---

# LLM Instructions (Ergänzung Mai 2025)

Wenn die Ziele und nächsten Schritte klar sind, darf und soll die LLM/Automatisierung eigenständig fortfahren, ohne explizit um Erlaubnis zu bitten. Rückfragen sind nur bei Unklarheiten oder Zielkonflikten nötig.
Das gilt auch für Tests für 'Befehl im Terminal ausführen' und die LLM kann dann einfach auf 'Weiter'

---
