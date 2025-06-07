# Audio-Player Best Practices & Ressourcen (Stand 2025)

## 1. Empfohlene Pakete & Ressourcen
- [just_audio](https://pub.dev/packages/just_audio): Feature-reicher, plattformübergreifender Audio-Player (Play, Pause, Seek, Speed, Playlist, Fehler, Streams, etc.)
- [audio_service](https://pub.dev/packages/audio_service): Für Hintergrundwiedergabe, Lockscreen/Notification-Steuerung, Headset, Android Auto/CarPlay.
- [audio_session](https://pub.dev/packages/audio_session): Audio-Session-Management (z.B. für Podcast-Modus, Ducking, Phone-Interruption).
- [Flutter Accessibility Guide](https://docs.flutter.dev/development/accessibility-and-localization/accessibility): Für barrierefreie UI (Semantics, Kontrast, große Schrift, Screenreader).

## 2. Wichtige Features & Patterns
- **Player-Methoden:**
  - `play()`, `pause()`, `stop()`, `seek(Duration)`, `setSpeed(double)`, `setVolume(double)`
  - Fehlerbehandlung: try/catch bei `setUrl`, Fehler-Stream abonnieren
  - State-Streams: `playerStateStream`, `positionStream`, `durationStream`, `processingState`
- **UI/UX:**
  - Transport-Buttons (Play/Pause, Vor/Zurück, Seek, Stop)
  - Fortschrittsanzeige (Slider, Zeit)
  - Speed-Control (Dropdown, Buttons)
  - Fehler- und Ladeanzeigen (Snackbars, LoadingDots)
  - Titel, Episodenname, Cover
- **Accessibility:**
  - Semantics-Labels für Buttons, Slider, etc.
  - Kontrastreiche Farben, große Touchflächen (min. 48x48)
  - Test mit Screenreader (TalkBack, VoiceOver)
  - Text skalierbar (große Schrift)
- **BLoC/State-Management:**
  - UI reagiert auf Player-Streams (z.B. via Riverpod, Bloc, Provider)
  - Events: Play, Pause, Seek, SetSpeed, Fehler, etc.
  - States: Idle, Loading, Playing, Paused, Error, Completed

## 3. Best Practice Links
- [just_audio Doku & Beispiele](https://pub.dev/packages/just_audio)
- [audio_service Doku & Beispiele](https://pub.dev/packages/audio_service)
- [just_audio GitHub](https://github.com/ryanheise/just_audio)
- [audio_service GitHub](https://github.com/ryanheise/audio_service)
- [Flutter Accessibility Guide](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [just_audio_background](https://pub.dev/packages/just_audio_background) (für Lockscreen/Notification)
- [Tutorial: Streaming audio in Flutter with Just Audio](https://suragch.medium.com/steaming-audio-in-flutter-with-just-audio-7435fcf672bf?sk=c7163e8496b914c9e0e5446ec6020f04)

## 4. Empfohlener Ablauf für die Umsetzung
1. **UI-Elemente & Semantics:**
   - Transport-Buttons, Slider, Speed-Control, Fehleranzeige, Accessibility-Labels
2. **Bloc/Provider-Methoden:**
   - Play, Pause, Seek, SetSpeed, Fehlerbehandlung, State-Streams
3. **Testen:**
   - Widget- und Integrationstests, Accessibility-Checks (Guideline-API, Screenreader)
4. **Optional:**
   - Hintergrundwiedergabe, Playlist, Notification, Download, AirPlay/Cast

## 5. Marquee/Scrolling-Text (Apple Music Style)
- Für lange Episodentitel im Mini-Player empfiehlt sich ein animierter, durchlaufender Text (Marquee), wie er auch in Apple Music verwendet wird.
- Flutter-Paket: [`marquee`](https://pub.dev/packages/marquee) – unterstützt einzeilige, horizontal scrollende Texte mit Pausen am Ende jedes Durchlaufs.
- Best Practices:
  - Dezente Textfarbe (z. B. `withAlpha(180)`), einzeilig, Animation mit Pause (`pauseAfterRound`)
  - Accessibility: Semantics-Label für Screenreader, Geschwindigkeit nicht zu hoch wählen
  - Platzsparende Integration: Marquee und Speed-Control können nebeneinander in einer Row platziert werden, um die Höhe des Mini-Players gering zu halten
- Beispiel:
  ```dart
  Row(
    children: [
      Expanded(
        child: Marquee(
          text: 'Langer Episodentitel ...',
          style: TextStyle(color: Colors.black.withAlpha(180)),
          pauseAfterRound: Duration(seconds: 1),
          ...
        ),
      ),
      DropdownButton(...),
    ],
  )
  ```
- Siehe auch: [Apple HIG – Scrolling Text](https://developer.apple.com/design/human-interface-guidelines/components/text-fields-and-labels#Scrolling-Text)

## Lessons Learned & Best Practices: Play/Pause-Logik (Juni 2025)

- Die Play/Pause-Logik sollte deterministisch und ohne Event-Buffering (z.B. _pendingToggle) umgesetzt werden.
- Events wie Play/Pause werden nur im passenden State verarbeitet, ansonsten ignoriert oder mit UI-Feedback quittiert.
- Die UI (BottomPlayerWidget) aktiviert den Play/Pause-Button nur, wenn die Aktion möglich ist (z.B. nicht während Loading).
- Nach jedem Event wird sofort der neue State emittiert, damit die UI direkt reagiert.
- Tests decken schnelles, mehrfaches Klicken auf Play/Pause ab, um Race-Conditions auszuschließen.
- Ziel: Robuste, sofortige und benutzerfreundliche UX wie bei Apple Podcasts oder just_audio.

## Buffering, Preload & Streaming: Best Practices (Stand Juni 2025)

- **Preload nutzen:** Vor jedem Play immer zuerst `await player.setUrl(url)` aufrufen, damit die Datei vorgepuffert wird. Erst danach `play()` ausführen.
- **Buffering-Status anzeigen:** Während `processingState == buffering` oder während `setUrl` läuft, sollte die UI einen Ladeindikator (z.B. CircularProgressIndicator) anzeigen.
- **Server-Header prüfen:** Der Server muss `Content-Length`, `Content-Type` und Range-Requests unterstützen, damit just_audio stabil streamen kann.
- **Windows/Linux:** Bei Problemen mit Flackern/Buffering ggf. Alternativ-Backend wie `just_audio_media_kit` oder `just_audio_windows` in der pubspec.yaml testen.
- **Echtes Gerät bevorzugen:** Emulatoren und Windows-Implementierungen sind oft weniger performant als Android/iOS-Geräte.
- **Fehler robust abfangen:** Fehler bei `setUrl` und `play` immer mit try/catch behandeln und in der UI anzeigen.

**Beispiel (Minimalplayer):**
```dart
await player.setUrl(url); // Preload
await player.play();      // Start
```

**Weitere Tipps:**
- Buffering-Status kann über `player.processingStateStream` oder `player.playerStateStream` abgefragt werden.
- Siehe auch: https://pub.dev/packages/just_audio#the-state-model

## 6. Lessons Learned: Widget-Tests & deterministische State-Wechsel (Juni 2025)

- Für robuste und deterministische Widget-Tests empfiehlt sich eine Hilfsfunktion wie `setStateAndPump`, die gezielt State-Wechsel im Player simuliert, mehrfach pumpt und nach jedem Schritt Debug-Ausgaben zu Button-Status und Overlay liefert.
- State- und UX-Flow-Tests sollten alle relevanten States (Idle, Loading, Playing, Paused, Error) abdecken und nach jedem State-Wechsel den Widget-Baum prüfen (Button vorhanden/enabled/disabled, Overlay sichtbar, etc.).
- Die Button-Enable-Logik im Widget muss exakt mit der Test-Logik und der UX-Dokumentation übereinstimmen:
  - Im Preload-Overlay-State (Paused, position=0, gültige URL) ist der Play/Pause-Button vorhanden, aber deaktiviert.
  - Im Loading- und Error-State ist der Button nicht vorhanden.
  - In allen anderen Player-States (Playing, Paused mit position>0) ist der Button vorhanden und enabled.
- Nach jedem State-Wechsel im Test mindestens zwei `pump()` ausführen, um alle Rebuilds sicherzustellen.
- ProviderScope und Provider-Overrides im Test immer korrekt initialisieren, damit State-Propagation und Event-Dispatch wie in der echten App funktionieren.
- Debug-Ausgaben nach jedem Schritt helfen, Timing-Probleme und fehlerhafte State-Propagation frühzeitig zu erkennen.

**Beispiel: Deterministischer Widget-Test mit setStateAndPump**

```dart
// Hilfsfunktion für deterministische State-Wechsel und Debug-Ausgaben
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
    final playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    if (playButtonFinder.evaluate().isNotEmpty) {
      final playButton = tester.widget<IconButton>(playButtonFinder);
      debugPrint('[TestHelper] PlayButton: enabled=\\${playButton.onPressed != null}');
    } else {
      debugPrint('[TestHelper] PlayButton: not found');
    }
    final overlayText = find.byWidgetPredicate((w) => w is Text && (w.data?.contains('Stream lädt') ?? false));
    debugPrint('[TestHelper] OverlayText: found=\\${overlayText.evaluate().isNotEmpty}');
  }
}

// Beispiel-Testfall für Preload-Overlay und Button-Status

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
    expect(find.byWidgetPredicate((w) => w is Text && (w.data?.contains('Stream lädt') ?? false)), findsOneWidget);
    final playButtonFinder = find.byKey(const Key('player_play_pause_button'));
    expect(playButtonFinder, findsOneWidget);
    final playButton = tester.widget<IconButton>(playButtonFinder);
    expect(playButton.onPressed, isNull, reason: 'Im Preload-Overlay ist der Button disabled');
    // Fortschritt simulieren: Button enabled
    await setStateAndPump(
      tester: tester,
      controller: controller,
      state: Paused(Duration(seconds: 2), Duration(seconds: 60)),
    );
    final playButton2 = tester.widget<IconButton>(playButtonFinder);
    expect(playButton2.onPressed, isNotNull, reason: 'Ab position>0 ist der Button enabled');
    await controller.close();
    await tester.pump(const Duration(seconds: 2)); // Timer cleanup
  },
);
```

Siehe auch: Kommentar und Docstring in `bottom_player_widget_test.dart` und `bottom_player_widget.dart`.

---

## 7. Doku-Pflege & Querverweise (Stand: 07.06.2025)

- Diese Datei wird nach jedem neuen Feature, Refactoring oder Test-Update aktualisiert.
- Lessons Learned und Best Practices werden laufend ergänzt und in die Doku-Matrix (`.instructions/doku_matrix.md`) aufgenommen.
- Für alle neuen Audio-Features, UX-Entscheidungen und Teststrategien ist ein Abgleich mit der zentralen Architekturübersicht (`docs/audio_architektur_2025.md`) und der Teststrategie (`.documents/decisions/adr-003-teststrategie.md`) verpflichtend.
- Querverweise auf `.documents/README.md`, `.instructions/README.md`, `.documents/bloc_best_practices_2024.md`, `.documents/project_structure_best_practices.md` und `.documents/state_management_riverpod_bloc.md` sind aktuell zu halten.
- Legacy- und Migrationshinweise werden im Archiv-Ordner `docs/legacy/` dokumentiert und in der Hauptdoku verlinkt.

---

Diese Zusammenfassung basiert auf den aktuellen Doku- und Community-Quellen (Stand Juni 2025) und kann als Grundlage für die weitere Entwicklung und Dokumentation des Audio-Players dienen.
