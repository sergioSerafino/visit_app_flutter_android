# State Management: Riverpod, BLoC & MVVM (ViewModel)

## Empfehlungen
- Riverpod für reaktives State-Management (Provider, StateNotifier)
- BLoC für komplexe Business-Logik und Event-Handling
- **MVVM (ViewModel, z.B. mit ChangeNotifier/StateNotifier) ist als Alternative im Presentation-Layer möglich**
- Keine Business-Logik in Widgets
- State-Management zentral dokumentieren

## Wann MVVM einsetzen?
- **Empfohlen bei:**
  - UI-zentrierten Features mit viel Interaktion und View-spezifischer Logik
  - Wenn die UI-Logik klar von der Business-Logik getrennt werden soll
  - Teams, die bereits Erfahrung mit MVVM aus anderen Frameworks (z.B. Android, .NET) haben
  - Kleinere bis mittlere Apps, bei denen BLoC als zu komplex empfunden wird
- **Nicht zwingend notwendig bei:**
  - Sehr einfacher UI-Logik (z.B. statische Screens, wenig Interaktion)
  - Wenn bereits ein etabliertes State-Management (z.B. BLoC, Riverpod) genutzt wird und keine Vorteile durch MVVM entstehen
  - Wenn die Trennung von UI- und Business-Logik bereits durch Clean Architecture und State-Management gewährleistet ist

## Hinweise zu MVVM
- MVVM ist mit der bestehenden Clean Architecture kompatibel (Presentation-Layer)
- ViewModel kann als Ersatz für BLoC/Cubit genutzt werden
- Beispiel: Ein StateNotifier/ChangeNotifier-ViewModel übernimmt die UI-Logik und wird per Provider eingebunden
- Die Layer-Struktur (Domain, Data, Application, Presentation) bleibt erhalten
- Siehe Clean Architecture-Doku und Prinzipien-Matrix für Details

## Beispiel: MVVM (ViewModel) mit ChangeNotifier/StateNotifier

### Flutter/Dart 3 – CounterViewModel (ChangeNotifier)
```dart
import 'package:flutter/foundation.dart';

class CounterViewModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}
```

### Einbindung in die UI (z.B. mit AnimatedBuilder)
```dart
// ...
AnimatedBuilder(
  animation: _viewModel,
  builder: (context, _) => Text('${_viewModel.counter}'),
)
// ...
```

## Tipps
- ViewModel kann als Alternative zu BLoC/Cubit verwendet werden
- Für komplexere Szenarien empfiehlt sich StateNotifier (Riverpod) oder Provider
- Die Layer-Struktur bleibt Clean Architecture-konform
- Halte State-Management-Entscheidungen in `decisions/` fest

---

Weitere Beispiele und Varianten können bei Bedarf ergänzt werden.
