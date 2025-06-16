# Refactoring-HowTo: Flutter App – Robustheit, Wiederverwendbarkeit, Erweiterbarkeit, Portierbarkeit

Dieses Dokument beschreibt die empfohlene Vorgehensweise für das Refactoring der App, um eine solide Basis für Responsive Design und zukünftige Features zu schaffen.

## 1. Saubere Trennung von Logik und UI
- **Ziel:** Business-Logik, Datenzugriff und UI strikt trennen
- **Empfehlung:**
  - Nutze Patterns wie MVVM, Clean Architecture oder Provider/Bloc
  - Lege Datenmodelle, Services und Präsentationslogik in separaten Ordnern ab (z. B. `lib/domain`, `lib/data`, `lib/application`)
  - UI-Widgets gehören in `lib/presentation`

## 2. Wiederverwendbare Widgets und Komponenten
- **Ziel:** Häufig genutzte UI-Elemente als eigene Widgets auslagern
- **Empfehlung:**
  - Extrahiere z. B. Buttons, Cards, Info-Container in `lib/presentation/widgets`
  - Verwende einheitliche Parameter und Theme-Mechanismen

## 3. Klare Struktur und Namensgebung
- **Ziel:** Übersichtliche, wartbare Codebasis
- **Empfehlung:**
  - Ordnerstruktur nach Funktionalität
  - Aussagekräftige Dateinamen und Kommentare

## 4. Konfigurierbarkeit und Portierbarkeit
- **Ziel:** Zentrale Verwaltung von Konstanten und Konfigurationen
- **Empfehlung:**
  - Lege App-weite Konstanten in `lib/config` oder `lib/core/constants` ab
  - Keine Hardcodierung von API-URLs, Feature-Flags etc.

## 5. Testbarkeit
- **Ziel:** Logik testbar machen, Tests anlegen
- **Empfehlung:**
  - Logik in testbare Klassen/Funktionen auslagern
  - Unit- und Widget-Tests für zentrale Komponenten in `test/`

## 6. Dokumentation
- **Ziel:** Verständliche, nachvollziehbare Architektur
- **Empfehlung:**
  - Wichtige Klassen, Methoden und Architekturentscheidungen dokumentieren
  - Dieses HowTo als Einstiegspunkt pflegen

---

## Empfohlene Reihenfolge für das Refactoring
1. **EpisodeDetailPage**: Trennung von Logik und UI, Extraktion wiederverwendbarer Widgets
2. **Weitere zentrale Seiten**: LaunchScreen, SplashPage, LandingPage
3. **Wichtige Widgets**: Zentrale UI-Komponenten extrahieren und vereinheitlichen
4. **Globale Konfiguration und Theme**: Zentrale Styles und Konstanten
5. **Hilfsklassen und Utilities**: DeviceInfoHelper & Co. konsolidieren
6. **Tests und Dokumentation**: Schrittweise ergänzen

---

**Hinweis:**
Nach jedem Refactoring-Schritt auf Emulator und echtem Gerät testen!

---

*Letzte Aktualisierung: 16.06.2025*
