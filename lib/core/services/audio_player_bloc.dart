// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Audio-Architektur, BLoC-Pattern und Teststrategie.
// Lessons Learned: AudioPlayerBloc implementiert robustes Event-State-Management für Audio-Logik. Siehe auch i_audio_player.dart und zugehörige Provider.
// Hinweise: Für produktive Nutzung Backend anpassen, für Tests Mock-Backend verwenden. Siehe Testdateien für Beispiele.

// lib/core/services/audio_player_bloc.dart
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'i_audio_player.dart';
import 'package:flutter/foundation.dart';

// Events
abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();
  @override
  List<Object?> get props => [];
}

class PlayEpisode extends AudioPlayerEvent {
  final String url;
  const PlayEpisode(this.url);
  @override
  List<Object?> get props => [url];
}

class Pause extends AudioPlayerEvent {}

class Stop extends AudioPlayerEvent {}

class Seek extends AudioPlayerEvent {
  final Duration position;
  const Seek(this.position);
  @override
  List<Object?> get props => [position];
}

class UpdatePosition extends AudioPlayerEvent {
  final Duration position;
  const UpdatePosition(this.position);
  @override
  List<Object?> get props => [position];
}

class TogglePlayPause extends AudioPlayerEvent {}

// States
abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();
  @override
  List<Object?> get props => [];
}

class Idle extends AudioPlayerState {}

class Loading extends AudioPlayerState {}

class Playing extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  const Playing(this.position, this.duration);
  @override
  List<Object?> get props => [position, duration];
}

class Paused extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  const Paused(this.position, this.duration);
  @override
  List<Object?> get props => [position, duration];
}

class ErrorState extends AudioPlayerState {
  final String message;
  const ErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final IAudioPlayerBackend backend;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<dynamic>? _playerStateSub;
  StreamSubscription<Duration?>? _durationSub;
  Duration _duration = Duration.zero;
  bool _disposed = false;
  String? _currentUrl; // NEU: Zuletzt abgespielte URL

  AudioPlayerBloc({required IAudioPlayerBackend backend})
      : backend = backend,
        super(Idle()) {
    on<PlayEpisode>((event, emit) async {
      if (event.url.isEmpty || event.url.trim().isEmpty) {
        emit(const ErrorState('Keine gültige Audio-URL übergeben.'));
        if (kDebugMode)
          print('[AudioPlayerBloc] Leere oder ungültige URL: "${event.url}"');
        return;
      }
      if (kDebugMode)
        print('[AudioPlayerBloc] PlayEpisode mit URL: ${event.url}');
      emit(Loading());
      try {
        await this.backend.stop();
        _currentUrl = event.url; // URL merken
        await this.backend.setUrl(event.url);
        // Resume-Position merken, falls vorhanden
        Duration resumePosition = Duration.zero;
        if (state is Paused) {
          resumePosition = (state as Paused).position;
        }
        if (resumePosition > Duration.zero) {
          await this.backend.seek(resumePosition);
        }
        _duration = this.backend.duration ?? Duration.zero;
        emit(Playing(resumePosition, _duration));
        await this.backend.play();
        _listenToPosition();
        _durationSub?.cancel();
        _durationSub = backend.durationStream.listen((dur) {
          if (!_disposed && dur != null && dur > Duration.zero) {
            _duration = dur;
            if (state is Playing) {
              add(UpdatePosition((state as Playing).position));
            } else if (state is Paused) {
              add(UpdatePosition((state as Paused).position));
            }
          }
        });
      } catch (e) {
        emit(ErrorState('Fehler beim Laden: ${e.toString()}'));
        if (kDebugMode) print('[AudioPlayerBloc] Fehler beim Play: $e');
      }
    });
    on<Pause>((event, emit) async {
      await this.backend.pause();
      final pos = this.backend.position;
      emit(Paused(pos, _duration));
    });
    on<Stop>((event, emit) async {
      await this.backend.stop();
      _positionSub?.cancel();
      _positionSub = null;
      _playerStateSub?.cancel();
      _playerStateSub = null;
      _durationSub?.cancel();
      _durationSub = null;
      _duration = Duration.zero;
      _currentUrl = null;
      emit(Idle());
    });
    on<Seek>((event, emit) async {
      await this.backend.seek(event.position);
      // KEIN direktes emit, Stream-Listener übernimmt
    });
    on<TogglePlayPause>((event, emit) async {
      if (state is Playing) {
        add(Pause());
      } else if (state is Paused) {
        // Resume: immer die zuletzt bekannte URL verwenden
        if (_currentUrl != null && _currentUrl!.isNotEmpty) {
          add(PlayEpisode(_currentUrl!));
        } else {
          emit(const ErrorState('Keine gültige Audio-URL zum Fortsetzen.'));
        }
      } else {
        // Kein Track geladen: Fehler oder Idle
        if (_currentUrl != null && _currentUrl!.isNotEmpty) {
          add(PlayEpisode(_currentUrl!));
        } else {
          emit(const ErrorState('Keine Audio-URL geladen.'));
        }
      }
    });
    on<UpdatePosition>((event, emit) async {
      if (state is Playing || state is Loading) {
        emit(Playing(event.position, _duration));
      } else if (state is Paused) {
        emit(Paused(event.position, _duration));
      }
    });
  }

