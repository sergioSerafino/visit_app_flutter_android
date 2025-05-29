# Clean Architecture & TDD – Best Practices (2024)

Basierend auf den Tutorials von Reso Coder und aktuellen Flutter/Dart 3-Praktiken.

## Struktur & Prinzipien
- Trennung in: `domain`, `data`, `presentation`
- `domain`: Entitäten, Use Cases, abstrakte Repositories
- `data`: Datenquellen (remote/local), konkrete Repositories
- `presentation`: UI + State Management (z. B. BLoC, Riverpod)

## Best Practices
- Reine Dart-Klassen in Domain/Data (keine Flutter-Widgets)
- Test-Driven Development (TDD): Red → Green → Refactor
- Fehlerbehandlung: sealed classes, `Either`, `Option` oder eigene Result-Typen
- Moderne State-Management-Optionen: Cubit, Riverpod
- Dependency Injection: `get_it`, `injectable`, Async-Init

## Änderungen 2024
- Dart 3: sealed classes, Pattern Matching, Null Safety
- `on<Event>` statt `mapEventToState` (flutter_bloc)
- Fehlerbehandlung mit sealed classes statt dartz

---

Siehe auch: `.instructions/setup.md` und `.instructions/build.md` für praktische Umsetzung.
