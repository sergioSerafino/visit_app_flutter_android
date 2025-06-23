# Architekturübersicht: Modernes Audio-Streaming in Flutter

## 1. Komponenten & Schichten

**1.1 AudioHandler (Systemintegration)**
- Implementiert mit `audio_service` (z.B. `MyAudioHandler`).
- Kapselt die Audio-Engine (z.B. just_audio).
- Zuständig für:
  - Hintergrundwiedergabe
  - Sperrbildschirm/Benachrichtigungen (MediaSession, NowPlayingInfo)
  - Steuerung über Headset, Auto, Siri/Google Assistant
- Wird beim App-Start initialisiert und global bereitgestellt (Provider/DI).

**1.2 IAudioPlayerBackend (App-Logik)**
- Interface für die eigentliche Audio-Logik (Play, Pause, Seek, Playlist, etc.).
- Implementierungen: z.B. `JustAudioPlayerBackend`, `AudioPlayersBackend`.
- Wird im BLoC verwendet, ist unabhängig testbar und mockbar.

**1.3 AudioPlayerBloc (BLoC)**
- Vermittelt zwischen UI und Backend.
- Reagiert auf Events (Play, Pause, Seek, Next, etc.).
- Gibt States an die UI weiter.
- Hört auf Status-Streams des Backends (z.B. Position, Duration, Playing).

**1.4 Provider (Riverpod)**
- Stellt BLoC und Backend für UI und Tests bereit.
- Trennt Systemintegration (audioHandlerProvider) und App-Logik (audioPlayerBlocProvider).

**1.5 UI**
- Nutzt BLoC/Provider für State und Events.
- Kommuniziert nie direkt mit AudioHandler oder Backend.

---

## 2. Datenfluss

```mermaid
flowchart LR
    UI --dispatchiert Events--> AudioPlayerBloc
    AudioPlayerBloc --ruft Methoden auf--> IAudioPlayerBackend
    IAudioPlayerBackend --liefert Streams/Status--> AudioPlayerBloc
    AudioPlayerBloc --liefert State--> UI
    AudioHandler --Systemintegration (Hintergrund, Lockscreen, etc.)--> OS
    IAudioPlayerBackend --kann AudioHandler nutzen--> AudioHandler
```

---

## 3. Testbarkeit

- **BLoC und Backend sind vollständig mockbar und unabhängig testbar.**
- Im Test wird ein Mock-Backend (`MockAudioPlayerBackend`) an den BLoC übergeben.
- Die Systemintegration (`audioHandlerProvider`) wird im Test überschrieben oder gemockt.

---

## 4. Beispiel-Provider

```dart
// lib/application/providers/audio_player_provider.dart
final audioPlayerBlocProvider = Provider<AudioPlayerBloc>((ref) {
  return AudioPlayerBloc(backend: AudioPlayersBackend());
});
```

```dart
// lib/application/providers/audio_handler_provider.dart
final audioHandlerProvider = Provider<AudioHandler>((ref) =>
    throw UnimplementedError('audioHandlerProvider muss im Test überschrieben werden'));
```

---

## 5. Best Practices

- **Trennung von Systemintegration und App-Logik**:  
  - `audioHandler` nur für OS-Integration, nicht für UI-Logik/BLoC.
  - `IAudioPlayerBackend` für alle UI-nahen Audio-Operationen.
- **Provider-Pattern**:  
  - Für jede Schicht einen eigenen Provider.
- **Testbarkeit**:  
  - Mock-Backends und Provider-Overrides in Tests.
- **Fehlerbehandlung**:  
  - Fehler im Backend/BLoC abfangen und als States an die UI geben.

---

## 6. Beispiel-Test (BLoC)

```dart
class MockAudioPlayerBackend extends Mock implements IAudioPlayerBackend {}

void main() {
  late MockAudioPlayerBackend backend;
  setUp(() {
    backend = MockAudioPlayerBackend();
    // Streams und Methoden stubben
  });

  test('PlayEpisode führt zu Loading und dann Playing', () async {
    final bloc = AudioPlayerBloc(backend: backend);
    // Testlogik...
  });
}
```

---

## 7. Übersichtstabelle: IST vs. SOLL der Audio-Architektur (Juni 2025)

