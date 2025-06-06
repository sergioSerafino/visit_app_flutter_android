import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'dart:async';
import 'package:audio_service/audio_service.dart';

class MockAudioHandler extends Mock implements AudioHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });
  group('AudioPlayerBloc', () {
    late MockAudioHandler handler;
    setUp(() {
      handler = MockAudioHandler();
      when(() => handler.playbackState)
          .thenAnswer((_) => const Stream<PlaybackState>.empty());
      when(() => handler.mediaItem)
          .thenAnswer((_) => const Stream<MediaItem?>.empty());
      when(() => handler.play()).thenAnswer((_) async {});
      when(() => handler.pause()).thenAnswer((_) async {});
      when(() => handler.stop()).thenAnswer((_) async {});
      when(() => handler.seek(any())).thenAnswer((_) async {});
      when(() => handler.setSpeed(any())).thenAnswer((_) async {});
      when(() => handler.addQueueItem(any())).thenAnswer((_) async {});
    });
    test('Initialzustand ist Idle', () {
      final bloc = AudioPlayerBloc(audioHandler: handler);
      expect(bloc.state, isA<Idle>());
    });
    test('PlayEpisode führt zu Loading und dann Playing', () async {
      when(() => handler.setUrl(any())).thenAnswer((_) async {});
      when(() => handler.play()).thenAnswer((_) async {});
      final bloc = AudioPlayerBloc(audioHandler: handler);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(PlayEpisode('https://audio/test.mp3'));
      await Future.delayed(Duration(milliseconds: 50));
      expect(states.first, isA<Loading>());
      expect(states.last, isA<Playing>());
      await sub.cancel();
    });
    test('Pause aus Playing führt zu Paused', () async {
      when(() => handler.pause()).thenAnswer((_) async {});
      final bloc = AudioPlayerBloc(audioHandler: handler);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.emit(Playing(Duration(seconds: 10), Duration(seconds: 30)));
      bloc.add(Pause());
      await Future.delayed(Duration(milliseconds: 50));
      expect(states.last, isA<Paused>());
      await sub.cancel();
    });
    test('Stop führt zu Idle', () async {
      when(() => handler.stop()).thenAnswer((_) async {});
      final bloc = AudioPlayerBloc(audioHandler: handler);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.emit(Playing(Duration(seconds: 5), Duration(seconds: 30)));
      bloc.add(Stop());
      await Future.delayed(Duration(milliseconds: 50));
      expect(states.last, isA<Idle>());
      await sub.cancel();
    });
    test('SetSpeed ändert die Geschwindigkeit im Backend und State', () async {
      when(() => handler.setSpeed(any())).thenAnswer((invocation) async {
        // Simuliere das Setzen der Geschwindigkeit
      });
      when(() => handler.speed).thenReturn(1.5);
      final bloc = AudioPlayerBloc(audioHandler: handler);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      // Starte mit Playing-State
      bloc.emit(
          Playing(Duration(seconds: 0), Duration(seconds: 30), speed: 1.0));
      bloc.add(SetSpeed(1.5));
      await Future.delayed(Duration(milliseconds: 50));
      // Prüfe, ob der letzte State die neue Geschwindigkeit enthält
      final last = states.last;
      expect(last, isA<Playing>());
      expect((last as Playing).speed, 1.5);
      await sub.cancel();
    });
  });
}
