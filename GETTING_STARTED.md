# Projektstart-Anleitung (Getting Started)

Diese Schritt-für-Schritt-Anleitung hilft neuen Teilnehmenden, ein Projekt auf Basis dieses Templates von Null aufzusetzen.

---

## 1. Voraussetzungen
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installiert
- Git installiert
- IDE wie VS Code, Android Studio oder IntelliJ empfohlen
- Für Mobile-Deployment: Xcode (iOS/macOS), Android Studio (Android)

---

## 2. Repository klonen
```powershell
git clone <REPO-URL>
cd <Projektordner>
```

---

## 3. Abhängigkeiten installieren
```powershell
flutter pub get
```

---

## 4. Projektstruktur verstehen
- Lies die Haupt-README.md für einen Überblick
- Sieh dir `.documents/principles_matrix.md` für alle Prinzipien an
- Lies `.instructions/README.md` und `.documents/README.md` für Doku- und HowTo-Übersicht
- Für Architektur: `.documents/architecture_clean_architecture.md`
- Für State-Management: `.documents/state_management_riverpod_bloc.md`
- Für Projektstruktur: `.documents/project_structure_best_practices.md`
- Für Produktanforderungen: `.documents/prd_white_label_podcast_app.md`

---

## 5. Lokale Entwicklung starten
```powershell
flutter run
```

---

## 6. Eigene Features entwickeln
- Halte dich an Clean Architecture (siehe `.documents/architecture_clean_architecture.md`)
- Nutze Riverpod oder BLoC für State-Management (siehe `.documents/state_management_riverpod_bloc.md`)
- Schreibe zu jedem neuen UseCase/Service einen Test
- Dokumentiere neue Features in den passenden Markdown-Dateien
- Beachte die Prinzipien-Matrix für alle wichtigen Regeln

---

## 7. Tests ausführen
```powershell
flutter test
```

---

## 8. Build & Deployment
- Siehe `.instructions/build.md` und `.instructions/ci_cd.md` für Build- und Deployment-Anleitungen
- Für Mobile-Deployment: Siehe die offiziellen Flutter-Guides für [Android](https://docs.flutter.dev/deployment/android) und [iOS](https://docs.flutter.dev/deployment/ios)
#- Für Web/Desktop: Siehe die auskommentierten Hinweise in CONTRIBUTING.md

---

## 9. Weitere Hilfen
- Nutze die Prompts in `.instructions/prompt.md` für Copilot Chat oder LLMs
- Bei Fragen: Siehe CONTRIBUTING.md und die Querverweise in den README-Dateien
- Für API und externe Anforderungen: `.documents/api.md` und `.documents/external_requirements.md`
- Für Architekturentscheidungen: `.documents/decisions/`

---

Viel Erfolg beim Projektstart! Bei Unsicherheiten: Im Team oder in der Dokumentation nachfragen.
