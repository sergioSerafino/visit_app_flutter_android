# LLM Instructions & Automatisierung

Hier findest du spezielle Anweisungen und Guidelines für Large Language Models (LLMs) und Automatisierungstools, die mit diesem Projekt interagieren.

## Einstieg & How-To für neue Features
- Lies zuerst die Doku-Übersicht in `.instructions/README.md` und die Hinweise in `.documents/architecture_clean_architecture.md`.
- Für neue Features, UseCases oder Provider folge dem How-To-Abschnitt in der Architektur-Doku.
- Halte dich an die Layer-Trennung und Namenskonventionen.
- Nutze Riverpod oder BLoC für State-Management und Dependency Injection.
- Schreibe zu jedem neuen UseCase/Service einen passenden Test.

## Hinweise für LLMs
- Beachte die Clean Architecture-Struktur
- Halte dich an die Prinzipien und Namenskonventionen
- Teste UseCases und Services bevorzugt
- Vergleiche den IST-Zustand der App mit dem Soll-Zustand in `.documents/prd_white_label_podcast_app.md`
- Frage bei Refactorings oder neuen Features aktiv nach, ob die Änderungen im laufenden App-Betrieb wie beabsichtigt funktionieren oder ob Anpassungen/Abstimmungen nötig sind.
- Nimm dir Zeit für sorgfältige Umsetzung und Rückfragen.
