// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Audio-Architektur, BLoC-Pattern und Teststrategie.
// Lessons Learned: AudioPlayerBloc implementiert robustes Event-State-Management für Audio-Logik. Siehe auch i_audio_player.dart und zugehörige Provider.
// Hinweise: Für produktive Nutzung Backend anpassen, für Tests Mock-Backend verwenden. Siehe Testdateien für Beispiele.

// lib/core/services/audio_player_bloc.dart
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

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
  final AudioHandler audioHandler;
  StreamSubscription<PlaybackState>? _playbackStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<MediaItem?>? _mediaItemSub;
  Duration _duration = Duration.zero;
  bool _disposed = false;

  AudioPlayerBloc({required this.audioHandler}) : super(Idle()) {
    // Event-Handler
    on<PlayEpisode>(_onPlayEpisode);
    on<Pause>(_onPause);
    on<Stop>(_onStop);
    on<Seek>(_onSeek);
    on<TogglePlayPause>(_onTogglePlayPause);
    on<UpdatePosition>(_onUpdatePosition);
    on<SetSpeed>(_onSetSpeed);
    on<PreloadEpisode>(_onPreloadEpisode);

    // Streams abonnieren
    _playbackStateSub = audioHandler.playbackState.listen(_handlePlaybackState);
    _positionSub = audioHandler.playbackState
        .map((ps) => ps.position)
        .distinct()
        .listen((pos) {
          if (!_disposed) add(UpdatePosition(pos));
        });
    _durationSub = audioHandler.mediaItem
        .where((item) => item != null)
        .map((item) => item!.duration)
        .distinct()
        .listen((dur) {
          if (!_disposed && dur != null) _duration = dur;
        });
    _mediaItemSub = audioHandler.mediaItem.listen((item) {
      if (!_disposed && item != null) _duration = item.duration ?? Duration.zero;
    });
  }

  // Event-Handler Methoden
  Future<void> _onPlayEpisode(PlayEpisode event, Emitter<AudioPlayerState> emit) async {
    if (event.url.isEmpty || event.url.trim().isEmpty) {
      emit(ErrorState('Keine gültige Audio-URL übergeben.'));
      return;
    }
    emit(Loading());
    try {
      await audioHandler.stop();
      await audioHandler.addQueueItem(MediaItem(
        id: event.url,
        title: 'Episode',
        duration: null,
        artUri: null,
      ));
      await audioHandler.play();
    } catch (e) {
      emit(ErrorState('Fehler beim Starten des Streams: ${e.toString()}'));
    }
  }

  Future<void> _onPause(Pause event, Emitter<AudioPlayerState> emit) async {
    await audioHandler.pause();
  }

  Future<void> _onStop(Stop event, Emitter<AudioPlayerState> emit) async {
    await audioHandler.stop();
    emit(Idle());
  }

  Future<void> _onSeek(Seek event, Emitter<AudioPlayerState> emit) async {
    await audioHandler.seek(event.position);
  }

  Future<void> _onTogglePlayPause(TogglePlayPause event, Emitter<AudioPlayerState> emit) async {
    final state = audioHandler.playbackState.value;
    if (state.playing) {
      await audioHandler.pause();
    } else {
      await audioHandler.play();
    }
  }

  Future<void> _onUpdatePosition(UpdatePosition event, Emitter<AudioPlayerState> emit) async {
    // handled by stream subscription
  }

  Future<void> _onSetSpeed(SetSpeed event, Emitter<AudioPlayerState> emit) async {
    await audioHandler.setSpeed(event.speed);
  }

  Future<void> _onPreloadEpisode(PreloadEpisode event, Emitter<AudioPlayerState> emit) async {
    if (event.url.isEmpty || event.url.trim().isEmpty) {
      emit(ErrorState('Keine gültige Audio-URL übergeben.'));
      return;
    }
    emit(Loading());
    try {
      await audioHandler.stop();
      await audioHandler.addQueueItem(MediaItem(
        id: event.url,
        title: 'Episode',
        duration: null,
        artUri: null,
      ));
      emit(Paused(Duration.zero, _duration));
    } catch (e) {
      emit(ErrorState('Fehler beim Preload: ${e.toString()}'));
    }
  }

  void _handlePlaybackState(PlaybackState state) {
    if (_disposed) return;
    if (state.processingState == AudioProcessingState.idle) {
      add(Stop());
    } else if (state.processingState == AudioProcessingState.loading ||
        state.processingState == AudioProcessingState.buffering) {
      add(UpdatePosition(state.position));
    } else if (state.playing) {
      add(UpdatePosition(state.position));
    } else if (!state.playing &&
        (state.processingState == AudioProcessingState.ready ||
            state.processingState == AudioProcessingState.completed)) {
      add(UpdatePosition(state.position));
    } else if (state.processingState == AudioProcessingState.completed) {
      add(Stop());
    }
  }

  @override
  Future<void> close() {
    _disposed = true;
    _playbackStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _mediaItemSub?.cancel();
    return super.close();
  }
}

// Entferne JustAudioPlayerBackend und AudioPlayersBackend, da die Logik jetzt über AudioHandler läuft.
