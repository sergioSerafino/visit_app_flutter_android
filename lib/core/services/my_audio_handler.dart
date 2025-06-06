import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

/// MyAudioHandler: Kapselt just_audio für audio_service (Background, Systemintegration)
class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  MyAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Streams und Status-Weiterleitung (z.B. playbackState) hier einrichten
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  // Beispiel für Queue/Shuffle/Repeat (optional, für Podcasts meist nicht nötig)
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
    if (mode == AudioServiceRepeatMode.one)
      loopMode = LoopMode.one;
    else if (mode == AudioServiceRepeatMode.all)
      loopMode = LoopMode.all;
    else
      loopMode = LoopMode.off;
    _player.setLoopMode(loopMode);
    return super.setRepeatMode(mode);
  }
}
