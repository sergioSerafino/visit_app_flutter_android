# Refactoring-HowTo: Flutter App – Robustheit, Wiederverwendbarkeit, Erweiterbarkeit, Portierbarkeit

> **WICHTIG:**
> Das Refactoring orientiert sich strikt am bestehenden Layout und Design der App. Es werden keine optischen oder strukturellen Änderungen am UI-Layout vorgenommen. Ziel ist ausschließlich die Verbesserung der Codebasis (Robustheit, Wiederverwendbarkeit, Erweiterbarkeit, Portierbarkeit), nicht die Änderung des Nutzererlebnisses oder der Optik.

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

# Analyse und Planung des Refactorings

## Zielsetzung
Das Refactoring der Flutter-App verfolgt das Ziel, die Codebasis hinsichtlich Robustheit, Wiederverwendbarkeit, Erweiterbarkeit und Portierbarkeit zu verbessern. Dabei ist es zwingend erforderlich, dass sowohl das **Layout** als auch die **Logik** der Anwendung zu jedem Zeitpunkt unverändert bleiben. Siehe dazu auch [REFACORING_HOWTO.md → Grundprinzipien](REFACORING_HOWTO.md#grundprinzipien).

## Vorgehen
1. **Identifikation von Refactoring-Potenzial**: Analyse der bestehenden Codebasis auf wiederkehrende Muster, Duplikate, unklare Strukturen oder Verbesserungsmöglichkeiten (z.B. Utility-Auslagerung, bessere Namensgebung, Modularisierung).
2. **Planung der Refactoring-Schritte**: Festlegung kleiner, atomarer Schritte, die jeweils einzeln committet und gepusht werden. Nach jedem Schritt erfolgt eine Überprüfung, dass Layout und Logik unverändert sind.
3. **Dokumentation**: Jeder Refactoring-Schritt wird im HowTo-Dokument ([REFACORING_HOWTO.md](REFACORING_HOWTO.md)) dokumentiert, inklusive Querverweisen auf relevante Codestellen und Prinzipien.
4. **Querverweise**: Bei jeder Änderung werden Querverweise auf die betroffenen Dateien und Abschnitte im HowTo gesetzt, um die Nachvollziehbarkeit zu gewährleisten.

## Beispielhafte Querverweise
- Siehe [REFACORING_HOWTO.md → Utility-Auslagerung](REFACORING_HOWTO.md#utility-auslagerung)
- Siehe [lib/core/utils/episode_format_utils.dart](lib/core/utils/episode_format_utils.dart)
- Siehe [lib/presentation/pages/episode_detail_page.dart](lib/presentation/pages/episode_detail_page.dart)

## Nächste Schritte
- Ergänzung des HowTo um den expliziten Punkt, dass auch die Logik (nicht nur das Layout) beim Refactoring stets unverändert bleiben muss.
- Fortsetzung des Refactorings nach diesen Prinzipien an weiteren zentralen Seiten oder häufig genutzten Widgets.

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

## Grundprinzipien

- **Layouttreue**: Das visuelle Erscheinungsbild (Layout) der App darf durch das Refactoring zu keinem Zeitpunkt verändert werden. Jede Änderung muss so erfolgen, dass das UI exakt wie zuvor bleibt.
- **Logiktreue**: Auch die **Logik** der Anwendung (Ablauf, Datenverarbeitung, Interaktionen, Navigation etc.) muss beim Refactoring stets unverändert bleiben. Es dürfen keine funktionalen Änderungen, Erweiterungen oder Reduktionen vorgenommen werden. Ziel ist ausschließlich die Verbesserung der Codebasis, nicht der Funktionalität.
