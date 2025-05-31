// Interface für AudioPlayer-Backend (Clean Architecture)
abstract class IAudioPlayerBackend {
  Future<void> setUrl(String url);
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
  Stream<dynamic> get playerStateStream;
  Duration get position;
  Duration? get duration;
  bool get playing;
  void dispose();
}
