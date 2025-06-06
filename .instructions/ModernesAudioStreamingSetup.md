> **Hinweis:** Die aktuelle, zentrale Architekturübersicht (inkl. BLoC, Backend, AudioHandler, Provider, Testbarkeit) findest du in [../docs/audio_architektur_2025.md](../docs/audio_architektur_2025.md).

Für eine robuste Audio-Streaming- und Wiedergabe-Funktion in Flutter
kombinieren wir just_audio für die Wiedergabe mit audio_service für
Hintergrund- und Systemintegration. Dieses Setup unterstützt
URL-Streams, Playlists und lokale Dateien sowie Play/Pause, Seek,
Shuffle/Repeat und Steuerung über Sperrbildschirm und Benachrichtigungen
(Android MediaSession, iOS NowPlayingInfo). Die Steuerung

> flutter_bloc

erfolgt über das BLoC-Pattern ( ), eingebettet in eine
Clean-Architecture und ist

> testbar (TDD). Folgende Abschnitte zeigen die Architektur, Best
> Practices und Beispielcode (inklusive Verzeichnisstruktur und
> Startpunkte).

# Audio-Framework und Pakete

- just_audio (aktuell v0.10.x): Ein *feature-reicher* Audioplayer für
  Flutter, der Streams, Assets, Dateien, Playlists, Gapless Playback,
  Shuffle und Loop unterstützt . Allerdings kümmert sich just_audio
  *nur* um die Wiedergabe, nicht um Hintergrundbetrieb oder
  System-Steuerung.

