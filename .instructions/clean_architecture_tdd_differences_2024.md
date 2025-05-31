<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->

# 🚀 Clean Architecture & TDD – Modernisiert für 2024 mit Dart 3

Dieses Dokument ergänzt das ursprüngliche Tutorial von Reso Coder um **alle relevanten Abweichungen und Verbesserungen**, die sich seit 2020 in Flutter & Dart ergeben haben – insbesondere durch **Null Safety**, **Dart 3 Features** und **moderne State Management Optionen**.

---

## 🔄 Übersicht: Änderungen im Vergleich zum Original

| Bereich                     | Alt (2019–2020)                  | Neu (2024)                            |
|----------------------------|----------------------------------|--------------------------------------|
| Null Safety                | ❌ Nicht verfügbar                | ✅ Voll integriert                    |
| flutter_bloc API           | `mapEventToState`                | `on<Event>` empfohlen                |
| Dependency Injection       | Klassisch (`get_it`)             | Async-Init optional                  |
| State Management           | BLoC                             | Cubit, Riverpod (empfohlen)          |
| Error Handling             | `dartz.Either`                   | sealed class / Result                |
| Dart Sprachfeatures        | Kein Dart 3                      | ✅ Pattern Matching, Sealed Classes  |

---

## ✅ 1. Null Safety

- **Alte Syntax (nicht null-sicher)**:
  ```dart
  final String text;
  NumberTrivia({this.text, this.number});
  ```
- **Neu**:
  ```dart
  const NumberTrivia({required this.text, required this.number});
  ```

---

## 🔄 2. `flutter_bloc` aktualisiert (v8+)

- **Vorher (mapEventToState):**
  ```dart
  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) { ... }
  }
  ```

- **Neu (`on<Event>` Syntax):**
  ```dart
  NumberTriviaBloc() : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      emit(Loading());
      final result = await getConcreteNumberTrivia(Params(event.number));
      result.fold(
        (failure) => emit(Error(message: _mapFailureToMessage(failure))),
        (trivia) => emit(Loaded(trivia: trivia)),
      );
    });
  }
  ```

---

## 💡 3. Sealed Class statt `dartz.Either`

```dart
sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  Failure(this.message);
}
```

- **Anwendung:**
  ```dart
  Result<NumberTrivia> result = await useCase(params);
  switch (result) {
    case Success(:final data):
      // Erfolg
      break;
    case Failure(:final message):
      // Fehler anzeigen
      break;
  }
  ```

---

## 🔌 4. Dependency Injection (modernisiert)

```dart
final sl = GetIt.instance;

Future<void> init() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  sl.registerSingleton(sharedPrefs);

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerFactory(() => NumberTriviaBloc(
    getConcreteNumberTrivia: sl(),
    getRandomNumberTrivia: sl(),
  ));
}
```

---

## 🌱 5. State Management Alternativen

- **BLoC**: weiterhin nutzbar (insb. mit `flutter_bloc`)
- **Riverpod**: moderner, testfreundlich, funktional
- **Cubit**: vereinfachte BLoC-Variante

```dart
class NumberTriviaCubit extends Cubit<NumberTriviaState> {
  NumberTriviaCubit(this.getTrivia) : super(Initial());

  final GetConcreteNumberTrivia getTrivia;

  Future<void> fetchTrivia(int number) async {
    emit(Loading());
    final result = await getTrivia(Params(number: number));
    result.fold(
      (failure) => emit(Error(message: "Ups...")),
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }
}
```

---

## ✅ Empfehlung

> Nutze für neue Projekte:
> - `Riverpod` für State Management
> - `sealed class` für Error Handling
> - `GetIt` oder `Riverpod` für DI
> - `Freezed` für Datenmodelle und Union Types
> - Dart 3 Features wo möglich einsetzen (Records, Pattern Matching)

---

## 📚 Ressourcen

- [Dart Language Tour](https://dart.dev/language)
- [flutter_bloc Dokumentation](https://pub.dev/packages/flutter_bloc)
- [Riverpod](https://riverpod.dev/)
- [Freezed](https://pub.dev/packages/freezed)

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Historischer Querverweis: Siehe auch `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Ursprung: Ergänzung zum Reso Coder Tutorial, Fokus auf Dart 3, Null Safety und moderne State Management Optionen.
