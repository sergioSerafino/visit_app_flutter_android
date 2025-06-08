// AudioPlayerSyncService: Zentrale Synchronisation von Backend und UI für Speed, Volume, Position, Duration, State, Error
// Siehe Doku: .documents/audio_player_best_practices_2025.md

import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'i_audio_player.dart';

class AudioPlayerSyncService implements IAudioPlayerBackend {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // --- Speed ---
  double _speed = 1.0;
  final _speedController = StreamController<double>.broadcast();
  @override
  double get speed => _speed;
  @override
  Stream<double> get speedStream => _speedController.stream;

  // --- Volume ---
  double _volume = 0.5;
  final _volumeController = StreamController<double>.broadcast();
  @override
  double get volume => _volume;
  @override
  Stream<double> get volumeStream => _volumeController.stream;

  // --- Position ---
  Duration _position = Duration.zero;
  final _positionController = StreamController<Duration>.broadcast();
  @override
  Duration get position => _position;
  @override
  Stream<Duration> get positionStream => _positionController.stream;

  // --- Duration ---
  Duration? _duration;
  final _durationController = StreamController<Duration?>.broadcast();
  @override
  Duration? get duration => _duration;
  @override
  Stream<Duration?> get durationStream => _durationController.stream;

  // --- Player State ---
  final _playerStateController = StreamController<dynamic>.broadcast();
  @override
  Stream<dynamic> get playerStateStream => _playerStateController.stream;
  @override
  bool get playing => _audioPlayer.playing;

  // --- Konstruktor: Streams abonnieren ---
  AudioPlayerSyncService() {
    _audioPlayer.speedStream.listen((s) {
      _speed = s;
      _speedController.add(s);
    });
    _audioPlayer.volumeStream.listen((v) {
      _volume = v;
      _volumeController.add(v);
    });
    _audioPlayer.positionStream.listen((p) {
      _position = p;
      _positionController.add(p);
    });
    _audioPlayer.durationStream.listen((d) {
      _duration = d;
      _durationController.add(d);
    });
    _audioPlayer.playerStateStream.listen((state) {
      _playerStateController.add(state);
    });
  }

  // --- Backend-Methoden ---
  @override
  Future<void> setUrl(String url) => _audioPlayer.setUrl(url);
  @override
  Future<void> play() => _audioPlayer.play();
  @override
  Future<void> pause() => _audioPlayer.pause();
  @override
  Future<void> stop() => _audioPlayer.stop();
  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    _position = position;
    _positionController.add(position);
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
    _speed = speed;
    _speedController.add(speed);
  }

  @override
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
    _volume = volume;
    _volumeController.add(volume);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _speedController.close();
    _volumeController.close();
    _positionController.close();
    _durationController.close();
    _playerStateController.close();
  }
}
