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
