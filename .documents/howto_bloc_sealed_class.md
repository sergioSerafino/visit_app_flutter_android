# HowTo: Refactoring von Events und States auf sealed class (Dart 3)

## Ziel
Events und States im BLoC-Pattern mit Dart 3 als `sealed class` und `final class` deklarieren, um Exhaustiveness Checking und Pattern Matching zu nutzen.

## Beispiel: AudioPlayerBloc

Vorher (klassisch):
```dart
abstract class AudioPlayerEvent extends Equatable { ... }
class PlayEpisode extends AudioPlayerEvent { ... }
class Pause extends AudioPlayerEvent { ... }
// ...

abstract class AudioPlayerState extends Equatable { ... }
class Idle extends AudioPlayerState { ... }
class Loading extends AudioPlayerState { ... }
// ...
```

Nachher (Dart 3):
```dart
sealed class AudioPlayerEvent {}
final class PlayEpisode extends AudioPlayerEvent {
  final String url;
  const PlayEpisode(this.url);
}
final class Pause extends AudioPlayerEvent {}
final class Stop extends AudioPlayerEvent {}
// ...weitere Events

sealed class AudioPlayerState {}
final class Idle extends AudioPlayerState {}
final class Loading extends AudioPlayerState {}
final class Playing extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  const Playing(this.position, this.duration);
}
final class ErrorState extends AudioPlayerState {
  final String message;
  const ErrorState(this.message);
}
// ...weitere States
```

## Vorteile
- Verbesserte Typsicherheit und Exhaustiveness Checking
- Klare, moderne Dart 3-Architektur
- Einfacheres Pattern Matching in der UI
- **Weniger Boilerplate:** Kein Equatable mehr nötig, wenn States/Events unveränderlich sind und Pattern Matching genutzt wird.
- **Bessere Testbarkeit:** State-Wechsel und Fehlerfälle lassen sich gezielt abdecken.

## Lessons Learned (AudioPlayerBloc, Stand 06/2025)
- Die Umstellung auf `sealed class`/`final class` für Events und States vereinfacht die Wartung und erhöht die Robustheit.
- Fehlerzustände (ErrorState) und Ladezustände (Loading) werden explizit als State modelliert und in der UI (z.B. Snackbar, LoadingDots) angezeigt.
- Accessibility: Transport-Buttons und Slider im Player erhalten Semantics-Labels für Screenreader.
- Die UI reagiert konsistent auf alle States (Idle, Loading, Playing, Paused, Error) und zeigt immer ein passendes Feedback.
- Tests wurden angepasst, um alle State-Wechsel und Fehlerfälle abzudecken.

## Umsetzung
1. Alle Event- und State-Klassen als `sealed class` bzw. `final class` deklarieren.
2. Equatable kann optional entfallen, wenn Pattern Matching genutzt wird.
3. Tests und UI ggf. anpassen.

---

Weitere Best Practices und Beispiele siehe `.documents/bloc_best_practices_2024.md` und die Reso-Coder Tutorials.
