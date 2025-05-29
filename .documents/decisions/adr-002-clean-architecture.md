# ADR-002: Clean Architecture für Flutter-Projekte

## Status
Entwurf

## Kontext
Flutter-Projekte profitieren von einer klaren Trennung in Domain, Data, Application und Presentation Layer. Dies erhöht Testbarkeit, Wartbarkeit und Skalierbarkeit.

## Entscheidung
Wir setzen Clean Architecture als Basisstruktur ein, mit Riverpod oder BLoC als State-Management und get_it/injectable für DI.

## Konsequenzen
- Klare Verantwortlichkeiten
- Einfachere Tests
- Bessere Wartbarkeit

---

*Erstellt nach [ADR-Template](https://adr.github.io/)*