| Aspekt                | IST (Alt)                                              | SOLL (Neu, Ziel)                                         |
|-----------------------|--------------------------------------------------------|----------------------------------------------------------|
| **Systemintegration** | AudioHandler teils direkt in UI/BLoC verwendet         | AudioHandler nur für OS/Background, nie direkt in UI/BLoC |
| **App-Logik**         | Audio-Logik teils im Handler, teils in Widgets         | Saubere Trennung: IAudioPlayerBackend für App-Logik       |
| **BLoC**              | BLoC nimmt teils AudioHandler, teils Backend           | BLoC nimmt immer IAudioPlayerBackend als Abhängigkeit     |
| **Provider**          | Vermischte Provider, teils Handler, teils Backend      | Klare Provider-Trennung: audioHandlerProvider & audioPlayerBlocProvider |
| **Testbarkeit**       | Tests schwer, da Handler nicht gut mockbar             | Volle Testbarkeit: MockBackend für BLoC, Handler nur stub |
| **Fehlerbehandlung**  | Fehlerhandling teils im Widget, teils im Handler       | Fehlerhandling zentral im BLoC/Backend, State-basiert     |
| **State-Management**  | Teilweise direkte Streams/Flags in Widgets             | State nur über BLoC/Provider, UI ist rein konsumierend    |
| **Architektur-Doku**  | Verstreute Hinweise, keine zentrale Übersicht          | Zentrale, aktuelle Architekturübersicht vorhanden         |
| **Best Practices**    | Nicht immer konsistent umgesetzt                      | Best Practices (Trennung, Testbarkeit, Provider) überall  |

> **Hinweis:** Für Details und Umsetzung siehe die Abschnitte oben und die Quellverweise.

---

## Umsetzungs-Stand: Produktives Audio-Playback (Stand: 23.06.2025)

### Architektur & Code
- AudioPlayerBloc (lib/core/services/audio_player_bloc.dart) implementiert Events/States für Play, Pause, Seek, Speed, Volume, Fehler, Preload etc.
- Nutzt IAudioPlayerBackend für die eigentliche Audio-Logik (Austauschbarkeit, Testbarkeit).
- Fehlerbehandlung, Resume, State-Maschine und Testbarkeit sind umgesetzt.
- Produktiv-Backend (just_audio) ist vorbereitet, aber im Provider aktuell noch nicht als Default aktiv.
- AudioPlayerSyncService nutzt just_audio und synchronisiert Streams für Position, Duration, Speed, Volume.
- Provider-Pattern (audioPlayerBlocProvider) ermöglicht flexiblen Austausch des Backends (Mock, produktiv, Test).
- audioHandlerProvider für Systemintegration (audio_service) ist vorbereitet, aber noch nicht produktiv angebunden.
- UI (BottomPlayerWidget) nutzt BLoC/Provider für State und Events, Transport-Buttons, Progressbar, Speed/Volume-Control, Fehler- und Ladeanzeigen sind vorhanden.

### Dokumentation
- Architektur und Best Practices sind in `.documents/audio_architektur_2025.md`, `.documents/audio_player_best_practices_2025.md` und `.documents/audio_architektur_flow.mmd` dokumentiert.
- Die Teststrategie und Lessons Learned sind dokumentiert.
- Die PRD-Liste und ToDos in `.documents/prd_white_label_podcast_app.md` listen das produktive Audio-Playback als offenes Kern-Feature.

### Offene ToDos
- [ ] Produktives Backend (just_audio) als Default aktivieren
- [ ] Systemintegration mit audio_service (Hintergrund, Lockscreen, Headset) produktiv anbinden
- [ ] E2E- und Offline-Tests für Audio-Playback
- [ ] Download/Offline-Playback umsetzen
- [ ] UX-Feinschliff: Fehlerfälle, Snackbar, Resume, Speed/Volume-UX

**Quellen:**

- [just_audio](https://pub.dev/packages/just_audio)
- [audio_service](https://pub.dev/packages/audio_service)
- [audio_session](https://pub.dev/packages/audio_session)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- `.documents/prd_white_label_podcast_app.md` (PRD, ToDos)
- `.documents/audio_architektur_2025.md` (Architektur)
- `.documents/audio_player_best_practices_2025.md` (Best Practices)
- `lib/core/services/audio_player_bloc.dart`, `audio_player_sync_service.dart`, `i_audio_player.dart`
- `lib/application/providers/audio_player_provider.dart`
