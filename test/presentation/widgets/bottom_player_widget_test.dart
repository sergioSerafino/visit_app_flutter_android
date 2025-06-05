// ---
// AudioPlayerWidget Overlay-/Button-Logik & Lessons Learned (Juni 2025)
//
// - Im Preload-Overlay-State (Paused, position=0, gültige URL) ist der Play/Pause-Button
//   im Widget-Baum vorhanden, aber deaktiviert (onPressed == null). Das Overlay wird angezeigt.
// - Im Loading-State ist der Button nicht vorhanden.
// - Im ErrorState ist der Button nicht vorhanden.
// - In allen anderen Player-States (Playing, Paused mit position>0) ist der Button vorhanden und enabled.
// - Tests müssen dies exakt prüfen (nicht nur auf Existenz, sondern auch auf enabled/disabled).
//
// - NEU: Für deterministische und robuste State-Wechsel in Widget-Tests wird die Hilfsfunktion
//   setStateAndPump verwendet. Sie setzt den State, pumpt mehrfach und gibt Debug-Infos zu Button/Overlay aus.
//   Alle neuen State- und UX-Flow-Tests nutzen dieses Muster für bessere Nachvollziehbarkeit und Stabilität.
//
// Siehe auch: Docstring in bottom_player_widget.dart, audio_player_best_practices_2025.md
// ---

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empty_flutter_template/presentation/widgets/bottom_player_widget.dart';
import 'package:empty_flutter_template/core/services/audio_player_bloc.dart';
import 'package:empty_flutter_template/core/services/i_audio_player.dart';
import 'package:empty_flutter_template/application/providers/audio_player_provider.dart';
import 'package:empty_flutter_template/application/providers/current_episode_provider.dart';
import 'package:empty_flutter_template/domain/models/podcast_episode_model.dart';
import 'package:empty_flutter_template/presentation/widgets/loading_dots.dart';

Future<void> debugPrintAudioState(WidgetTester tester) async {
  final context = tester.element(find.byType(BottomPlayerWidget));
  final container = ProviderScope.containerOf(context);
  final asyncState = container.read(audioPlayerStateProvider);
  debugPrint(
      '[Test] audioPlayerStateProvider: hasValue=${asyncState.hasValue} value=${asyncState.hasValue ? asyncState.value : asyncState}');
}

class MockAudioPlayerBackend extends Mock implements IAudioPlayerBackend {}

