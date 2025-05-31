<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->

# Flutter BLoC Pattern – Best Practices & Aktualisierungen für 2024

Diese Datei enthält eine modernisierte Version des BLoC-Tutorials basierend auf Resocoder und dokumentiert **alle wesentlichen Abweichungen** gegenüber älteren Implementierungen (Stand: 2019–2020). Sie verwendet aktuelle Flutter- und Dart 3-Praktiken.

---

## 🧠 Überblick

| Thema | Früher (2019) | Heute (2024) | Änderung |
|-------|----------------|--------------|----------|
| Events | `abstract class` | `sealed class` | Dart 3-Feature, Exhaustiveness Checking |
| Event-Handler | `mapEventToState` | `on<Event>` | Klarer, weniger Fehleranfällig |
| State | mutable Klasse | `const`, unveränderlich | Sicherer & testbarer |
| Cubit | kaum genutzt | für einfache Logik empfohlen | Cubit = leichter, performanter |
| Persistenz | `HydratedBlocDelegate` | `HydratedBlocOverrides.runZoned` | Neue API |
| UI-Access | `BlocProvider.of<T>(context)` | `context.read<T>()` | Kürzer, moderner |
| Vergleichbarkeit | manuell | mit `Equatable` | Effizienter Vergleich |
| Fehler-Handling | individuell | zentralisiert (`BlocObserver`) | Einheitlich |

---

## Implementierung eines modernen BLoC (2024)

### Events definieren

```dart
sealed class CounterEvent {}

final class Increment extends CounterEvent {}

final class Decrement extends CounterEvent {}
```

### State definieren

```dart
class CounterState {
  final int counter;
  const CounterState(this.counter);
}
```

### BLoC definieren

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<Increment>((event, emit) => emit(CounterState(state.counter + 1)));
    on<Decrement>((event, emit) => emit(CounterState(state.counter - 1)));
  }
}
```

---

## Alternativ: Cubit für einfache Fälle

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

---

## Persistenz mit Hydrated BLoC

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}
```

```dart
class CounterBloc extends HydratedBloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['value'] as int?;

  @override
  Map<String, dynamic>? toJson(int state) => {'value': state};
}
```

---

## Dynamisches Theming

```dart
enum AppTheme { light, dark }

class ThemeState {
  final ThemeData themeData;
  const ThemeState(this.themeData);
}

class ThemeEvent {
  final AppTheme theme;
  const ThemeEvent(this.theme);
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(_mapTheme(AppTheme.light))) {
    on<ThemeEvent>((event, emit) =>
      emit(ThemeState(_mapTheme(event.theme))));
  }

  static ThemeData _mapTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.dark:
        return ThemeData.dark();
      case AppTheme.light:
      default:
        return ThemeData.light();
    }
  }
}
```

---

## BlocProvider Lookup (2024)

```dart
BlocProvider(
  create: (_) => CounterBloc(),
  child: Builder(
    builder: (context) {
      final bloc = context.read<CounterBloc>();
      // ...
    },
  ),
);
```

---

## Best Practices

- **Equatable**: Für zuverlässige Vergleichbarkeit von States/Events
- **Unveränderlichkeit**: `final`, `const`, `sealed`
- **Trennung von Logik und UI**
- **Tests**: `bloc_test`-Paket verwenden
- **Fehlerbehandlung zentralisieren** mit `Bloc.observer`

---

## Ressourcen

- [Resocoder Bloc Tutorials](https://resocoder.com/)
- [flutter_bloc Doku (Pub.dev)](https://pub.dev/packages/flutter_bloc)
- [hydrated_bloc Doku](https://pub.dev/packages/hydrated_bloc)

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Historischer Querverweis: Siehe auch `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Ursprung: Modernisierte Version des BLoC-Tutorials, Stand 2024, basierend auf Resocoder und aktuellen Flutter/Dart-Praktiken.
