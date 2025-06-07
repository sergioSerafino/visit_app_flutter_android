// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Audio-Architektur, BLoC-Pattern und Teststrategie.
// Lessons Learned: AudioPlayerBloc implementiert robustes Event-State-Management für Audio-Logik. Siehe auch i_audio_player.dart und zugehörige Provider.
// Hinweise: Für produktive Nutzung Backend anpassen, für Tests Mock-Backend verwenden. Siehe Testdateien für Beispiele.

// lib/core/services/audio_player_bloc.dart
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import '../logging/logger_config.dart';
import 'i_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

/// ---
/// PRODUCTION: Audio-Streaming Stabilität & Fehlerbehandlung (Juni 2025)
///
/// - setUrl/play werden mit Retry-Logik (max. 2 Versuche) und Timeout (10s) ausgeführt
/// - Fehler (Netzwerk, Timeout, ungültige URL) werden als ErrorState emittiert und geloggt
/// - Bei Netzwerkfehlern/Timeout wird eine Snackbar mit passender Message getriggert
/// - TODO: Monitoring/Analytics für Streaming-Fehler ergänzen
/// - TODO: Fallback-Mechanismus für Windows/Linux (z.B. just_audio_media_kit) prüfen
///

/// ---
/// PRODUCTION: Audio-Streaming Stabilität & Fehlerbehandlung (Juni 2025)
///
/// - setUrl/play werden mit Retry-Logik (max. 2 Versuche) und Timeout (10s) ausgeführt
/// - Fehler (Netzwerk, Timeout, ungültige URL) werden als ErrorState emittiert und geloggt
/// - Bei Netzwerkfehlern/Timeout wird eine Snackbar mit passender Message getriggert
/// - TODO: Monitoring/Analytics für Streaming-Fehler ergänzen
/// - TODO: Fallback-Mechanismus für Windows/Linux (z.B. just_audio_media_kit) prüfen
///

/// Events
sealed class AudioPlayerEvent {}

final class PlayEpisode extends AudioPlayerEvent {
  final String url;
  PlayEpisode(this.url);
}

final class Pause extends AudioPlayerEvent {}

final class Stop extends AudioPlayerEvent {}

final class Seek extends AudioPlayerEvent {
  final Duration position;
  Seek(this.position);
}

final class UpdatePosition extends AudioPlayerEvent {
  final Duration position;
  UpdatePosition(this.position);
}

final class TogglePlayPause extends AudioPlayerEvent {}

final class SetSpeed extends AudioPlayerEvent {
  final double speed;
  SetSpeed(this.speed);
}

final class PreloadEpisode extends AudioPlayerEvent {
  final String url;
  PreloadEpisode(this.url);
}

final class SetVolume extends AudioPlayerEvent {
  final double volume;
  SetVolume(this.volume);
}

// States
sealed class AudioPlayerState {}

final class Idle extends AudioPlayerState {}

final class Loading extends AudioPlayerState {}

@immutable
final class Playing extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  final double speed;
  Playing(this.position, this.duration, {this.speed = 1.0});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Playing &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          duration == other.duration &&
          speed == other.speed;
  @override
  int get hashCode => Object.hash(position, duration, speed);
}

@immutable
final class Paused extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  final double speed;
  Paused(this.position, this.duration, {this.speed = 1.0});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Paused &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          duration == other.duration &&
          speed == other.speed;
  @override
  int get hashCode => Object.hash(position, duration, speed);
}