  @override
  Future<void> close() {
    _disposed = true;
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _durationSub?.cancel();
    backend.dispose();
    return super.close();
  }

  void _listenToPosition() {
    _positionSub?.cancel();
    _positionSub = null;
    _positionSub = backend.positionStream.listen(
      (pos) {
        if (!_disposed) {
          add(UpdatePosition(pos));
        }
      },
      onError: (e, st) {
        if (kDebugMode)
          print('[AudioPlayerBloc] Fehler im positionStream: $e\n$st');
        addError(e, st);
      },
    );
    _durationSub = backend.durationStream.listen(
      (dur) {
        if (!_disposed && dur != null && dur > Duration.zero) {
          _duration = dur;
          if (state is Playing) {
            add(UpdatePosition((state as Playing).position));
          } else if (state is Paused) {
            add(UpdatePosition((state as Paused).position));
          }
        }
      },
      onError: (e, st) {
        if (kDebugMode)
          print('[AudioPlayerBloc] Fehler im durationStream: $e\n$st');
        addError(e, st);
      },
    );
    _playerStateSub = backend.playerStateStream.listen(
      (state) {
        if (!_disposed &&
            state is PlayerState &&
            state.processingState == ProcessingState.completed) {
          log('[AudioPlayerBloc] Playback completed');

          add(Stop());
        }
      },
      onError: (e, st) {
        log('[AudioPlayerBloc] Fehler im playerStateStream: $e\n$st');
        addError(e, st);
      },
    );
  }
}

// just_audio-Implementierung
// --- JUST_AUDIO Fehlerbehandlung & Best Practices ---
// Siehe https://pub.dev/packages/just_audio#handling-errors
// - Fange alle Exceptions bei setUrl, play, pause, stop, seek ab
// - Ergänze onError-Handler für Streams
// - Logge Fehler im DEV-Modus (kDebugMode)
// - Gib Fehler als ErrorState an den Bloc weiter

class JustAudioPlayerBackend implements IAudioPlayerBackend {
  AudioPlayer _audioPlayer = AudioPlayer();

  void _resetPlayer() {
    try {
      _audioPlayer.dispose();
    } catch (_) {}
    _audioPlayer = AudioPlayer();
    if (kDebugMode)
      print('[JustAudioPlayerBackend] Player wurde neu initialisiert');
  }

  @override
  Future<void> setUrl(String url) async {
    try {
      await _audioPlayer.setUrl(url);
    } catch (e, st) {
      if (kDebugMode)
        print('[JustAudioPlayerBackend] Fehler bei setUrl: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e, st) {
      if (kDebugMode)
        print('[JustAudioPlayerBackend] Fehler bei play: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e, st) {
      if (kDebugMode)
        print('[JustAudioPlayerBackend] Fehler bei pause: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _resetPlayer(); // Nur nach Stop wird der Player neu initialisiert
    } catch (e, st) {
      if (kDebugMode)
        print('[JustAudioPlayerBackend] Fehler bei stop: $e\n$st');
      _resetPlayer();
      rethrow;
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e, st) {
      if (kDebugMode)
        print('[JustAudioPlayerBackend] Fehler bei seek: $e\n$st');
      rethrow;
    }
  }

  @override
  Stream<Duration> get positionStream =>
      _audioPlayer.positionStream.handleError((e, st) {
        if (kDebugMode)
          print('[JustAudioPlayerBackend] Fehler im positionStream: $e\n$st');
      });
  @override
  Stream<Duration?> get durationStream =>
      _audioPlayer.durationStream.handleError((e, st) {
        if (kDebugMode)
          print('[JustAudioPlayerBackend] Fehler im durationStream: $e\n$st');
      });
  @override
  Stream<dynamic> get playerStateStream =>
      _audioPlayer.playerStateStream.handleError((e, st) {
        if (kDebugMode)
          print(
            '[JustAudioPlayerBackend] Fehler im playerStateStream: $e\n$st',
          );
      });
  @override
  Duration get position => _audioPlayer.position;
  @override
  Duration? get duration => _audioPlayer.duration;
  @override
  bool get playing => _audioPlayer.playing;
  @override
  void dispose() {
    _audioPlayer.dispose();
    _resetPlayer();
  }
}
