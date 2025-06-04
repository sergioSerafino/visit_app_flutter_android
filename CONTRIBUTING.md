# Beitragende-Richtlinien (CONTRIBUTING)

Willkommen im Flutter-Template! Dieses Dokument erklärt, wie du zum Projekt beitragen kannst und welche Prinzipien, Tools und Best-Practices zu beachten sind.

---

## Schwerpunkte & Prinzipien

### SOLID & Clean Architecture
- **S**ingle Responsibility: Jede Klasse/Datei hat genau eine Aufgabe.
- **O**pen/Closed: Erweiterbar, aber nicht modifizierbar.
- **L**iskov Substitution: Ableitungen müssen Basisklassen ersetzen können.
- **I**nterface Segregation: Kleine, spezifische Schnittstellen.
- **D**ependency Inversion: Abhängigkeiten über Abstraktionen (z. B. UseCases, Repositories).
- **Clean Architecture**: Trennung in Domain, Data, Application, Presentation (siehe `.documents/architecture_clean_architecture.md`).

### Testen
- Test-Driven Development (TDD) wird empfohlen.
- Schreibe Unit- und Widget-Tests für neue Features (siehe `.instructions/ci_cd.md`).
- Automatisierte Tests laufen in der CI/CD-Pipeline.

### Domain-Driven Design (DDD)
- Modellierung der Fachlichkeit in `lib/domain/`.
- Verwende ValueObjects, Entities, UseCases.
- Trenne Business-Logik strikt von der UI.

---

## State-Management
- Nutze Riverpod für reaktives State-Management.
- BLoC für komplexe Business-Logik/Event-Handling.
- Keine Business-Logik in Widgets (siehe `.documents/state_management_riverpod_bloc.md`).

---

## Internet-Links & Ressourcen
- [Reso-Coder:](https://resocoder.com/2022/04/22/riverpod-2-0-complete-guide-flutter-tutorial/)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Riverpod](https://riverpod.dev/)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [get_it](https://pub.dev/packages/get_it)
- [injectable](https://pub.dev/packages/injectable)
- [Hive](https://pub.dev/packages/hive)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Codemagic](https://codemagic.io/)
- [Bitrise](https://www.bitrise.io/)

### Mobile Plattformen & Sprachen (Deployment-Ziele)
- **iOS/Swift/SwiftUI/Objective-C**
  - [Swift](https://swift.org/documentation/)
  - [SwiftUI](https://developer.apple.com/xcode/swiftui/)
  - [Objective-C](https://developer.apple.com/documentation/objectivec)
  - [UIKit](https://developer.apple.com/documentation/uikit)
  - [Xcode](https://developer.apple.com/xcode/)
  - [Apple Developer Doku](https://developer.apple.com/documentation/)
- **Android/Kotlin/Java**
  - [Android Developers](https://developer.android.com/docs)
  - [Kotlin](https://kotlinlang.org/docs/home.html)
  - [Java](https://docs.oracle.com/en/java/)
  - [Android Studio](https://developer.android.com/studio)

# Die folgenden Plattformen sind im Template vorbereitet, aber nicht Haupt-Deployment-Ziel:
#- **Web**
#  - [Flutter Web](https://docs.flutter.dev/platform-integration/web)
#  - [HTML MDN](https://developer.mozilla.org/de/docs/Web/HTML)
#  - [CSS MDN](https://developer.mozilla.org/de/docs/Web/CSS)
#  - [JavaScript MDN](https://developer.mozilla.org/de/docs/Web/JavaScript)
#- **Linux/macOS/Windows**
#  - [Flutter Desktop](https://docs.flutter.dev/desktop)
#  - [CMake](https://cmake.org/documentation/)
#  - [Windows API](https://learn.microsoft.com/de-de/windows/win32/api/)
#  - [macOS Doku](https://developer.apple.com/documentation/macos-release-notes)
#  - [Linux Doku](https://www.kernel.org/doc/html/latest/)

---

## Dokumentation & Querverweise
- `.documents/` – Architektur, Prinzipien, API, ADRs, externe Anforderungen
- `.instructions/` – HowTos, Build, Setup, LLM-Prompts, Automatisierung
- `.documents/principles_matrix.md` – Zentrale Übersicht aller Prinzipien

---

## Legacy-/Migrationshinweise (aus storage_hold)

Dieses Projekt wurde aus einem Vorgängerprojekt migriert. Die ursprünglichen Hinweise und Doku-Workflows lauteten:

### Dokumentationsstruktur (Altprojekt)
- Alle Architektur-, HowTo- und Entscheidungsdokumente befanden sich im Verzeichnis `.documents/` im Projektroot.
- Die Datei `doku_matrix.md` bot eine zentrale Übersicht und Querverweise zu allen relevanten Doku-Dateien.

#### Einstiegspunkt (Altprojekt)
- **Doku-Matrix:** `.documents/doku_matrix.md` (zentrale Übersicht, Querverweise)
- **HowTos, Architektur, ADRs:** Siehe Matrix und Querverweise in den einzelnen Dateien

#### Neue Dokumente anlegen (Altprojekt)
1. Neue HowTos, Architektur- oder Entscheidungsdokumente immer im Verzeichnis `.documents/` (bzw. `.documents/decisions/` für ADRs) ablegen.
2. Den neuen Eintrag in der `doku_matrix.md` ergänzen.
3. Am Anfang der Datei einen Querverweis auf die Matrix und ggf. verwandte Themen ergänzen (siehe Beispiele in bestehenden Dateien).

#### Namenskonventionen (Altprojekt)
- Bei gleichnamigen Dateien bitte mit Suffix wie `-2` oder ähnlichem kennzeichnen, um Überschreibungen zu vermeiden.

#### Code-Conventions und Review (Altprojekt)
- Siehe `.documents/project_structure_best_practices.md` und `.documents/architecture_clean_architecture.md` für Architektur- und Coding-Guidelines.
- Review-Checkliste und offene Punkte: `.documents/status_report.md`

#### Fragen (Altprojekt)
- Bei Unklarheiten bitte zuerst die Doku-Matrix und Querverweise prüfen.
- Für neue Themen oder größere Änderungen bitte einen kurzen Hinweis in der Matrix und im Status-Report ergänzen.

---

## Hinweise für Pull Requests
- Halte dich an die Layer-Trennung und Namenskonventionen.
- Schreibe zu jedem neuen UseCase/Service einen passenden Test.
- Dokumentiere neue Features/Änderungen in den passenden Markdown-Dateien.
- Nutze Copilot Chat und die bereitgestellten Prompts für Code- und Doku-Qualität.

---

Viel Erfolg beim Mitwirken! Bei Fragen oder Unsicherheiten: Siehe die Querverweise oder frage im Team nach.
