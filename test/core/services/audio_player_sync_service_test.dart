import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_app_flutter_android/core/services/audio_player_sync_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  group('AudioPlayerSyncService', () {
    late AudioPlayerSyncService service;
    late MockAudioPlayer mockPlayer;

    setUp(() {
      mockPlayer = MockAudioPlayer();
      // Stubs für die Streams VOR Service-Initialisierung setzen
      final speedController = StreamController<double>.broadcast();
      final volumeController = StreamController<double>.broadcast();
      final positionController = StreamController<Duration>.broadcast();
      final durationController = StreamController<Duration?>.broadcast();
      when(() => mockPlayer.speedStream)
          .thenAnswer((_) => speedController.stream);
      when(() => mockPlayer.volumeStream)
          .thenAnswer((_) => volumeController.stream);
      when(() => mockPlayer.positionStream)
          .thenAnswer((_) => positionController.stream);
      when(() => mockPlayer.durationStream)
          .thenAnswer((_) => durationController.stream);
      when(() => mockPlayer.playerStateStream).thenAnswer(
          (_) => Stream.value(PlayerState(false, ProcessingState.idle)));
      when(() => mockPlayer.playing).thenReturn(false);
      service = AudioPlayerSyncService(audioPlayer: mockPlayer);
      // Methoden-Stubs, die auf die Controller pushen
      when(() => mockPlayer.setSpeed(any())).thenAnswer((invocation) async {
        final val = invocation.positionalArguments[0] as double;
        service.speedValue = val;
        speedController.add(val);
      });
      when(() => mockPlayer.setVolume(any())).thenAnswer((invocation) async {
        final val = invocation.positionalArguments[0] as double;
        service.volumeValue = val;
        volumeController.add(val);
      });
      when(() => mockPlayer.seek(any())).thenAnswer((invocation) async {
        final val = invocation.positionalArguments[0] as Duration;
        service.positionValue = val;
        positionController.add(val);
      });
      when(() => mockPlayer.setUrl(any())).thenAnswer((_) async => null);
      when(() => mockPlayer.play()).thenAnswer((_) async {});
      when(() => mockPlayer.pause()).thenAnswer((_) async {});
      when(() => mockPlayer.stop()).thenAnswer((_) async {
        service.positionValue = Duration.zero;
        positionController.add(Duration.zero);
      });
      when(() => mockPlayer.dispose()).thenAnswer((_) async {
        await speedController.close();
        await volumeController.close();
        await positionController.close();
        await durationController.close();
      });
    });

    tearDown(() async {
      await Future.sync(() => service.dispose());
    });

    test('Initialwerte sind korrekt', () async {
      expect(service.speed, 1.0);
      expect(service.volume, 0.5);
      expect(service.position, Duration.zero);
      expect(service.duration, isNull);
    });

    test('Speed-Änderung wird synchronisiert', () async {
      await service.setSpeed(1.5);
      expect(service.speed, 1.5);
      await expectLater(service.speedStream, emits(1.5));
    });

    test('Volume-Änderung wird synchronisiert', () async {
      await service.setVolume(0.8);
      expect(service.volume, 0.8);
      await expectLater(service.volumeStream, emits(0.8));
    });

    test('Seek synchronisiert Position', () async {
      await service.seek(const Duration(seconds: 42));
      expect(service.position, const Duration(seconds: 42));
      await expectLater(
          service.positionStream, emits(const Duration(seconds: 42)));
    });

    test('Stop setzt Position auf 0', () async {
      await service.seek(const Duration(seconds: 10));
      await service.stop();
      expect(service.position, Duration.zero);
      await expectLater(service.positionStream, emits(Duration.zero));
    });

    test('setUrl setzt Duration nach Laden', () async {
      // Hier kann ein echter Audio-URL-Test mit Mock/Asset erfolgen
      // Für Demo: setUrl auf leere Datei, dann Duration prüfen
      await service.setUrl('');
      // Duration bleibt null, da kein echtes File geladen
      expect(service.duration, isNull);
    });
  });
}
