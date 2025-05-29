# Flutter Template Projekt

Dieses Projekt ist ein modernes, best-practice-orientiertes Flutter-Template mit klarer Dokumentationsstruktur, Clean Architecture, State-Management (Riverpod/BLoC), automatisierten Tests und LLM/Automatisierungs-Support.

## Hinweise zur Projektstruktur
- Alle relevanten Best-Practices, Prinzipien und Vorgehensweisen wurden aus dem temporären Ordner `anderes_projekt` extrahiert und in die zentrale Dokumentation übernommen.
- Der Ordner `anderes_projekt` kann nach Abschluss der Template-Erstellung gelöscht werden und ist nicht Teil des eigentlichen Templates.

## Einstieg
- Lies die [GETTING_STARTED.md](GETTING_STARTED.md) für eine Schritt-für-Schritt-Anleitung.
- Siehe [CONTRIBUTING.md](CONTRIBUTING.md) für Mitwirkende.
- Siehe `.documents/` und `.instructions/` für alle Architektur-, Doku- und HowTo-Themen.

## Übersichtlichkeit & Struktur – Best Practices

- Klare, konsistente Ordner- und Dateistruktur (z. B. domain, data, presentation, application, config, core)
- Sprechende, einheitliche Namen für Dateien, Klassen, Methoden und Variablen
- Kurze, prägnante Funktionen und Klassen (keine "God-Classes")
- Einrückung, Leerzeilen und Klammern nach Style Guide (siehe analysis_options.yaml)
- Kommentare nur dort, wo der Code nicht sprechend selbsterklärend ist, mit Praxisbezug und ggf. Quellenangabe
- Zentrale Ablage von Architektur, Prozessen und HowTos in `.documents/` und `.instructions/`
- Trennung von UI und Logik (State Management, keine Business-Logik in Widgets)
- Widget-Aufteilung: Komplexe UI in eigene Widgets/Funktionen auslagern
- Nutzung von const-Widgets, wo möglich
- Zentrale Styles und Theme-Konfiguration für konsistentes Aussehen
- Teststruktur: Trennung von unit, widget und integration tests in eigenen Ordnern
- Plattformspezifische Ordner und Konfigurationsdateien sauber halten
- Build-Skripte und CI/CD klar strukturieren und dokumentieren
- Feature Flags/Environment Configs für plattformspezifische Einstellungen
- Schritt-für-Schritt-Dokumentation für alle Deployment-Zielsysteme

## Code Style & Formatierung

- Nach jeder Widget- und Klassen-Definition folgt grundsätzlich eine Leerzeile.
- Diese Konvention dient der Übersichtlichkeit und Lesbarkeit und ist auch bei automatischer Formatierung (z. B. mit `dart format`) zu beachten.
- Weitere Style-Konventionen siehe analysis_options.yaml.

**Quellen & Community-Standards:**
- [Flutter/Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Clean Architecture (Reso Coder)](https://resocoder.com/)
- [Very Good Ventures Best Practices](https://verygood.ventures/)
- [Flutter.dev Dokumentation](https://docs.flutter.dev/)

Viel Erfolg beim Projektstart und der Weiterentwicklung!

- Siehe `.documents/howto_snackbar.md` für die Nutzung und Erweiterung des SnackBar-Systems.
