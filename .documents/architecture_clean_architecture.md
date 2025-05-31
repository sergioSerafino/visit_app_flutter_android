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

## Externe Ressourcen & empfohlene Tutorials
- [Flutter TDD Clean Architecture Course (Reso Coder, YouTube)](https://www.youtube.com/playlist?list=PLB6lc7nQ1n4jT2-J_bApC4l3pH0k8B1f2)
  - Umfassende Videoreihe zu TDD, Clean Architecture, Layering, Testing und Best Practices in Flutter.
  - Empfohlene Vorgehensweise laut Reso Coder:
    - **TDD-Zyklus:** Schreibe zuerst einen fehlschlagenden Test (Red), implementiere minimalen Code bis der Test grün ist (Green), dann Refactoring (Refactor).
    - **Architektur:** Strikte Trennung von Domain, Data und Presentation Layer.
    - **Testabdeckung:** Jede Business-Logik (UseCase, Repository, Service) sollte durch Unit- und ggf. Integrationstests abgedeckt werden.
    - **Mocking:** Verwende Mocks für externe Abhängigkeiten (z. B. Datenquellen, APIs) im Test.
    - **Fehlerbehandlung:** Teste auch Fehlerfälle und Randbedingungen.
    - **Empfohlene Tools:** `mockito`, `flutter_test`, ggf. `bloc_test` oder `riverpod_test`.
  - Siehe auch: [Reso Coder Blog](https://resocoder.com/) für weiterführende Artikel und Beispiele.

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Ursprünglicher Hinweis: Sammlung bewährter Flutter-Prinzipien & Architekturstrategien, basierend auf den Tutorial-Serien von Reso Coder.
- Historische Querverweise: Siehe auch `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien. Verwandte Themen: `project_structure_best_practices.md`, `howto_feature_flags.md`.
- Altprojekt-Abschnitt „Firebase & Domain-Driven Design (DDD)“: Siehe ggf. die aktuelle Doku zu ValueObjects, Fassade, Fehlerbehandlung und DDD in den jeweiligen HowTos und Architektur-Abschnitten.

---

Siehe auch: `.instructions/setup.md` und `.instructions/build.md` für praktische Umsetzung.
