import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'package:empty_flutter_template/core/services/i_audio_player.dart';
import 'dart:async';

class MockAudioPlayerBackend extends Mock implements IAudioPlayerBackend {}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });
  group('AudioPlayerBloc', () {
    late MockAudioPlayerBackend backend;
    setUp(() {
      backend = MockAudioPlayerBackend();
      when(() => backend.positionStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => backend.durationStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => backend.playerStateStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => backend.position).thenReturn(Duration.zero);
      when(() => backend.duration).thenReturn(Duration(seconds: 30));
      when(() => backend.playing).thenReturn(true);
      when(() => backend.dispose()).thenReturn(null);
      when(() => backend.setUrl(any())).thenAnswer((_) async {});
      when(() => backend.play()).thenAnswer((_) async {});
      when(() => backend.pause()).thenAnswer((_) async {});
      when(() => backend.stop()).thenAnswer((_) async {});
      when(() => backend.seek(any())).thenAnswer((_) async {});
    });
    test('Initialzustand ist Idle', () {
      final bloc = AudioPlayerBloc(backend: backend);
      expect(bloc.state, isA<Idle>());
    });
    test('PlayEpisode führt zu Loading und dann Playing', () async {
      when(() => backend.setUrl(any())).thenAnswer((_) async {});
      when(() => backend.play()).thenAnswer((_) async {});
      final bloc = AudioPlayerBloc(backend: backend);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(PlayEpisode('https://audio/test.mp3'));
      await Future.delayed(Duration(milliseconds: 50));
      expect(states.first, isA<Loading>());
      expect(states.last, isA<Playing>());
      await sub.cancel();
    });
    test('Pause aus Playing führt zu Paused', () async {
      when(() => backend.pause()).thenAnswer((_) async {});
      final bloc = AudioPlayerBloc(backend: backend);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.emit(Playing(Duration(seconds: 10), Duration(seconds: 30)));
      bloc.add(Pause());
      await Future.delayed(Duration(milliseconds: 50));
      expect(states.last, isA<Paused>());
      await sub.cancel();
    });
    test('Stop führt zu Idle', () async {
      when(() => backend.stop()).thenAnswer((_) async {});
      final bloc = AudioPlayerBloc(backend: backend);
      final states = <AudioPlayerState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.emit(Playing(Duration(seconds: 5), Duration(seconds: 30)));
      bloc.add(Stop());
      await Future.delayed(Duration(milliseconds: 50));
      expect(states.last, isA<Idle>());
      await sub.cancel();
    });
  });
}