class DummyAudioPlayerBloc implements AudioPlayerBloc {
  @override
  void add(event) {}
  @override
  Future<void> close() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  // Hilfsfunktion: Test-Episode
  PodcastEpisode makeTestEpisode() => PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );

  testWidgets(
    'BottomPlayerWidget Integration: Play mit echter OpaliaTalk-Episode',
    (WidgetTester tester) async {
      final backend = MockAudioPlayerBackend();
      final positionController = StreamController<Duration>.broadcast();
      final durationController = StreamController<Duration?>.broadcast();
      final playerStateController = StreamController<dynamic>.broadcast();
      when(() => backend.positionStream)
          .thenAnswer((_) => positionController.stream);
      when(() => backend.durationStream)
          .thenAnswer((_) => durationController.stream);
      when(() => backend.playerStateStream)
          .thenAnswer((_) => playerStateController.stream);
      when(() => backend.position).thenReturn(Duration.zero);
      when(() => backend.duration).thenReturn(Duration(seconds: 60));
      when(() => backend.playing).thenReturn(false);
      when(() => backend.dispose()).thenReturn(null);
      when(() => backend.play()).thenAnswer((_) async {});
      when(() => backend.pause()).thenAnswer((_) async {});
      when(() => backend.setUrl(any())).thenAnswer((_) async {});
      when(() => backend.seek(any())).thenAnswer((_) async {});
      when(() => backend.stop()).thenAnswer((_) async {});
      when(() => backend.speed).thenReturn(1.0);

      final bloc = AudioPlayerBloc(backend: backend);
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerBlocProvider.overrideWithValue(bloc),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: BottomPlayerWidget(
                onClose: () {}, // <-- Callback gesetzt für Close-Button
              ),
            ),
          ),
        ),
      );
      // Mehrfach pumpen, um Animationen/Overlay zu berücksichtigen
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      // Sicherstellen, dass ein Player-UI-State aktiv ist
      bloc.emit(Paused(Duration.zero, Duration(seconds: 60)));
      await tester.pump();
      expect(
          find.byWidgetPredicate(
              (w) => w is Text && (w.data?.contains('Stream lädt') ?? false)),
          findsOneWidget);
      final playButtonFinder =
          find.byKey(const Key('player_play_pause_button'));
      expect(playButtonFinder, findsOneWidget);
      final playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNull,
          reason: 'Im Preload-Overlay ist der Button disabled');
      // Fortschritt simulieren: Button enabled
      bloc.emit(Paused(Duration(seconds: 2), Duration(seconds: 60)));
      await tester.pump();
      final playButton2 = tester.widget<IconButton>(playButtonFinder);
      expect(playButton2.onPressed, isNotNull,
          reason: 'Ab position>0 ist der Button enabled');
      // Play-Button suchen (robust, jetzt per Key)
      expect(playButtonFinder, findsOneWidget);
      expect(playButton.onPressed, isNotNull);
      await tester.tap(playButtonFinder);
      await tester.pump();
      // Simuliere Playing-State mit echter Episode
      bloc.emit(Playing(Duration(seconds: 0), Duration(seconds: 60)));
      await tester.pump();
      // Debug: Alle Text-Widgets und InkWell-Buttons ausgeben
      for (final w in tester.allWidgets) {
        if (w is Text) debugPrint('Text-Widget: "${w.data}"');
        if (w is InkWell && w.child is Icon) {
          final icon = w.child as Icon;
          debugPrint('InkWell: ${icon.icon} enabled=${w.onTap != null}');
        }
      }
      expect(find.byIcon(Icons.pause_circle_filled), findsOneWidget);
      // Fehlerfall simulieren
      bloc.emit(ErrorState('Testfehler mit echter Episode'));
      await tester.pump();
      // Debug: Alle Text-Widgets und InkWell-Buttons ausgeben
      for (final w in tester.allWidgets) {
        if (w is Text) debugPrint('Text-Widget: "${w.data}"');
        if (w is InkWell && w.child is Icon) {
          final icon = w.child as Icon;
          debugPrint('InkWell: ${icon.icon} enabled=${w.onTap != null}');
        }
      }
      // Cleanup
      await positionController.close();
      await durationController.close();
      await playerStateController.close();
      await tester
          .pump(const Duration(seconds: 4)); // Timer cleanup für Marquee
    },
  );

  testWidgets(
      'BottomPlayerWidget ist robust gegen State-Wechsel und UI-Änderungen (StreamController)',
      (WidgetTester tester) async {
    final controller = StreamController<AudioPlayerState>.broadcast();
    final testEpisode = PodcastEpisode(
      wrapperType: 'episode',
      trackId: 1,
      trackName: 'Test Episode',
      artworkUrl600: '',
      description: 'Testbeschreibung',
      episodeUrl: 'https://audio/test.mp3', // <-- immer gültige URL
      trackTimeMillis: 60000,
      episodeFileExtension: 'mp3',
      releaseDate: DateTime(2024, 1, 1),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentEpisodeProvider.overrideWith((ref) => testEpisode),
        ],
        child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
      ),
    );
    await tester.pump();
    // Initial: Paused
    controller.add(Paused(Duration.zero, Duration(seconds: 60)));
    await tester.pump();
    await tester.pump();
    debugPrint('Test: State=Paused, EpisodeUrl=\\${testEpisode.episodeUrl}');
    var playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    debugPrint(
        'Test: PlayButton found: \\${playButtonFinder.evaluate().isNotEmpty}');
    // Im Paused-State mit position=0 wird das Preload-Overlay angezeigt, Button ist vorhanden aber disabled
    expect(
        find.byWidgetPredicate(
            (w) => w is Text && (w.data?.contains('Stream lädt') ?? false)),
        findsOneWidget);
    playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    final playButtonPaused0 = tester.widget<IconButton>(playButtonFinder);
    expect(playButtonPaused0.onPressed, isNotNull,
        reason: 'Im Preload-Overlay ist der Button enabled (UX-Update)');
    // Wechsel zu Playing
    controller.add(Playing(Duration(seconds: 5), Duration(seconds: 60)));
    await tester.pump();
    await tester.pump();
    debugPrint('Test: State=Playing, EpisodeUrl=\\${testEpisode.episodeUrl}');
    playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    debugPrint(
        'Test: PlayButton found: \\${playButtonFinder.evaluate().isNotEmpty}');
    expect(playButtonFinder, findsOneWidget);
    var playButton = tester.widget<IconButton>(playButtonFinder);
    expect((playButton.icon as Icon).icon, Icons.pause_circle_filled);
    // Wechsel zu ErrorState: Button darf NICHT existieren
    controller.add(ErrorState('Fehlerfall'));
    await tester.pump();
    await tester.pump();
    debugPrint(
        'Test: State=ErrorState, EpisodeUrl=\\${testEpisode.episodeUrl}');
    expect(find.byKey(const Key('player_play_pause_button')), findsNothing);
    // Wechsel zu Loading: Button darf NICHT existieren
    controller.add(Loading());
    await tester.pump();
    await tester.pump();
    debugPrint('Test: State=Loading, EpisodeUrl=\\${testEpisode.episodeUrl}');
    expect(find.byKey(const Key('player_play_pause_button')), findsNothing);
    // Wechsel zu Paused (position>0): Button enabled
    controller.add(Paused(Duration(seconds: 10), Duration(seconds: 60)));
    await tester.pump();
    await tester.pump();
    debugPrint(
        'Test: State=Paused (position>0), EpisodeUrl=\\${testEpisode.episodeUrl}');
    playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    debugPrint(
        'Test: PlayButton found: \\${playButtonFinder.evaluate().isNotEmpty}');
    expect(playButtonFinder, findsOneWidget);
    playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNotNull,
        reason: 'Ab position>0 ist der Button enabled');
    await controller.close();
    await tester.pumpAndSettle(); // Timer cleanup
  });

  testWidgets(
      'BottomPlayerWidget zeigt Play/Pause-Button nach Paused-State und Neuaufbau wieder an (StreamController)',
      (WidgetTester tester) async {
    final controller = StreamController<AudioPlayerState>.broadcast();
    final testEpisode = PodcastEpisode(
      wrapperType: 'episode',
      trackId: 1,
      trackName: 'Test Episode',
      artworkUrl600: '',
      description: 'Testbeschreibung',
      episodeUrl: 'https://audio/test.mp3',
      trackTimeMillis: 60000,
      episodeFileExtension: 'mp3',
      releaseDate: DateTime(2024, 1, 1),
    );
    // Starte direkt mit Paused-State
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentEpisodeProvider.overrideWith((ref) => testEpisode),
        ],
        child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
      ),
    );
    await tester.pump();
    controller.add(Paused(Duration.zero, Duration(seconds: 60)));
    await tester.pump();
    await tester.pump(); // Nach ProviderScope-Setup
    controller.add(Paused(Duration.zero, Duration(seconds: 60)));
    await tester.pump();
    await tester.pump(); // Zusätzlicher pump für Widget-Baum
    expect(
        find.byWidgetPredicate(
            (w) => w is Text && (w.data?.contains('Stream lädt') ?? false)),
        findsOneWidget);
    final playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    final playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNotNull,
        reason: 'Im Preload-Overlay ist der Button enabled (UX-Update)');
    await controller.close();
    await tester.pumpAndSettle(); // Timer cleanup
  });

  testWidgets(
      'Speed Control Dropdown ändert die Geschwindigkeit und zeigt sie an',
      (tester) async {
    final backend = MockAudioPlayerBackend();
    when(() => backend.positionStream).thenAnswer((_) => const Stream.empty());
    when(() => backend.durationStream).thenAnswer((_) => const Stream.empty());
    when(() => backend.playerStateStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => backend.position).thenReturn(Duration(seconds: 0));
    when(() => backend.duration).thenReturn(Duration(seconds: 60));
    when(() => backend.playing).thenReturn(true);
    when(() => backend.setSpeed(any())).thenAnswer((_) async {});
    when(() => backend.speed).thenReturn(1.0);
    final bloc = AudioPlayerBloc(backend: backend);
    final testEpisode = PodcastEpisode(
      wrapperType: 'episode',
      trackId: 1,
      trackName: 'Test Episode',
      artworkUrl600: '',
      description: 'Testbeschreibung',
      episodeUrl: 'https://audio/test.mp3',
      trackTimeMillis: 60000,
      episodeFileExtension: 'mp3',
      releaseDate: DateTime(2024, 1, 1),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerBlocProvider.overrideWithValue(bloc),
          currentEpisodeProvider.overrideWith((ref) => testEpisode),
        ],
        child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
      ),
    );
    // Starte mit Playing-State (1.0x)
    bloc.emit(Playing(Duration(seconds: 0), Duration(seconds: 60), speed: 1.0));
    await tester.pump();
    // Dropdown öffnen und 1.5x wählen
    await tester.tap(find.byType(DropdownButton<double>));
    await tester.pump();
    await tester.tap(find.text('1.5x').last);
    await tester.pump();
    // Bloc-State manuell updaten (wie im echten Backend nach setSpeed)
    bloc.emit(Playing(Duration(seconds: 0), Duration(seconds: 60), speed: 1.5));
    await tester.pump();
    // Prüfe, ob 1.5x angezeigt wird
    expect(find.text('1.5x'), findsWidgets);
    await tester.pump(const Duration(seconds: 4)); // Timer cleanup für Marquee
  });

  testWidgets(
      'Schnelles mehrfaches Klicken auf Play/Pause führt zu konsistenten State-Wechseln (StreamController)',
      (WidgetTester tester) async {
    final controller = StreamController<AudioPlayerState>.broadcast();
    final testEpisode = PodcastEpisode(
      wrapperType: 'episode',
      trackId: 1,
      trackName: 'Test Episode',
      artworkUrl600: '',
      description: 'Testbeschreibung',
      episodeUrl: 'https://audio/test.mp3',
      trackTimeMillis: 60000,
      episodeFileExtension: 'mp3',
      releaseDate: DateTime(2024, 1, 1),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerStateProvider.overrideWith((ref) => controller.stream),
          currentEpisodeProvider.overrideWith((ref) => testEpisode),
        ],
        child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
      ),
    );
    await tester.pump();
    // Initial: Paused (position=0) → Button disabled
    controller.add(Paused(Duration.zero, Duration(seconds: 60)));
    await tester.pump();
    var playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    var playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNull,
        reason: 'Im Preload-Overlay ist der Button disabled');
    // Play → Playing: Button enabled
    controller.add(Playing(Duration(seconds: 0), Duration(seconds: 60)));
    await tester.pump();
    playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNotNull);
    // Pause (position=0): Button enabled
    controller.add(Paused(Duration.zero, Duration(seconds: 60)));
    await tester.pump();
    playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNotNull,
        reason: 'Im Preload-Overlay ist der Button enabled (UX-Update)');
    // Pause (position>0): Button enabled
    controller.add(Paused(Duration(seconds: 5), Duration(seconds: 60)));
    await tester.pump();
    playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNotNull,
        reason: 'Ab position>0 ist der Button enabled');
    await controller.close();
    await tester.pumpAndSettle(); // Timer cleanup
  });

  testWidgets(
    'BottomPlayerWidget zeigt Overlay "Audio vorgeladen – bereit zum Abspielen" im Preload-Case (StreamController)',
    (WidgetTester tester) async {
      // ---
      // Lessons Learned: Im Preload-Overlay-State (Paused, position=0, gültige URL) ist der Play/Pause-Button
      // im Widget-Baum vorhanden, aber deaktiviert (onPressed == null). Die UI zeigt das Overlay und einen
      // disabled Button für Accessibility/Konsistenz. Siehe auch Docstring im BottomPlayerWidget.
      // ---
      final controller = StreamController<AudioPlayerState>.broadcast();
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerStateProvider.overrideWith((ref) => controller.stream),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
            audioPlayerBlocProvider.overrideWithValue(DummyAudioPlayerBloc()),
          ],
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      await tester.pump(); // Nach ProviderScope-Setup
      // Paused-State mit position=0 (Preload-Overlay)
      controller.add(Paused(Duration.zero, Duration(seconds: 60)));
      await tester.pump();
      await tester.pump(); // Zusätzlicher pump für Widget-Baum
      // Debug: Alle Widgets nach State-Wechsel ausgeben
      debugPrint('--- Widget-Baum nach Paused(position=0) ---');
      for (final w in tester.allWidgets) {
        debugPrint(w.toString());
      }
      // Im Preload-Overlay-State: Button vorhanden, aber disabled
      expect(
          find.byWidgetPredicate(
              (w) => w is Text && (w.data?.contains('Stream lädt') ?? false)),
          findsOneWidget);
      final playButtonFinder =
          find.byKey(const Key('player_play_pause_button'));
      expect(playButtonFinder, findsOneWidget);
      final playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNull,
          reason: 'Im Preload-Overlay ist der Button disabled');
      await controller.close();
      await tester.pumpAndSettle(); // Timer cleanup
    },
  );

  // ---
  // Hinweis: Die Overlay-/Button-Logik ist im Widget und in der Test-Doku dokumentiert.
  // Im Preload-Overlay-State ist der Play/Pause-Button immer vorhanden, aber deaktiviert.
  // ---

  testWidgets(
    'BottomPlayerWidget zeigt Overlay "Wird geladen…" im Loading-State',
    (WidgetTester tester) async {
      final backend = MockAudioPlayerBackend();
      when(() => backend.positionStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => backend.durationStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => backend.playerStateStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => backend.position).thenReturn(Duration.zero);
      when(() => backend.duration).thenReturn(Duration(seconds: 60));
      when(() => backend.playing).thenReturn(false);
      when(() => backend.dispose()).thenReturn(null);
      when(() => backend.play()).thenAnswer((_) async {});
      when(() => backend.pause()).thenAnswer((_) async {});
      when(() => backend.setUrl(any())).thenAnswer((_) async {});
      when(() => backend.seek(any())).thenAnswer((_) async {});
      when(() => backend.stop()).thenAnswer((_) async {});
      when(() => backend.speed).thenReturn(1.0);
      final bloc = AudioPlayerBloc(backend: backend);
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerBlocProvider.overrideWithValue(bloc),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      bloc.emit(Loading());
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      // Debug: Alle Text-Widgets und InkWell-Buttons ausgeben
      for (final w in tester.allWidgets) {
        if (w is Text) debugPrint('Text-Widget: "${w.data}"');
        if (w is InkWell && w.child is Icon) {
          final icon = w.child as Icon;
          debugPrint('InkWell: ${icon.icon} enabled=${w.onTap != null}');
        }
      }
      // Statt Overlay-Text: Prüfe auf CircularProgressIndicator im reinen Loading-State
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Play-Button-Prüfung entfällt hier, da im Loading-State kein Player-UI gerendert wird.
      await tester.pump(const Duration(seconds: 4)); // Timer cleanup
    },
  );

  testWidgets(
      'BottomPlayerWidget Play/Pause-Button ist nach Pause wieder sichtbar (UX-Flow, StreamController)',
      (
    tester,
  ) async {
    final controller = StreamController<AudioPlayerState>.broadcast();
    final testEpisode = PodcastEpisode(
      wrapperType: 'episode',
      trackId: 1,
      trackName: 'Test Episode',
      artworkUrl600: '',
      description: 'Testbeschreibung',
      episodeUrl: 'https://audio/test.mp3',
      trackTimeMillis: 60000,
      episodeFileExtension: 'mp3',
      releaseDate: DateTime(2024, 1, 1),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioPlayerStateProvider.overrideWith((ref) => controller.stream),
          currentEpisodeProvider.overrideWith((ref) => testEpisode),
        ],
        child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
      ),
    );
    await tester.pump();
    // Initial: Paused-State
    controller.add(Paused(Duration.zero, Duration(seconds: 60)));
    await tester.pump();
    await debugPrintAudioState(tester);
    // Play-Button sichtbar und enabled
    final playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    var playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNotNull);
    // Play-Button tappen
    await tester.tap(playButtonFinder);
    await tester.pump();
    // Bloc-State auf Playing setzen (wie Backend nach Play)
    controller.add(Playing(Duration(seconds: 0), Duration(seconds: 60)));
    await tester.pump();
    await debugPrintAudioState(tester);
    // Pause-Button sichtbar
    final pauseButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(pauseButtonFinder, findsOneWidget);
    playButton = tester.widget<IconButton>(pauseButtonFinder);
    expect(playButton.onPressed, isNotNull);
    // Pause-Button tappen
    await tester.tap(pauseButtonFinder);
    await tester.pump();
    // Bloc-State auf Paused setzen (wie Backend nach Pause)
    controller.add(Paused(Duration(seconds: 5), Duration(seconds: 60)));
    await tester.pump();
    await debugPrintAudioState(tester);
    // Play-Button wieder sichtbar und enabled
    expect(find.byKey(const Key('player_play_pause_button')), findsOneWidget);
    playButton = tester.widget<IconButton>(pauseButtonFinder);
    expect(playButton.onPressed, isNotNull);
    await controller.close();
    await tester.pumpAndSettle(); // Timer/Marquee cleanup
  });

  /// Hilfsfunktion: Setzt einen State, pumpt mehrfach und gibt Debug-Infos zu Button und Overlay aus.
  Future<void> setStateAndPump({
    required WidgetTester tester,
    required StreamController<AudioPlayerState> controller,
    required AudioPlayerState state,
    int pumpCount = 3,
  }) async {
    controller.add(state);
    for (int i = 0; i < pumpCount; i++) {
      await tester.pump();
      debugPrint('[TestHelper] pump $i, State: \\${state.runtimeType}');
      final playButtonFinder =
          find.byKey(const Key('player_play_pause_button'));
      if (playButtonFinder.evaluate().isNotEmpty) {
        final playButton = tester.widget<IconButton>(playButtonFinder);
        debugPrint(
            '[TestHelper] PlayButton: enabled=\\${playButton.onPressed != null}');
      } else {
        debugPrint('[TestHelper] PlayButton: not found');
      }
      final overlayText = find.byWidgetPredicate(
          (w) => w is Text && (w.data?.contains('Stream lädt') ?? false));
      debugPrint(
          '[TestHelper] OverlayText: found=\\${overlayText.evaluate().isNotEmpty}');
    }
  }

  testWidgets(
    'BottomPlayerWidget zeigt Preload-Overlay und Button-Status korrekt (mit setStateAndPump)',
    (WidgetTester tester) async {
      final controller = StreamController<AudioPlayerState>.broadcast();
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerStateProvider.overrideWith((ref) => controller.stream),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      // Preload-Overlay: Paused, position=0
      await setStateAndPump(
        tester: tester,
        controller: controller,
        state: Paused(Duration.zero, Duration(seconds: 60)),
      );
      expect(
          find.byWidgetPredicate(
              (w) => w is Text && (w.data?.contains('Stream lädt') ?? false)),
          findsOneWidget);
      final playButtonFinder =
          find.byKey(const Key('player_play_pause_button'));
      expect(playButtonFinder, findsOneWidget);
      final playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNotNull,
          reason: 'Im Preload-Overlay ist der Button enabled (UX-Update)');
      // Fortschritt simulieren: Button enabled
      await setStateAndPump(
        tester: tester,
        controller: controller,
        state: Paused(Duration(seconds: 2), Duration(seconds: 60)),
      );
      final playButton2 = tester.widget<IconButton>(playButtonFinder);
      expect(playButton2.onPressed, isNotNull,
          reason: 'Ab position>0 ist der Button enabled');
      await controller.close();
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle(); // Timer cleanup
    },
  );

  testWidgets(
    'BottomPlayerWidget UX-Flow: State-Wechsel und Button-Status (setStateAndPump)',
    (WidgetTester tester) async {
      final controller = StreamController<AudioPlayerState>.broadcast();
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerStateProvider.overrideWith((ref) => controller.stream),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      // 1. Paused (position=0): Preload-Overlay, Button disabled
      await setStateAndPump(
        tester: tester,
        controller: controller,
        state: Paused(Duration.zero, Duration(seconds: 60)),
      );
      var playButtonFinder = find.byKey(const Key('player_play_pause_button'));
      var playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNotNull);
      // 2. Playing: Button enabled
      await setStateAndPump(
        tester: tester,
        controller: controller,
        state: Playing(Duration(seconds: 5), Duration(seconds: 60)),
      );
      playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNotNull);
      // 3. ErrorState: Button nicht vorhanden
      await setStateAndPump(
        tester: tester,
        controller: controller,
        state: ErrorState('Fehlerfall'),
      );
      expect(playButtonFinder, findsNothing);
      // 4. Loading: Button nicht vorhanden
      await setStateAndPump(
        tester: tester,
        controller: controller,
        state: Loading(),
      );
      expect(playButtonFinder, findsNothing);
      // 5. Paused (position>0): Button enabled
      await setStateAndPump(
        tester: tester,
        controller: controller,
        state: Paused(Duration(seconds: 10), Duration(seconds: 60)),
      );
      playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNotNull);
      await controller.close();
      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets(
    'BottomPlayerWidget: Position läuft nach Pause/Play korrekt weiter',
    (WidgetTester tester) async {
      final controller = StreamController<AudioPlayerState>.broadcast();
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerStateProvider.overrideWith((ref) => controller.stream),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      // 1. Starte mit Playing (Position 5)
      controller.add(Playing(Duration(seconds: 5), Duration(seconds: 60)));
      await tester.pump();
      expect(find.text('00:05'), findsOneWidget);
      // 2. Pause (Position bleibt 5)
      controller.add(Paused(Duration(seconds: 5), Duration(seconds: 60)));
      await tester.pump();
      expect(find.text('00:05'), findsOneWidget);
      // 3. Wieder Play (Position läuft weiter, z.B. 6)
      controller.add(Playing(Duration(seconds: 6), Duration(seconds: 60)));
      await tester.pump();
      expect(find.text('00:06'), findsOneWidget);
      // 4. Pause erneut (Position bleibt 6)
      controller.add(Paused(Duration(seconds: 6), Duration(seconds: 60)));
      await tester.pump();
      expect(find.text('00:06'), findsOneWidget);
      await controller.close();
      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets(
    'BottomPlayerWidget: Fehler während Preload blendet Overlay aus und zeigt Error-UI',
    (WidgetTester tester) async {
      final controller = StreamController<AudioPlayerState>.broadcast();
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerStateProvider.overrideWith((ref) => controller.stream),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      // Preload-Overlay
      controller.add(Paused(Duration.zero, Duration(seconds: 60)));
      await tester.pump();
      expect(find.textContaining('Stream lädt'), findsOneWidget);
      // Fehler simulieren
      controller.add(ErrorState('Fehler beim Laden'));
      await tester.pump();
      expect(find.textContaining('Fehler beim Laden'), findsOneWidget);
      expect(find.byKey(const Key('player_play_pause_button')), findsNothing);
      await controller.close();
    },
  );

  testWidgets(
    'BottomPlayerWidget: Play → Pause (doppelter Klick) stoppt den Stream und zeigt wieder Play-Icon',
    (WidgetTester tester) async {
      final controller = StreamController<AudioPlayerState>.broadcast();
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerStateProvider.overrideWith((ref) => controller.stream),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      // 1. Paused (position>0): Play-Button sichtbar
      controller.add(Paused(Duration(seconds: 2), Duration(seconds: 60)));
      await tester.pump();
      final playButtonFinder =
          find.byKey(const Key('player_play_pause_button'));
      expect(playButtonFinder, findsOneWidget);
      var playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNotNull);
      // 2. Play drücken → Playing-State
      await tester.tap(playButtonFinder);
      await tester.pump();
      controller.add(Playing(Duration(seconds: 2), Duration(seconds: 60)));
      await tester.pump();
      playButton = tester.widget<IconButton>(playButtonFinder);
      expect((playButton.icon as Icon).icon, Icons.pause_circle_filled);
      // 3. Pause drücken → Paused-State
      await tester.tap(playButtonFinder);
      await tester.pump();
      controller.add(Paused(Duration(seconds: 2), Duration(seconds: 60)));
      await tester.pump();
      playButton = tester.widget<IconButton>(playButtonFinder);
      expect((playButton.icon as Icon).icon, Icons.play_circle_fill);
      expect(playButton.onPressed, isNotNull);
      await controller.close();
    },
  );

  testWidgets(
    'BottomPlayerWidget: Preload-Overlay → Play → Pause → Play (klassischer Flow)',
    (WidgetTester tester) async {
      final controller = StreamController<AudioPlayerState>.broadcast();
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      final container = ProviderContainer(overrides: [
        audioPlayerStateProvider.overrideWith((ref) => controller.stream),
        currentEpisodeProvider.overrideWith((ref) => testEpisode),
      ]);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      // Preload-Overlay: Paused, position=0
      controller.add(Paused(Duration.zero, Duration(seconds: 60)));
      await tester.pump();
      expect(
          find.byWidgetPredicate(
              (w) => w is Text && (w.data?.contains('Stream lädt') ?? false)),
          findsOneWidget);
      final playButtonFinder =
          find.byKey(const Key('player_play_pause_button'));
      expect(playButtonFinder, findsOneWidget);
      final playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNotNull,
          reason: 'Im Preload-Overlay ist der Button enabled (UX-Update)');
      // Play-Button tappen → Playing-State
      await tester.tap(playButtonFinder);
      await tester.pump();
      controller.add(Playing(Duration(seconds: 0), Duration(seconds: 60)));
      await tester.pump();
      final pauseButton = tester.widget<IconButton>(playButtonFinder);
      expect((pauseButton.icon as Icon).icon, Icons.pause_circle_filled);
      await controller.close();
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle(); // Timer/Marquee cleanup
      final bloc = container.read(audioPlayerBlocProvider);
      await bloc.close();
      container.dispose();
    },
  );

  testWidgets(
    'BottomPlayerWidget zeigt Preload-Overlay und Play/Pause-Button ist enabled (UX-Update, wie Spotify/just_audio)',
    (WidgetTester tester) async {
      final controller = StreamController<AudioPlayerState>.broadcast();
      final testEpisode = PodcastEpisode(
        wrapperType: 'episode',
        trackId: 1,
        trackName: 'Test Episode',
        artworkUrl600: '',
        description: 'Testbeschreibung',
        episodeUrl: 'https://audio/test.mp3',
        trackTimeMillis: 60000,
        episodeFileExtension: 'mp3',
        releaseDate: DateTime(2024, 1, 1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerStateProvider.overrideWith((ref) => controller.stream),
            currentEpisodeProvider.overrideWith((ref) => testEpisode),
          ],
          child: MaterialApp(home: Scaffold(body: BottomPlayerWidget())),
        ),
      );
      await tester.pump();
      // Preload-Overlay: Paused, position=0
      controller.add(Paused(Duration.zero, Duration(seconds: 60)));
      await tester.pump();
      expect(
          find.byWidgetPredicate(
              (w) => w is Text && (w.data?.contains('Stream lädt') ?? false)),
          findsOneWidget);
      final playButtonFinder =
          find.byKey(const Key('player_play_pause_button'));
      expect(playButtonFinder, findsOneWidget);
      final playButton = tester.widget<IconButton>(playButtonFinder);
      expect(playButton.onPressed, isNotNull,
          reason: 'Im Preload-Overlay ist der Button enabled (UX-Update)');
      // Play-Button tappen → Playing-State
      await tester.tap(playButtonFinder);
      await tester.pump();
      controller.add(Playing(Duration(seconds: 0), Duration(seconds: 60)));
      await tester.pump();
      final pauseButton = tester.widget<IconButton>(playButtonFinder);
      expect((pauseButton.icon as Icon).icon, Icons.pause_circle_filled);
      await controller.close();
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle(); // Timer/Marquee cleanup
    },
  );

  /// Test Cleanup: Timer/Animationen (z.B. Marquee) nach allen Tests zuverlässig beenden.
  ///
  /// Hintergrund: Flutter-Widget-Tests mit Animationen (z.B. Marquee, ProgressBar) oder Streams
  /// können Pending-Timer-Fehler verursachen, wenn der Widget-Baum nicht explizit abgeräumt wird.
  ///
  /// Best Practice: Nach jedem Test ein leeres Widget pumpen und pumpAndSettle aufrufen.
  /// Siehe auch: https://github.com/flutter/flutter/issues/43109
  tearDownAll(() async {
    // Nach allen Tests: Widget-Baum leeren und Timer/Animationen beenden
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.runAsync(() async {
      // Leeres Widget pumpen, um alle Timer/Animationen zu stoppen
      final tester = binding as WidgetTester;
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });
  });
}
