// AudioPlayerSyncService: Zentrale Synchronisation von Backend und UI für Speed, Volume, Position, Duration, State, Error
// Siehe Doku: .documents/audio_player_best_practices_2025.md

import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'i_audio_player.dart';

class AudioPlayerSyncService implements IAudioPlayerBackend {
  final AudioPlayer audioPlayer;

  // --- Speed ---
  double speedValue = 1.0;
  final speedController = StreamController<double>.broadcast();
  @override
  double get speed => speedValue;
  @override
  Stream<double> get speedStream => speedController.stream;

  // --- Volume ---
  double volumeValue = 0.5;
  final volumeController = StreamController<double>.broadcast();
  @override
  double get volume => volumeValue;
  @override
  Stream<double> get volumeStream => volumeController.stream;

  // --- Position ---
  Duration positionValue = Duration.zero;
  final positionController = StreamController<Duration>.broadcast();
  @override
  Duration get position => positionValue;
  @override
  Stream<Duration> get positionStream => positionController.stream;

  // --- Duration ---
  Duration? durationValue;
  final durationController = StreamController<Duration?>.broadcast();
  @override
  Duration? get duration => durationValue;
  @override
  Stream<Duration?> get durationStream => durationController.stream;

  // --- Player State ---
  final playerStateController = StreamController<dynamic>.broadcast();
  @override
  Stream<dynamic> get playerStateStream => playerStateController.stream;
  @override
  bool get playing => audioPlayer.playing;

  // --- Konstruktor: Streams abonnieren ---
  AudioPlayerSyncService({AudioPlayer? audioPlayer})
      : audioPlayer = audioPlayer ?? AudioPlayer() {
    this.audioPlayer.speedStream.listen((s) {
      speedValue = s;
      speedController.add(s);
    });
    this.audioPlayer.volumeStream.listen((v) {
      volumeValue = v;
      volumeController.add(v);
    });
    this.audioPlayer.positionStream.listen((p) {
      positionValue = p;
      positionController.add(p);
    });
    this.audioPlayer.durationStream.listen((d) {
      durationValue = d;
      durationController.add(d);
    });
    this.audioPlayer.playerStateStream.listen((state) {
      playerStateController.add(state);
    });
  }

  // --- Backend-Methoden ---
  @override
  Future<void> setUrl(String url) => audioPlayer.setUrl(url);
  @override
  Future<void> play() => audioPlayer.play();
  @override
  Future<void> pause() => audioPlayer.pause();
  @override
  Future<void> stop() => audioPlayer.stop();
  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
    positionValue = position;
    positionController.add(position);
  }

  @override
  Future<void> setSpeed(double speed) async {
    await audioPlayer.setSpeed(speed);
    speedValue = speed;
    speedController.add(speed);
  }

  @override
  Future<void> setVolume(double volume) async {
    await audioPlayer.setVolume(volume);
    volumeValue = volume;
    volumeController.add(volume);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    speedController.close();
    volumeController.close();
    positionController.close();
    durationController.close();
    playerStateController.close();
  }
}