[1](https://pub.dev/packages/just_audio#%3A~%3Atext%3DA%20feature%2Casset%2Ffile%2FURL%2Fstream%29%20in%20gapless%20playlists)

[2](https://pub.dev/packages/audio_service#%3A~%3Atext%3Dclass%20MyAudioHandler%20extends%20BaseAudioHandler%20with%2Cin%20default%20seek%20callback%20implementations)

- audio_service (v0.18.x): Ein Wrapper, der Ihren bestehenden Audiocode
  (z.B. just_audio) kapselt,

> um Hintergrund-Audio zu ermöglichen und Standard-Media-Aktionen wie
> Play/Pause/Seek/ Shuffle/Repeat sowie Lock-Screen- und
> Benachrichtigungs-Steuerungen zu handhaben . Audio_Service erstellt
> für Android eine MediaSession und für iOS einen
> NowPlayingInfo-Channel. Beispiel: Durch AudioService.init(builder: ()
> =\> MyAudioHandler(), config:

[3](https://pub.dev/packages/audio_service#%3A~%3Atext%3DThis%20plugin%20wraps%20around%20your%2CIt%20is%20suitable%20for)

[4](https://pub.dev/packages/audio_service#%3A~%3Atext%3D_audioHandler%2Cnone%2Fall%2Fgroup)

> AudioServiceConfig(\...)) registrieren Sie Ihren AudioHandler beim
> App-Start
> [5](https://pub.dev/packages/audio_service#%3A~%3Atext%3DFuture) .

- audio_session (v0.2.x): Ergänzend konfiguriert dieses Plugin die
  *Audio-Session* von iOS/Android (Kategorie, Fokus, Ducking). Best
  Practice ist, nach allen anderen Audio-Plugins die Session zu
  konfigurieren (z.B. await

AudioSession.instance.configure(AudioSessionConfiguration.music())

> für Musik
>
> oder .speech() für Podcasts)
> [6](https://pub.dev/packages/audio_session#%3A~%3Atext%3DConfigure%20your%20app%27s%20audio%20session%2Creasonable%20defaults%20for%20playing%20music)
> .

- flutter_bloc: Implementiert das BLoC/MVVM-Muster in Flutter. Mit
  BlocProvider /

> RepositoryProvider kann man Repositories und Blöcke einspeisen
> [7](https://pub.dev/packages/flutter_bloc#%3A~%3Atext%3DRepositoryProvider%20is%20a%20Flutter%20widget%2Conly%20be%20used%20for%20repositories)
> . So ist der Code klar getrennt und leicht testbar.

Zusammen nehmen wir just_audio als Wiedergabe-Engine, umgeben von einem
AudioHandler

(audio_service), und steuern alles über BLoC-Events.

# AudioHandler: Background-Audio mit audio_service

Mit audio_service kapseln Sie die Audio-Logik in einem AudioHandler .
Dieser kommuniziert über

> play
>
> pause
>
> seek
>
> standardisierte Methoden (
>
> ,
>
> ,
>
> , skipToNext , setShuffleMode etc.) mit der

App-UI, dem Sperrbildschirm und Zubehör (Headsets, Smartwatches). Ein
typischer AudioHandler - Beispiel mit just_audio:

> class MyAudioHandler extends BaseAudioHandler with QueueHandler,
> SeekHandler {
>
> final \_player = AudioPlayer(); // just_audio
>
> MyAudioHandler() {
>
> // Hier könnten Sie beim Start vorladen oder Initial-States setzen.
>
> }
>
> \@override
>
> Future\<void\> play() =\> \_player.play();
>
> \@override
>
> Future\<void\> pause() =\> \_player.pause();
>
> \@override
>
> Future\<void\> stop() =\> \_player.stop();
>
> \@override
>
> Future\<void\> seek(Duration position) =\> \_player.seek(position);
>
> \@override
>
> Future\<void\> skipToQueueItem(int index) =\>
>
> \_player.seek(Duration.zero, index: index);
>
> // Zusätzliche Methoden für Shuffle/Repeat: \@override
>
> Future\<void\> setShuffleMode(AudioServiceShuffleMode mode) {
>
> // just_audio unterstützt Shuffle im Player:
>
> final enable = mode == AudioServiceShuffleMode.all;
>
> \_player.setShuffleModeEnabled(enable); return
> super.setShuffleMode(mode);
>
> }
>
> \@override
>
> Future\<void\> setRepeatMode(AudioServiceRepeatMode mode) {
>
> // Mappen von repeat/all/one auf just_audio LoopMode: LoopMode
> loopMode;
>
> if (mode == AudioServiceRepeatMode.one) loopMode = LoopMode.one;
>
> else if (mode == AudioServiceRepeatMode.all) loopMode = LoopMode.all;
> else loopMode = LoopMode.off;
>
> \_player.setLoopMode(loopMode); return super.setRepeatMode(mode);
>
> }
>
> }

Dieses Beispiel zeigt einen

mit Mixins

und

für

Standard-Callbacks . Die - etc. Methoden rufen einfach den
just_audio-Player

> BaseAudioHandler play() -, pause()
>
> QueueHandler
>
> SeekHandler

[2](https://pub.dev/packages/audio_service#%3A~%3Atext%3Dclass%20MyAudioHandler%20extends%20BaseAudioHandler%20with%2Cin%20default%20seek%20callback%20implementations)

> auf. Shuffle/Repeat setzen wir zusätzlich auf dem Player. Beim
> Initialisieren rufen wir später
>
> AudioService.init(builder: () =\> MyAudioHandler(), \...)
>
> main()

[5](https://pub.dev/packages/audio_service#%3A~%3Atext%3DFuture)

> Handler zu starten.
>
> im
>
> auf , um den

MediaItem & Metadaten: Für Sperrbildschirm und Benachrichtigungen ist es
wichtig, ein aktuelles zu setzen. Beispiel:

> var item = MediaItem(
>
> id: \'https://example.com/track.mp3\',
>
> MediaItem
>
> AudioService sendet diese Informationen automatisch an die
> Systemoberfläche (Android MediaSession
>
> title: \'Track Title\', artist: \'Artist Name\', album: \'Album
> Name\',
>
> duration: Duration(minutes: 3, seconds: 25), artUri:
> Uri.parse(\'https://example.com/cover.jpg\'),
>
> );
>
> \_audioHandler.playMediaItem(item);
>
> audio_service
>
> bzw. iOS NowPlaying) . Auf ähnliche Weise verwaltet eine Warteschlange
>
> queue

[8](https://pub.dev/packages/audio_service#%3A~%3Atext%3Dvar%20item%20%3D%20MediaItem%2Cjpg%27%29%2C)

> ( ) und Broadcasts über Streams.
>
> Hintergrundbetrieb: Einmal initialisiert, läuft Ihr AudioHandler in
> einem Hintergrund-Isolat. Er reagiert auf Medien-Tasten (Play/Pause
> auf Kopfhörern, Android Auto, Siri/Google-Befehle) automatisch über
>
> audio_service
>
> . Sie müssen nur die Methoden im Handler implementieren. Die Tabelle
> in der audio_service-Dokumentation zeigt alle unterstützten Features
> (Lock-Screen, Headset-Buttons, Shuffle, Repeat, Remote Controls) mit
> Häkchen für Android und iOS .

[9](https://pub.dev/packages/audio_service#%3A~%3Atext%3DFeature%20Android%20iOS%20macOS%20Web%2Cscreen%20controls%20%E2%9C%85%20%E2%9C%85%20%E2%9C%85)

# AudioService Initialisierung und Android/iOS Setup

> Beim App-Start initialisieren Sie typischerweise so:
>
> audio_service
>
> Sie können weitere Parameter angeben (Icons, Verbosity, etc.). Wichtig
> ist hier vor allem die Android-
>
> Future\<void\> main() async {
> WidgetsFlutterBinding.ensureInitialized();
>
> // AudioService-Initialisierung (speichern Sie \_audioHandler global
> oder via DI)
>
> \_audioHandler = await AudioService.init( builder: () =\>
> MyAudioHandler(), config: AudioServiceConfig(
>
> androidNotificationChannelId: \'com.example.app.audio\',
> androidNotificationChannelName: \'Audio Playback\',
> androidNotificationOngoing: true,
>
> ),
>
> );
>
> runApp(MyApp());
>
> }
>
> Notification-Channel-Konfiguration
> [5](https://pub.dev/packages/audio_service#%3A~%3Atext%3DFuture) . In
> AndroidManifest.xml müssen Sie außerdem
>
> WAKE_LOCK
>
> INTERNET ) und \<service\>

in Info.plist unter

> Berechtigungen (
>
> , FOREGROUND_SERVICE ,
>
> -Einträge

hinzufügen (siehe audio_service-Doku). Für iOS fügen Sie

> UIBackgroundModes
>
> audio
>
> den Eintrag hinzu (erlaubt Hintergrundwiedergabe).
>
> Tipp: AudioService bietet auch eine -Implementation (im
>
> JustAudioHandler
>
> [[just_audio_handlers]{.underline}](https://github.com/ryanheise/just_audio_handlers)
> Paket), die einige Schritte vereinfacht. Für volle Kontrolle empfiehlt
> sich jedoch ein eigener Handler wie oben.

Android MediaSession & iOS NowPlaying

AudioService richtet automatisch eine Android MediaSession ein und füllt
sie mit Ihrem

> MediaItem

sowie Status (Play/Pause, Position). Auf iOS verwendet es das
MPNowPlayingInfoCenter für Sperrbildschirm-Infos. In der Praxis müssen
Sie dafür nichts extra tun, außer in Ihrem

> MyAudioHandler
>
> mediaItem.add(\...)
>
> regelmäßig playbackState.add(\...) und zu
>
> [11](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3Dfinal%20_player%20%3D%20AudioPlayer)

schicken, damit System und UI aktuelle Informationen haben Handler:

> [10](https://pub.dev/packages/audio_service#%3A~%3Atext%3DBroadcast%20the%20current%20playback%20state%3A)
>
> . Beispiel für Status-Updates im
>
> AudioService überträgt diese Status-Streams an Benachrichtigung und
> Sperrbildschirm . Ihre Flutter- UI kann sich über
> \_audioHandler.playbackState subscriben (z.B. via StreamBuilder oder
> Bloc)
>
> // Wenn Sie z.B. \_player.play() aufrufen, senden Sie vorher:
> playbackState.add(playbackState.value.copyWith(
>
> playing: true,
>
> controls: \[MediaControl.pause\], processingState:
> AudioProcessingState.ready,
>
> ));
>
> // Bei Pause: playbackState.add(playbackState.value.copyWith(
>
> playing: false,
>
> controls: \[MediaControl.play\],
>
> ));
>
> [12](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3D%40override%20Future%2C%29%29%3B%20await%20_player.play%28%29%3B)

und so Icons aktualisieren
[13](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3Dchild%3A%20StreamBuilder%2ConPressed%3A%20_audioHandler.play)
.

# BLoC für Player-Steuerung und Zustand

Um Interaktion und Logik zu entkoppeln, setzen wir das BLoC-Pattern
(flutter_bloc) ein. Eine übliche Struktur:

- Events (PlayerEvent): , PauseEvent , SeekEvent , NextTrackEvent , etc.

> PlayEvent

- State (PlayerState): Enthält aktuellen Status, z.B. isPlaying ,
  position , duration ,

> currentTrack
>
> shuffleOn
>
> , , repeatMode , etc.

- Bloc (PlayerBloc): Nimmt Events entgegen, nutzt ein *AudioRepository*
  oder direkt den

> AudioHandler
>
> , ruft Methoden ( \_audioHandler.play() ) auf und emittiert neue
> States.
>
> Zusätzlich hört es auf Streams des AudioHandler, z.B. playbackState
> oder Positions-Updates, um den State fortlaufend zu aktualisieren.
>
> Beispiel (verkürzt):
>
> // Events
>
> abstract class AudioEvent {}
>
> class PlayPauseToggle extends AudioEvent {} class SeekPosition extends
> AudioEvent {
>
> final Duration position; SeekPosition(this.position);
>
> }
>
> // State
>
> class AudioState { final bool isPlaying;
>
> final Duration position; final Duration duration;
>
> AudioState({this.isPlaying=false, this.position=Duration.zero,
> this.duration=Duration.zero});
>
> }
>
> // BLoC
>
> class AudioBloc extends Bloc\<AudioEvent, AudioState\> { final
> AudioHandler \_audioHandler; StreamSubscription\<PlaybackState\>?
> \_stateSub; StreamSubscription\<MediaItem?\>? \_itemSub;
>
> AudioBloc(this.\_audioHandler) : super(AudioState()) {
>
> // Event-Handler on\<PlayPauseToggle\>((event, emit) async {
>
> final playing = state.isPlaying;
>
> if (playing) await \_audioHandler.pause(); else await
> \_audioHandler.play();
>
> // Zustand wird später durch StreamListener aktualisiert.
>
> });
>
> on\<SeekPosition\>((event, emit) {
>
> \_audioHandler.seek(event.position);
>
> });
>
> // \... weitere Events
>
> // Hör auf Hintergrund-Streams
>
> \_stateSub = \_audioHandler.playbackState.listen((playbackState) {
> final isPlaying = playbackState.playing;
>
> final position = playbackState.updatePosition; final duration =
> playbackState.processingState ==
>
> AudioProcessingState.ready
>
> ? playbackState.duration ?? Duration.zero
>
> : state.duration;
>
> add(\_PlaybackChanged(isPlaying, position, duration)); // internes
> Event
>
> });
>
> }
>
> \@override
>
> Future\<void\> close() {
>
> \_stateSub?.cancel();
>
> \_itemSub?.cancel(); return super.close();
>
> }
>
> // Internes Event zum Updaten
>
> void \_onPlaybackChanged(\_PlaybackChanged e, Emitter\<AudioState\>
> emit) { emit(AudioState(isPlaying: e.isPlaying, position: e.position,
> duration:
>
> e.duration));

Wichtig: Über RepositoryProvider / BlocProvider injizieren Sie den oder
ein

}

}

> AudioHandler

AudioRepository , was Tests und Austausch erleichtert . In Tests können
Sie dann den Handler mocken und das Bloc-Verhalten prüfen.

[7](https://pub.dev/packages/flutter_bloc#%3A~%3Atext%3DRepositoryProvider%20is%20a%20Flutter%20widget%2Conly%20be%20used%20for%20repositories)

# Beispiel UI mit BLoC

> flutter_bloc

Im UI-Bereich verwenden wir Widgets wie

> oder
>
> aus ,
>
> um auf Zustandsänderungen zu reagieren. Beispiel für ein
> Play/Pause-Widget:
>
> BlocBuilder
>
> BlocConsumer

Für die Fortschrittsanzeige (Seekbar) könnten wir
audio_video_progress_bar verwenden oder

> class PlayerControls extends StatelessWidget { \@override
>
> Widget build(BuildContext context) {
>
> return BlocBuilder\<AudioBloc, AudioState\>( builder: (context, state)
> {
>
> return Row(
>
> mainAxisAlignment: MainAxisAlignment.center, children: \[
>
> IconButton(
>
> icon: Icon(Icons.skip_previous), onPressed: () =\>
>
> context.read\<AudioBloc\>().add(PreviousTrackEvent()),
>
> ),
>
> IconButton(
>
> icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
> onPressed: () =\>
>
> context.read\<AudioBloc\>().add(PlayPauseToggle()),
>
> ),
>
> IconButton(
>
> icon: Icon(Icons.skip_next), onPressed: () =\>
>
> context.read\<AudioBloc\>().add(NextTrackEvent()),
>
> ),
>
> \],
>
> );
>
> },
>
> );
>
> }
>
> }
>
> Slider
>
> Timer

einen

, der die position / duration aus dem State anzeigt. Ein

oder

> StreamBuilder kann periodisch SeekPosition -Events feuern, oder der
> Bloc selbst sendet regelmäßig seine Position (siehe oben).

# Clean Architecture & Verzeichnisstruktur

Für saubere Architektur strukturieren wir den Code entlang der Schichten
(Domain, Data, Presentation). Beispiel:

- Repositories abstrahieren die Audiologik. Ein AudioRepositoryImpl kann
  z.B. Methoden wie play() , pause() , loadPlaylist(List\<MediaItem\>)
  bereitstellen und intern den AudioHandler ansprechen. So sind
  Business-Logik und Storage/Service entkoppelt -- ideal für Tests.

lib/

├── core/

Usecases-Interfaces

// Allgemeine Utilities, z.B. AudioModels,

│ └── models/

│ └── media_item.dart // Eigene Mediendaten (optional)

├── data/

│ └── audio/

│ ├── audio_repository_impl.dart // Implementierung, nutzt AudioHandler

│ └── audio_datasource.dart // z.B. AudioService-Schnittstelle

├── domain/

│ └── audio/

│ ├── entities/ // Domain-Modelle (MediaItem, Track)

│ ├── repositories/ // Abstrakte Interfaces (AudioRepository)

│ └── usecases/ // Anwendungsfälle (PlayUseCase, PauseUseCase usw.)

├── presentation/

│ └── blocs/

│ └── pages/

│ └── widgets/

├── main.dart

// Alle Blöcke (AudioBloc, ProgressBloc etc.)

// Bildschirme (AudioPlayerPage)

// Wiederverwendbare Widgets (Controls, TrackInfo)

// Startpunkt: DI (BlocProvider,

RepositoryProvider) und MyApp

> PlayTrack

- Use Cases können konkret definieren, welche Operation ausgeführt wird
  (z.B. ,

> ShufflePlaylist ).

- Blocs werden über RepositoryProvider instanziiert und können so in
  Tests durch Mock-

> Repositories ersetzt werden
> [7](https://pub.dev/packages/flutter_bloc#%3A~%3Atext%3DRepositoryProvider%20is%20a%20Flutter%20widget%2Conly%20be%20used%20for%20repositories)
> .

- Widgets/Pages kommunizieren nur über BLoC (Dispatch von Events, Lesen
  von States), und kennen keine Audio-Details.

# Tests und Best Practices

- Modultestbarkeit: Durch die Trennung über Interfaces sind Audio-Logik
  und UI leicht testbar.

> AudioHandler
>
> mocktail
>
> Man kann etwa den erwartete States prüfen.
>
> AudioHandler
>
> mocken (z.B. mit
>
> ) und den Bloc gegen

- Player-State-Handling: Verwenden Sie die Streams von (insbesondere

> playbackState
>
> mediaItem
>
> und ) als einzige Quelle der Wahrheit für den aktuellen Status.
>
> BLoC oder Widgets reagieren darauf, statt über lokale Flags zu
> verwalten .
>
> [14](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3DLet%27s%20update%20the%20audio%20handler%2Cthat%20we%27re%20loading%20the%20audio)
>
> [13](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3Dchild%3A%20StreamBuilder%2ConPressed%3A%20_audioHandler.play)

- Lifecycle: audio_service hält die Wiedergabe auch bei App-Hintergrund
  aktiv. Trotzdem sollten

> onStop()
>
> Sie Ressourcen freigeben: Im (bei der alten BackgroundAPI) oder beim
> Beenden der
>
> App
>
> AudioService.disconnect()
>
> nicht mehrfach zu initialisieren.
>
> WAKE_LOCK
>
> aufrufen. Achten Sie darauf,
>
> -Instanz

- Energieverwaltung: Fügen Sie in Android

> AudioHandler
>
> ein und in iOS das
>
> -Flag, damit
>
> die Wiedergabe auch bei ausgeschaltetem Bildschirm fortgesetzt wird.

- TDD: Schreiben Sie zunächst Tests für Ihre Blöcke und Use Cases, indem
  Sie das AudioHandler -Interface oder -Repository ersetzen. Beispiel:
  Testen, dass auf tatsächlich \_audioHandler.play() aufgerufen wird.

> PlayEvent

# Ressourcen und Beispielprojekte

- Dokumentation: Die offiziellen Pub-Seiten bieten ausführliche
  Beispiele ( Just Audio: Features

> audio

[1](https://pub.dev/packages/just_audio#%3A~%3Atext%3DA%20feature%2Casset%2Ffile%2FURL%2Fstream%29%20in%20gapless%20playlists)

[2](https://pub.dev/packages/audio_service#%3A~%3Atext%3Dclass%20MyAudioHandler%20extends%20BaseAudioHandler%20with%2Cin%20default%20seek%20callback%20implementations)

[8](https://pub.dev/packages/audio_service#%3A~%3Atext%3Dvar%20item%20%3D%20MediaItem%2Cjpg%27%29%2C)

> ; Audio Service: Grundlagen und Tutorials ).

- Tutorials: Surag Chincholi hat ein Schritt-für-Schritt-Tutorial (und
  begleitendes GitHub-Repo) erstellt, das die AudioService-Integration
  erklärt .

> [15](https://pub.dev/packages/audio_service#%3A~%3Atext%3D%2Cspeech%20use%20cases)
>
> [16](https://github.com/suragch/flutter_audio_service_demo#%3A~%3Atext%3DThis%20is%20a%20companion%20project%2CAudio%20about%20the%20audio_service%20plugin)

- GitHub-Boilerplates: Als Startpunkt kann das Repository
  [[suragch/flutter_audio_service_demo]{.underline}](https://github.com/suragch/flutter_audio_service_demo)
  dienen, das AudioService + just_audio kombiniert. Auch die offizielle
  AudioService-Beispiel-App (im Repository von ryanheise) zeigt viele
  Use-Cases.

[7](https://pub.dev/packages/flutter_bloc#%3A~%3Atext%3DRepositoryProvider%20is%20a%20Flutter%20widget%2Conly%20be%20used%20for%20repositories)

- Verlinkte Pakete: flutter_bloc-Doku (z.B.
  [[RepositoryProvider]{.underline}](https://pub.dev/documentation/flutter_bloc/latest/bloc/RepositoryProvider-class.html)
  für DI ) und audio_session-

[6](https://pub.dev/packages/audio_session#%3A~%3Atext%3DConfigure%20your%20app%27s%20audio%20session%2Creasonable%20defaults%20for%20playing%20music)

> Beispiel für Audio-Kategorien .
>
> Mit dieser Architektur erhalten Sie eine moderne, erweiterbare
> Audio-Streaming-Lösung für Flutter (3.x+), die alle geforderten
> Funktionen (Streams, Playlists, lokale Dateien, Shuffle/Repeat,
> Sperrbildschirm-Steuerung) sauber abbildet und leicht testbar bleibt.

Quellen: Offizielle Dokumentationen und Beispiele zu
[[just_audio]{.underline}](https://pub.dev/packages/just_audio) und
[[audio_service]{.underline}](https://pub.dev/packages/audio_service) ,
Einführungen und Tutorials .

[1](https://pub.dev/packages/just_audio#%3A~%3Atext%3DA%20feature%2Casset%2Ffile%2FURL%2Fstream%29%20in%20gapless%20playlists)

> [17](https://pub.dev/packages/audio_service#%3A~%3Atext%3DThis%20plugin%20wraps%20around%20your%2CAndroid%2C%20iOS%2C%20web%20and%20Linux)

[2](https://pub.dev/packages/audio_service#%3A~%3Atext%3Dclass%20MyAudioHandler%20extends%20BaseAudioHandler%20with%2Cin%20default%20seek%20callback%20implementations)

> [15](https://pub.dev/packages/audio_service#%3A~%3Atext%3D%2Cspeech%20use%20cases)

[6](https://pub.dev/packages/audio_session#%3A~%3Atext%3DConfigure%20your%20app%27s%20audio%20session%2Creasonable%20defaults%20for%20playing%20music)

> just_audio \| Flutter package

[1](https://pub.dev/packages/just_audio#%3A~%3Atext%3DA%20feature%2Casset%2Ffile%2FURL%2Fstream%29%20in%20gapless%20playlists)

<https://pub.dev/packages/just_audio>

> audio_service \| Flutter package
>
> [2](https://pub.dev/packages/audio_service#%3A~%3Atext%3Dclass%20MyAudioHandler%20extends%20BaseAudioHandler%20with%2Cin%20default%20seek%20callback%20implementations)
> [3](https://pub.dev/packages/audio_service#%3A~%3Atext%3DThis%20plugin%20wraps%20around%20your%2CIt%20is%20suitable%20for)
> [4](https://pub.dev/packages/audio_service#%3A~%3Atext%3D_audioHandler%2Cnone%2Fall%2Fgroup)
> [5](https://pub.dev/packages/audio_service#%3A~%3Atext%3DFuture)
> [8](https://pub.dev/packages/audio_service#%3A~%3Atext%3Dvar%20item%20%3D%20MediaItem%2Cjpg%27%29%2C)
> [9](https://pub.dev/packages/audio_service#%3A~%3Atext%3DFeature%20Android%20iOS%20macOS%20Web%2Cscreen%20controls%20%E2%9C%85%20%E2%9C%85%20%E2%9C%85)
> [10](https://pub.dev/packages/audio_service#%3A~%3Atext%3DBroadcast%20the%20current%20playback%20state%3A)
> [15](https://pub.dev/packages/audio_service#%3A~%3Atext%3D%2Cspeech%20use%20cases)
> [17](https://pub.dev/packages/audio_service#%3A~%3Atext%3DThis%20plugin%20wraps%20around%20your%2CAndroid%2C%20iOS%2C%20web%20and%20Linux)

<https://pub.dev/packages/audio_service>

> audio_session \| Flutter package

[6](https://pub.dev/packages/audio_session#%3A~%3Atext%3DConfigure%20your%20app%27s%20audio%20session%2Creasonable%20defaults%20for%20playing%20music)

<https://pub.dev/packages/audio_session>

> flutter_bloc \| Flutter package

[7](https://pub.dev/packages/flutter_bloc#%3A~%3Atext%3DRepositoryProvider%20is%20a%20Flutter%20widget%2Conly%20be%20used%20for%20repositories)

<https://pub.dev/packages/flutter_bloc>

> Tutorial · ryanheise/audio_service Wiki · GitHub
>
> [11](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3Dfinal%20_player%20%3D%20AudioPlayer)
> [12](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3D%40override%20Future%2C%29%29%3B%20await%20_player.play%28%29%3B)
> [13](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3Dchild%3A%20StreamBuilder%2ConPressed%3A%20_audioHandler.play)
> [14](https://github.com/ryanheise/audio_service/wiki/Tutorial#%3A~%3Atext%3DLet%27s%20update%20the%20audio%20handler%2Cthat%20we%27re%20loading%20the%20audio)

<https://github.com/ryanheise/audio_service/wiki/Tutorial>

> GitHub - suragch/flutter_audio_service_demo: Companion project for
> Flutter audio_service tutorial
>
> [16](https://github.com/suragch/flutter_audio_service_demo#%3A~%3Atext%3DThis%20is%20a%20companion%20project%2CAudio%20about%20the%20audio_service%20plugin)

<https://github.com/suragch/flutter_audio_service_demo>
