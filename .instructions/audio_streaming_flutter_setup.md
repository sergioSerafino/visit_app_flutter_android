# Modernes Audio-Streaming-Setup in Flutter

Für eine robuste Audio-Streaming- und Wiedergabe-Funktion in Flutter kombinieren wir **just_audio** für die Wiedergabe mit **audio_service** für Hintergrund- und Systemintegration. Dieses Setup unterstützt URL-Streams, Playlists und lokale Dateien sowie Play/Pause, Seek, Shuffle/Repeat und Steuerung über Sperrbildschirm und Benachrichtigungen (Android MediaSession, iOS NowPlayingInfo). Die Steuerung erfolgt über das **BLoC-Pattern** (`flutter_bloc`), eingebettet in eine **Clean-Architecture** und ist testbar (TDD). Folgende Abschnitte zeigen die Architektur, Best Practices und Beispielcode (inklusive Verzeichnisstruktur und Startpunkte).

## 1. Audio-Framework und Pakete

- **just_audio**: Feature-reicher Audioplayer für Streams, Dateien, Playlists etc.
- **audio_service**: Ermöglicht Hintergrundbetrieb, Steuerung über Systeminterfaces.
- **audio_session**: Konfiguriert die Audio-Session für Fokusmanagement.
- **flutter_bloc**: Implementiert BLoC/MVVM für saubere Stateverwaltung.

## 2. AudioHandler: Background-Audio mit audio_service

```dart
class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {}

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) =>
      _player.seek(Duration.zero, index: index);

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode mode) {
    final enable = mode == AudioServiceShuffleMode.all;
    _player.setShuffleModeEnabled(enable);
    return super.setShuffleMode(mode);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode mode) {
    LoopMode loopMode;
    if (mode == AudioServiceRepeatMode.one) loopMode = LoopMode.one;
    else if (mode == AudioServiceRepeatMode.all) loopMode = LoopMode.all;
    else loopMode = LoopMode.off;
    _player.setLoopMode(loopMode);
    return super.setRepeatMode(mode);
  }
}
```

## 3. AudioService Initialisierung

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.example.app.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(MyApp());
}
```

## 4. BLoC für Player-Steuerung

```dart
abstract class AudioEvent {}
class PlayPauseToggle extends AudioEvent {}
class SeekPosition extends AudioEvent {
  final Duration position;
  SeekPosition(this.position);
}

class AudioState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  AudioState({this.isPlaying = false, this.position = Duration.zero, this.duration = Duration.zero});
}

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioHandler _audioHandler;
  StreamSubscription<PlaybackState>? _stateSub;

  AudioBloc(this._audioHandler) : super(AudioState()) {
    on<PlayPauseToggle>((event, emit) async {
      final playing = state.isPlaying;
      if (playing) await _audioHandler.pause();
      else await _audioHandler.play();
    });

    on<SeekPosition>((event, emit) {
      _audioHandler.seek(event.position);
    });

    _stateSub = _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final position = playbackState.updatePosition;
      add(_PlaybackChanged(isPlaying, position));
    });
  }

  @override
  Future<void> close() {
    _stateSub?.cancel();
    return super.close();
  }

  void _onPlaybackChanged(_PlaybackChanged e, Emitter<AudioState> emit) {
    emit(AudioState(isPlaying: e.isPlaying, position: e.position, duration: state.duration));
  }
}
```

## 5. Beispiel UI mit BLoC

```dart
class PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: () => context.read<AudioBloc>().add(PreviousTrackEvent()),
            ),
            IconButton(
              icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () => context.read<AudioBloc>().add(PlayPauseToggle()),
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () => context.read<AudioBloc>().add(NextTrackEvent()),
            ),
          ],
        );
      },
    );
  }
}
```

## 6. Clean Architecture & Struktur

```
lib/
├── core/
│   └── models/
├── data/
│   └── audio/
├── domain/
│   └── audio/
│       ├── entities/
│       ├── repositories/
│       └── usecases/
├── presentation/
│   └── blocs/
│   └── pages/
│   └── widgets/
├── main.dart
```

## 7. Tests und Best Practices

- Verwenden Sie `RepositoryProvider` + `MockAudioHandler`.
- Nutzen Sie Streams des `AudioHandler` als Quelle für Status.
- `WAKE_LOCK` + `audio` UIBackgroundMode setzen.
- Verwenden Sie `BlocTest` und `mocktail` für Unit-Tests.

## 8. Ressourcen

- https://pub.dev/packages/just_audio
- https://pub.dev/packages/audio_service
- https://github.com/ryanheise/just_audio
- https://github.com/suragch/flutter_audio_service_demo