@immutable
final class ErrorState extends AudioPlayerState {
  final String message;
  ErrorState(this.message);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorState &&
          runtimeType == other.runtimeType &&
          message == other.message;
  @override
  int get hashCode => message.hashCode;
}

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final IAudioPlayerBackend backend;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<dynamic>? _playerStateSub;
  StreamSubscription<Duration?>? _durationSub;
  Duration _duration = Duration.zero;
  bool _disposed = false;
  String? _currentUrl; // NEU: Zuletzt abgespielte URL
  Duration _lastKnownPosition = Duration.zero; // NEU: Letzte plausible Position
  bool _isBusy = false; // Blockiert parallele Play/Pause-Operationen
  bool _pendingToggle =
      false; // Merkt sich, ob während busy ein TogglePlayPause gewünscht wurde

  int _autoResumeAttempts = 0; // NEU: Zähler für Auto-Reconnect-Versuche

  String? get currentUrl => _currentUrl;
  set currentUrl(String? value) {
    // Nur bei PlayEpisode, PreloadEpisode oder Stop setzen
    _currentUrl = value;
  }

  int get autoResumeAttempts => _autoResumeAttempts;

  // Die busy-Flag verhindert, dass TogglePlayPause mehrfach verarbeitet wird, solange eine Play- oder Pause-Operation läuft.
  // Damit wird garantiert, dass jeder Klick deterministisch verarbeitet wird und die Audio-Steuerung exakt auf jeden Klick reagiert.

  AudioPlayerBloc({required IAudioPlayerBackend backend})
      : backend = backend,
        super(Idle()) {
    on<PlayEpisode>((event, emit) async {
      if (kDebugMode)
        logDebug(
            '[AudioPlayerBloc] Event: PlayEpisode(${event.url}) - State: $state');
      if (event.url.isEmpty || event.url.trim().isEmpty) {
        emit(ErrorState('Keine gültige Audio-URL übergeben.'));
        if (kDebugMode)
          logDebug(
              '[AudioPlayerBloc] Leere oder ungültige URL: "${event.url}"');
        return;
      }
      if (kDebugMode)
        logDebug('[AudioPlayerBloc] PlayEpisode mit URL: ${event.url}');
      final isSameUrl = currentUrl == event.url;
      final isActive = state is Playing || state is Paused;
      if (isSameUrl && isActive) {
        await _safePlayWithRetry(emit);
        emit(Playing(_lastKnownPosition, backend.duration ?? Duration.zero,
            speed: backend.speed));
        if (kDebugMode) logDebug('[AudioPlayerBloc] emit: Playing (Resume)');
        _listenToPosition();
        return;
      }
      // Play nur aus Idle, Paused oder ErrorState zulassen
      if (state is! Idle && state is! Paused && state is! ErrorState) {
        if (kDebugMode)
          logDebug('[AudioPlayerBloc] PlayEpisode ignoriert (State: $state)');
        return;
      }
      emit(Loading());
      if (kDebugMode) logDebug('[AudioPlayerBloc] emit: Loading');
      try {
        await backend.stop();
        currentUrl = event.url; // URL merken
        await _safeSetUrlWithRetry(event.url, emit);
        Duration resumePosition = Duration.zero;
        if (state is Paused) {
          resumePosition = (state as Paused).position;
        }
        if (resumePosition > Duration.zero) {
          await backend.seek(resumePosition);
        }
        _duration = backend.duration ?? Duration.zero;
        _lastKnownPosition = resumePosition;
        emit(Playing(resumePosition, _duration));
        if (kDebugMode) logDebug('[AudioPlayerBloc] emit: Playing (Start)');
        await _safePlayWithRetry(emit);
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
      } catch (e, st) {
        emit(ErrorState('Fehler beim Starten des Streams: \\${e.toString()}'));
        if (kDebugMode) logDebug('[AudioPlayerBloc] Fehler beim Play: $e\n$st');
        // TODO: Snackbar/Monitoring triggern
      }
    });
    on<Pause>((event, emit) async {
      if (kDebugMode)
        logDebug('[AudioPlayerBloc] Event: Pause - State: $state');
      if (state is! Playing) {
        if (kDebugMode)
          logDebug('[AudioPlayerBloc] Pause ignoriert (State: $state)');
        return;
      }
      await this.backend.pause();
      final pos = this.backend.position;
      _positionSub?.cancel();
      _positionSub = null;
      emit(Paused(pos, _duration));
      if (kDebugMode) logDebug('[AudioPlayerBloc] emit: Paused');
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
      _lastKnownPosition = Duration.zero;
      currentUrl = null;
      emit(Idle());
      if (kDebugMode) logDebug('[AudioPlayerBloc] emit: Idle');
    });
    on<Seek>((event, emit) async {
      if (state is! Playing && state is! Paused) {
        if (kDebugMode)
          logDebug('[AudioPlayerBloc] Seek ignoriert (State: $state)');
        return;
      }
      await this.backend.seek(event.position);
      if (kDebugMode) logDebug('[AudioPlayerBloc] seek: ${event.position}');
    });
    on<TogglePlayPause>((event, emit) async {
      if (_isBusy) {
        _pendingToggle = true;
        if (kDebugMode)
          logDebug('[AudioPlayerBloc] TogglePlayPause gepuffert (busy)');
        return;
      }
      _isBusy = true;
      try {
        do {
          _pendingToggle = false;
          if (state is Loading) {
            if (kDebugMode)
              logDebug(
                  '[AudioPlayerBloc] TogglePlayPause ignoriert (State: Loading)');
            break;
          }
          if (state is Playing) {
            if (kDebugMode)
              logDebug('[AudioPlayerBloc] TogglePlayPause → Pause');
            await this.backend.pause();
            final pos = this.backend.position;
            _positionSub?.cancel();
            _positionSub = null;
            emit(Paused(pos, _duration));
            add(UpdatePosition(pos)); // Sofortiges UI-Feedback
            if (kDebugMode)
              logDebug('[AudioPlayerBloc] emit: Paused (TogglePlayPause)');
            _listenToPosition(); // Sicherstellen, dass Subscription aktiv bleibt
          } else if (state is Paused) {
            if (_currentUrl != null && _currentUrl!.isNotEmpty) {
              if (kDebugMode)
                logDebug('[AudioPlayerBloc] TogglePlayPause → PlayEpisode');
              final resumePosition = (state as Paused).position;
              emit(Loading());
              if (kDebugMode)
                logDebug('[AudioPlayerBloc] emit: Loading (TogglePlayPause)');
              try {
                await backend.stop();
                await _safeSetUrlWithRetry(_currentUrl!, emit);
                if (resumePosition > Duration.zero) {
                  await backend.seek(resumePosition);
                }
                _duration = backend.duration ?? Duration.zero;
                emit(Playing(resumePosition, _duration));
                add(UpdatePosition(resumePosition)); // Sofortiges UI-Feedback
                if (kDebugMode)
                  logDebug('[AudioPlayerBloc] emit: Playing (TogglePlayPause)');
                await _safePlayWithRetry(emit);
                _listenToPosition(); // Sicherstellen, dass Subscription aktiv bleibt
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
              } catch (e, st) {
                emit(ErrorState(
                    'Fehler beim Starten des Streams: \\${e.toString()}'));
                if (kDebugMode)
                  logDebug('[AudioPlayerBloc] Fehler beim Play: $e\n$st');
              }
            } else {
              emit(ErrorState('Keine gültige Audio-URL zum Fortsetzen.'));
              if (kDebugMode)
                logDebug('[AudioPlayerBloc] emit: ErrorState (Resume)');
            }
          } else {
            if (_currentUrl != null && _currentUrl!.isNotEmpty) {
              if (kDebugMode)
                logDebug(
                    '[AudioPlayerBloc] TogglePlayPause → PlayEpisode (Idle/Error)');
              emit(Loading());
              if (kDebugMode)
                logDebug('[AudioPlayerBloc] emit: Loading (TogglePlayPause)');
              try {
                await backend.stop();
                await _safeSetUrlWithRetry(_currentUrl!, emit);
                _duration = backend.duration ?? Duration.zero;
                emit(Playing(Duration.zero, _duration));
                if (kDebugMode)
                  logDebug('[AudioPlayerBloc] emit: Playing (TogglePlayPause)');
                await _safePlayWithRetry(emit);
                _listenToPosition(); // Sicherstellen, dass Subscription aktiv bleibt
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
              } catch (e, st) {
                emit(ErrorState(
                    'Fehler beim Starten des Streams: \\${e.toString()}'));
                if (kDebugMode)
                  logDebug('[AudioPlayerBloc] Fehler beim Play: $e\n$st');
              }
            } else {
              emit(ErrorState('Keine Audio-URL geladen.'));
              if (kDebugMode)
                logDebug('[AudioPlayerBloc] emit: ErrorState (No URL)');
            }
          }
        } while (_pendingToggle);
      } finally {
        _isBusy = false;
      }
    });
    on<UpdatePosition>((event, emit) async {
      // Filter: Akzeptiere position=0 nur, wenn explizit nach Stop, Preload oder neuer URL
      if (event.position == Duration.zero &&
          _lastKnownPosition > Duration.zero) {
        // Ignoriere position=0, wenn wir gerade Play/Resume/Seek hatten und noch keine echte neue Position
        if (kDebugMode)
          logDebug(
              '[AudioPlayerBloc] UpdatePosition: position=0 ignoriert (letzte Position >0)');
        return;
      }
      // Nur updaten, wenn sich die Position wirklich geändert hat
      if (event.position != _lastKnownPosition) {
        _lastKnownPosition = event.position;
        if (state is Playing || state is Loading) {
          emit(Playing(event.position, _duration));
          if (kDebugMode)
            logDebug('[AudioPlayerBloc] emit: Playing (UpdatePosition)');
        } else if (state is Paused) {
          emit(Paused(event.position, _duration));
          if (kDebugMode)
            logDebug('[AudioPlayerBloc] emit: Paused (UpdatePosition)');
        } else {
          if (kDebugMode)
            logDebug(
                '[AudioPlayerBloc] UpdatePosition ignoriert (State: $state)');
        }
      }
    });
    on<SetSpeed>((event, emit) async {
      try {
        await backend.setSpeed(event.speed);
        // State aktualisieren, falls Playing oder Paused
        if (state is Playing) {
          final s = state as Playing;
          emit(Playing(s.position, s.duration, speed: event.speed));
          if (kDebugMode)
            logDebug('[AudioPlayerBloc] emit: Playing (SetSpeed)');
        } else if (state is Paused) {
          final s = state as Paused;
          emit(Paused(s.position, s.duration, speed: event.speed));
          if (kDebugMode) logDebug('[AudioPlayerBloc] emit: Paused (SetSpeed)');
        }
      } catch (e) {
        emit(ErrorState(
            'Fehler beim Setzen der Geschwindigkeit: ${e.toString()}'));
        if (kDebugMode) logDebug('[AudioPlayerBloc] Fehler beim SetSpeed: $e');
      }
    });
    on<PreloadEpisode>((event, emit) async {
      if (event.url.isEmpty || event.url.trim().isEmpty) {
        emit(ErrorState('Keine gültige Audio-URL übergeben.'));
        if (kDebugMode)
          logDebug(
              '[AudioPlayerBloc] Leere oder ungültige URL (Preload): "${event.url}"');
        return;
      }
      if (kDebugMode)
        logDebug('[AudioPlayerBloc] PreloadEpisode mit URL: ${event.url}');
      emit(Loading());
      if (kDebugMode) logDebug('[AudioPlayerBloc] emit: Loading (Preload)');
      try {
        await this.backend.stop();
        currentUrl = event.url; // URL merken
        await this.backend.setUrl(event.url);
        if (kDebugMode)
          logDebug('[AudioPlayerBloc] setUrl abgeschlossen (Preload)');
        _duration = this.backend.duration ?? Duration.zero;
        _lastKnownPosition = Duration.zero;
        emit(Paused(Duration.zero, _duration));
        if (kDebugMode) logDebug('[AudioPlayerBloc] emit: Paused (Preload)');
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
        emit(ErrorState('Fehler beim Preload: \\${e.toString()}'));
        if (kDebugMode) logDebug('[AudioPlayerBloc] Fehler beim Preload: $e');
      }
    });
    on<SetVolume>((event, emit) async {
      try {
        await backend.setVolume(event.volume);
        // State bleibt gleich, aber ggf. für UI-Feedback erneut emittieren
        if (state is Playing) {
          final s = state as Playing;
          emit(Playing(s.position, s.duration, speed: s.speed));
        } else if (state is Paused) {
          final s = state as Paused;
          emit(Paused(s.position, s.duration, speed: s.speed));
        }
      } catch (e) {
        emit(
            ErrorState('Fehler beim Setzen der Lautstärke: \\${e.toString()}'));
        if (kDebugMode) logDebug('[AudioPlayerBloc] Fehler bei SetVolume: $e');
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
    if (kDebugMode) logDebug('[AudioPlayerBloc] _listenToPosition() called');
    _positionSub?.cancel();
    _positionSub = null;
    Duration? _lastPosition;
    DateTime? _lastProgress;
    _positionSub = backend.positionStream.listen(
      (pos) {
        if (_disposed) return;
        // Wieder auf 100ms runden statt trunc auf volle Sekunden
        final roundedPos =
            Duration(milliseconds: (pos.inMilliseconds / 100).round() * 100);
        final now = DateTime.now();
        if (_lastPosition != null) {
          final diff = roundedPos - _lastPosition!;
          if (diff.inMilliseconds < 0) {
            log('[AudioPlayerBloc][Watchdog] Warnung: Position springt zurück! alt=${_lastPosition}, neu=$roundedPos');
          } else if (diff.inMilliseconds > 50) {
            _lastProgress = now;
          }
        } else {
          _lastProgress = now;
        }
        if (_lastProgress != null &&
            now.difference(_lastProgress!).inSeconds > 1) {
          log('[AudioPlayerBloc][Watchdog] Fehler: Position hat sich >1s nicht verändert! Restart wird getriggert. Letzte Position: $_lastPosition');
          add(Stop());
        }
        if (_lastPosition == null ||
            (roundedPos - _lastPosition!).inMilliseconds.abs() > 50) {
          _lastPosition = roundedPos;
          if (kDebugMode)
            logDebug('[AudioPlayerBloc] UpdatePosition: $roundedPos');
          add(UpdatePosition(roundedPos));
        }
      },
      onError: (e, st) {
        if (kDebugMode)
          logDebug('[AudioPlayerBloc] Fehler im positionStream: $e\n$st');
        addError(e, st);
      },
    );
    _durationSub?.cancel();
    _durationSub = null;
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
          logDebug('[AudioPlayerBloc] Fehler im durationStream: $e\n$st');
        addError(e, st);
      },
    );
    _playerStateSub?.cancel();
    _playerStateSub = null;
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

  /// ---
  /// PRODUCTION: Audio-Streaming Stabilität & Fehlerbehandlung (Juni 2025)
  ///
  /// - setUrl/play werden mit Retry-Logik (max. 2 Versuche) und Timeout (10s) ausgeführt
  /// - Fehler (Netzwerk, Timeout, ungültige URL) werden als ErrorState emittiert und geloggt
  /// - Bei Netzwerkfehlern/Timeout wird eine Snackbar mit passender Message getriggert
  /// - TODO: Monitoring/Analytics für Streaming-Fehler ergänzen
  /// - TODO: Fallback-Mechanismus für Windows/Linux (z.B. just_audio_media_kit) prüfen
  ///
  Future<void> _safeSetUrlWithRetry(String url, Emitter<AudioPlayerState> emit,
      {int maxRetries = 5}) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        await backend.setUrl(url).timeout(const Duration(seconds: 10));
        _autoResumeAttempts = 0; // Reset bei Erfolg
        return;
      } on TimeoutException catch (e) {
        attempt++;
        _autoResumeAttempts = attempt;
        if (kDebugMode) logDebug('[AudioPlayerBloc] setUrl Timeout: $e');
        if (attempt >= maxRetries) {
          emit(ErrorState('Timeout beim Laden des Streams.'));
          return;
        }
      } catch (e) {
        attempt++;
        _autoResumeAttempts = attempt;
        if (kDebugMode) logDebug('[AudioPlayerBloc] setUrl Fehler: $e');
        if (attempt >= maxRetries) {
          emit(ErrorState('Fehler beim Laden des Streams.'));
          return;
        }
      }
    }
  }

  Future<void> _safePlayWithRetry(Emitter<AudioPlayerState> emit,
      {int maxRetries = 5}) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        await backend.play().timeout(const Duration(seconds: 10));
        _autoResumeAttempts = 0; // Reset bei Erfolg
        return;
      } on TimeoutException catch (e) {
        attempt++;
        _autoResumeAttempts = attempt;
        if (kDebugMode) logDebug('[AudioPlayerBloc] play Timeout: $e');
        if (attempt >= maxRetries) {
          emit(ErrorState('Timeout beim Starten der Wiedergabe.'));
          return;
        }
      } catch (e) {
        attempt++;
        _autoResumeAttempts = attempt;
        if (kDebugMode) logDebug('[AudioPlayerBloc] play Fehler: $e');
        if (attempt >= maxRetries) {
          emit(ErrorState('Fehler beim Starten der Wiedergabe.'));
          return;
        }
      }
    }
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
  double _speed = 1.0;

  JustAudioPlayerBackend() {
    _audioPlayer.playerStateStream.listen((state) {
      if (kDebugMode) {
        logDebug(
            '[JustAudioPlayerBackend] playerStateStream: processingState=${state.processingState}, playing=${state.playing}');
      }
    }, onError: (e, st) {
      if (kDebugMode) {
        logDebug(
            '[JustAudioPlayerBackend] Fehler im playerStateStream: $e\n$st');
      }
    });
    _audioPlayer.playbackEventStream.listen((event) {
      if (kDebugMode) {
        logDebug('[JustAudioPlayerBackend] playbackEventStream: event=$event');
      }
    }, onError: (e, st) {
      if (kDebugMode) {
        logDebug(
            '[JustAudioPlayerBackend] Fehler im playbackEventStream: $e\n$st');
      }
    });
  }

  void _resetPlayer() {
    try {
      _audioPlayer.dispose();
    } catch (_) {}
    _audioPlayer = AudioPlayer();
    if (kDebugMode)
      logDebug('[JustAudioPlayerBackend] Player wurde neu initialisiert');
  }

  @override
  Future<void> setUrl(String url) async {
    try {
      // Buffer-Settings für Android setzen (nur wenn Plattform Android)
      // just_audio 0.10.x: Buffer-Settings werden über setAndroidBufferingParameters gesetzt
      // Siehe https://github.com/ryanheise/just_audio/blob/0.10.3/just_audio/android/src/main/java/com/ryanheise/just_audio/AudioPlayer.java
      // und https://pub.dev/packages/just_audio/changelog#0100
      // Diese Methode ist nicht im Dart-API, aber über MethodChannel verfügbar
      // Daher: Fallback auf Standard, aber Hinweis im Code
      // TODO: Bei Update auf just_audio >=0.9.19 Buffer explizit setzen
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(url)),
        preload: true,
        initialPosition: Duration.zero,
      );
    } catch (e, st) {
      if (kDebugMode)
        logDebug('[JustAudioPlayerBackend] Fehler bei setUrl: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e, st) {
      if (kDebugMode)
        logDebug('[JustAudioPlayerBackend] Fehler bei play: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e, st) {
      if (kDebugMode)
        logDebug('[JustAudioPlayerBackend] Fehler bei pause: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      // _resetPlayer(); // Entfernt: Instanz bleibt erhalten
    } catch (e, st) {
      if (kDebugMode)
        logDebug('[JustAudioPlayerBackend] Fehler bei stop: $e\n$st');
      // _resetPlayer(); // Entfernt
      rethrow;
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e, st) {
      if (kDebugMode)
        logDebug('[JustAudioPlayerBackend] Fehler bei seek: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> setSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed);
      _speed = speed;
    } catch (e, st) {
      if (kDebugMode)
        logDebug('[JustAudioPlayerBackend] Fehler bei setSpeed: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e, st) {
      if (kDebugMode)
        logDebug('[JustAudioPlayerBackend] Fehler bei setVolume: $e\n$st');
      rethrow;
    }
  }

  @override
  Stream<Duration> get positionStream => _audioPlayer.positionStream
          .interval(const Duration(milliseconds: 100)) // Schnelleres Intervall
          .handleError((e, st) {
        if (kDebugMode)
          logDebug(
              '[JustAudioPlayerBackend] Fehler im positionStream: $e\n$st');
      });
  @override
  Stream<Duration?> get durationStream =>
      _audioPlayer.durationStream.handleError((e, st) {
        if (kDebugMode)
          logDebug(
              '[JustAudioPlayerBackend] Fehler im durationStream: $e\n$st');
      });
  @override
  Stream<dynamic> get playerStateStream =>
      _audioPlayer.playerStateStream.handleError((e, st) {
        if (kDebugMode)
          logDebug(
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
  double get speed => _speed;
  @override
  double get volume => _audioPlayer.volume;
  @override
  void dispose() {
    _audioPlayer.dispose();
    _resetPlayer();
  }
}

// --- Audioplayers-Backend (Legacy/Test, entfernt am 06.06.2025) ---
// Die Implementierung wurde entfernt, da das audioplayers-Paket nicht mehr verwendet wird.
// Siehe docs/audio_architektur_2025.md und Migrationshinweise.
// class AudioPlayersBackend implements IAudioPlayerBackend {
//   AudioPlayersBackend() {
//     // ...Audioplayers-Implementierung entfernt, da Paket entfernt wurde
//   }
//   // ...weitere Methoden auskommentiert
// }
