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

---

## Refactoring-Analyse: LandingPage

### Ausgangslage
Die `LandingPage` ist die zentrale Einstiegsseite der App und enthält wiederkehrende UI-Elemente wie `ButtonIconNavigation`, `CoverImageWidget` und `welcomeHeader`. Die Logik ist bereits weitgehend ausgelagert, jedoch existieren noch kleinere Hilfsfunktionen (z.B. `formatTitleByDelimiter`) direkt in der Seite.

### Refactoring-Potenzial
- **Utility-Auslagerung:** Die Hilfsfunktion `formatTitleByDelimiter` kann in eine zentrale Utility-Klasse (z.B. `lib/core/utils/title_format_utils.dart`) ausgelagert werden. Dadurch wird die Wiederverwendbarkeit erhöht und die Seite übersichtlicher.
- **Dokumentation:** Die Auslagerung und Verwendung der Utility-Funktion wird im HowTo dokumentiert und mit Querverweisen versehen.
- **Layout- und Logiktreue:** Das Refactoring erfolgt strikt nach den Prinzipien aus [REFACORING_HOWTO.md → Grundprinzipien](REFACORING_HOWTO.md#grundprinzipien), d.h. das Layout und die Logik der Seite bleiben unverändert.

### Geplantes Vorgehen
1. Auslagerung der Funktion `formatTitleByDelimiter` in eine neue Utility-Datei `lib/core/utils/title_format_utils.dart`.
2. Anpassung der `LandingPage`, sodass die Utility-Funktion verwendet wird.
3. Dokumentation des Schritts mit Querverweisen im HowTo.
4. Commit und Push nach jedem Schritt.

#### Querverweise
- Siehe [lib/presentation/pages/landing_page.dart](lib/presentation/pages/landing_page.dart)
- Siehe [lib/core/utils/title_format_utils.dart](lib/core/utils/title_format_utils.dart) *(wird neu angelegt)*
- Siehe [REFACORING_HOWTO.md → Utility-Auslagerung](REFACORING_HOWTO.md#utility-auslagerung)

## Refactoring-Analyse: SplashPage

### Ausgangslage
Die `SplashPage` ist eine zentrale Einstiegsseite und steuert das Routing (Onboarding, Landing, Home) sowie die Anzeige des Splash-Logos mit animierter Deckkraft. Die Asset-Logik für das Fallback-Logo ist bereits in `TenantAssetLoader` ausgelagert. Die Animation und das Routing sind klar strukturiert.

### Refactoring-Potenzial
- **Utility-Auslagerung:** Die Berechnung des Fallback-Asset-Pfads (`loader.imagePath()`) ist bereits ausgelagert und entspricht den Prinzipien der Wiederverwendbarkeit.
- **Animationsparameter:** Die Parameter für die Splash-Animation (Dauer, Opacity) sind aktuell fest im Widget kodiert. Optional könnten diese in eine zentrale Konstante oder Utility ausgelagert werden, um die Wartbarkeit zu erhöhen.
- **Dokumentation:** Die Struktur und Auslagerung werden im HowTo dokumentiert und mit Querverweisen versehen.
- **Layout- und Logiktreue:** Das Refactoring erfolgt strikt nach den Prinzipien aus [REFACORING_HOWTO.md → Grundprinzipien](REFACORING_HOWTO.md#grundprinzipien), d.h. das Layout und die Logik der Seite bleiben unverändert.

### Geplantes Vorgehen
1. Auslagerung der Animationsparameter in zentrale Konstanten (`lib/core/utils/splash_constants.dart`).
2. Anpassung der SplashPage zur Nutzung dieser Konstanten.
3. Dokumentation des Schritts mit Querverweisen im HowTo.
4. Commit und Push nach jedem Schritt.

#### Querverweise
- Siehe [lib/presentation/pages/splash_page.dart](lib/presentation/pages/splash_page.dart)
- Siehe [lib/core/utils/splash_constants.dart](lib/core/utils/splash_constants.dart) *(wird neu angelegt)*
- Siehe [REFACORING_HOWTO.md → Utility-Auslagerung](REFACORING_HOWTO.md#utility-auslagerung)

## Refactoring-Analyse: LaunchScreen

### Ausgangslage
Die `LaunchScreen` ist die erste Seite der App und zeigt ein zentriertes Splash-Bild sowie einen animierten Lade-Text. Die Animationsparameter (Dauer, Bildgröße, Text, Fallback-Logo) sind aktuell als Konstanten im Widget definiert.

### Refactoring-Potenzial
- **Utility-Auslagerung:** Die Animationsparameter, der Lade-Text und das Fallback-Logo können in eine zentrale Datei (`lib/core/utils/launch_screen_constants.dart`) ausgelagert werden. Dadurch wird die Wartbarkeit erhöht und die Seite übersichtlicher.
- **Dokumentation:** Die Auslagerung und Verwendung der Konstanten wird im HowTo dokumentiert und mit Querverweisen versehen.
- **Layout- und Logiktreue:** Das Refactoring erfolgt strikt nach den Prinzipien aus [REFACORING_HOWTO.md → Grundprinzipien](REFACORING_HOWTO.md#grundprinzipien), d.h. das Layout und die Logik der Seite bleiben unverändert.

### Geplantes Vorgehen
1. Auslagerung der Animationsparameter, des Lade-Texts und des Fallback-Logos in eine neue Datei `lib/core/utils/launch_screen_constants.dart`.
2. Anpassung der LaunchScreen zur Nutzung dieser Konstanten.
3. Dokumentation des Schritts mit Querverweisen im HowTo.
4. Commit und Push nach jedem Schritt.

#### Querverweise
- Siehe [lib/presentation/pages/launch_screen.dart](lib/presentation/pages/launch_screen.dart)
- Siehe [lib/core/utils/launch_screen_constants.dart](lib/core/utils/launch_screen_constants.dart) *(wird neu angelegt)*
- Siehe [REFACORING_HOWTO.md → Utility-Auslagerung](REFACORING_HOWTO.md#utility-auslagerung)

## Refactoring-Analyse: ButtonIconNavigation

### Ausgangslage
Das Widget `ButtonIconNavigation` wird für verschiedene Button-Varianten (Elevated, Outlined, mit/ohne Icon, Custom-Icon) genutzt. Die Standardwerte für Padding, TextStyle und Farben sind aktuell direkt im Widget kodiert.

### Refactoring-Potenzial
- **Utility-Auslagerung:** Die Standardwerte für Padding, TextStyle und ggf. Farben können in eine zentrale Datei (`lib/core/utils/button_icon_navigation_constants.dart`) ausgelagert werden. Dadurch wird die Wartbarkeit erhöht und die Wiederverwendbarkeit verbessert.
- **Dokumentation:** Die Auslagerung und Verwendung der Konstanten wird im HowTo dokumentiert und mit Querverweisen versehen.
- **Layout- und Logiktreue:** Das Refactoring erfolgt strikt nach den Prinzipien aus [REFACORING_HOWTO.md → Grundprinzipien](REFACORING_HOWTO.md#grundprinzipien), d.h. das Layout und die Logik des Widgets bleiben unverändert.

### Geplantes Vorgehen
1. Auslagerung der Standardwerte für Padding, TextStyle und Farben in eine neue Datei `lib/core/utils/button_icon_navigation_constants.dart`.
2. Anpassung des Widgets zur Nutzung dieser Konstanten.
3. Dokumentation des Schritts mit Querverweisen im HowTo.
4. Commit und Push nach jedem Schritt.

#### Querverweise
- Siehe [lib/presentation/widgets/button_icon_navigation.dart](lib/presentation/widgets/button_icon_navigation.dart)
- Siehe [lib/core/utils/button_icon_navigation_constants.dart](lib/core/utils/button_icon_navigation_constants.dart) *(wird neu angelegt)*
- Siehe [REFACORING_HOWTO.md → Utility-Auslagerung](REFACORING_HOWTO.md#utility-auslagerung)

---
