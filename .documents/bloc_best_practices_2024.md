# Flutter BLoC Pattern – Best Practices & Updates 2024

## Überblick
- Events als `sealed class` (Dart 3)
- Event-Handler mit `on<Event>`
- States unveränderlich (`const`)
- Cubit für einfache Logik
- Persistenz mit `HydratedBlocOverrides.runZoned`
- Zugriff: `context.read<T>()`
- Vergleich: `Equatable`
- Fehler-Handling zentralisiert (`BlocObserver`)

## Beispiel (modern):
```dart
sealed class CounterEvent {}
final class Increment extends CounterEvent {}
final class Decrement extends CounterEvent {}

class CounterState {
  final int counter;
  const CounterState(this.counter);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<Increment>((event, emit) => emit(CounterState(state.counter + 1)));
    on<Decrement>((event, emit) => emit(CounterState(state.counter - 1)));
  }
}
```

## Tipps
- Trenne Event → State klar
- Business-Logik nicht in der UI
- Nutze `/explain` und `/tests` in Copilot Chat für Verständnis und Testgenerierung.

---

## Review: AudioPlayerBloc vs. BLoC Best Practices (Stand: 04.06.2025)

**Vergleich und Bewertung der AudioPlayerBloc-Implementierung anhand aktueller BLoC-Best-Practices (Reso Coder, Dart 3, Clean Architecture):**

| Kriterium                | Umsetzung im Projekt (IST)                                                                 | Best Practice (SOLL)                                      | Bewertung      |
|--------------------------|-------------------------------------------------------------------------------------------|-----------------------------------------------------------|---------------|
| **Struktur & Layering**  | Bloc im Service-Layer, UI konsumiert State via Provider                                   | Trennung von UI, State, Logik                             | ✔️ Sehr gut    |
| **Events & States**      | Eigene Klassen, Equatable, Handler mit `on<Event>`                                        | `sealed class` (Dart 3), unveränderlich, `on<Event>`      | ✔️ Modern, kleine Optimierung möglich |
| **Fehlerbehandlung**     | Fehler als State, DEV-Logging, Fehler-States in UI                                        | Fehler zentralisieren, States für Fehler, Logging          | ✔️ Robust      |
| **Testbarkeit**          | Mock-Backend, Unit- und Widget-Tests für alle State-Wechsel und Fehlerfälle               | Bloc-Logik und Backend testbar, alle State-Transitions     | ✔️ Sehr gut    |
| **Abstraktion**          | Backend via Interface, AirPlay/Cast vorbereitet                                           | Austauschbare Backends, Erweiterbarkeit                    | ✔️ Vorbildlich |
| **State-Management**     | Bloc via Riverpod bereitgestellt, State als Stream                                        | Provider-Pattern oder BlocProvider                         | ✔️ Sehr gut    |
| **Unveränderlichkeit**   | States/Events sind `const`, Equatable                                                      | Unveränderliche States, Vergleichbarkeit                   | ✔️ Best Practice |
| **Persistenz**           | Noch keine HydratedBloc-Persistenz, aber vorbereitet                                      | Optional für Resume-Features                               | ⚠️ Optional    |
| **UI/UX-Feedback**       | Fehler, Ladezustände, Fortschritt als State und via Snackbar                              | Konsistentes User-Feedback, keine Logik in der UI          | ✔️ Sehr gut    |
| **Dokumentation**        | Doku, Querverweise, Lessons Learned vorhanden                                             | Doku und Architekturentscheidungen nachvollziehbar         | ✔️ Sehr gut    |

**Empfehlung:**
- Optional: Events und States als `sealed class` (Dart 3) deklarieren, um Exhaustiveness Checking und Pattern Matching zu nutzen.
- Optional: HydratedBloc für Resume-Features (z. B. Wiedergabeposition) prüfen.
- Weiter so – die Umsetzung ist auf sehr hohem Niveau und entspricht den fortgeschrittenen BLoC-Standards!
