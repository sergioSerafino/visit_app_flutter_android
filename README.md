# Flutter Template Projekt

Dieses Projekt ist ein modernes, best-practice-orientiertes Flutter-Template mit klarer Dokumentationsstruktur, Clean Architecture, State-Management (Riverpod/BLoC), automatisierten Tests und LLM/Automatisierungs-Support.

## Hinweise zur Projektstruktur
- Alle relevanten Best-Practices, Prinzipien und Vorgehensweisen wurden aus dem temporären Ordner `anderes_projekt` extrahiert und in die zentrale Dokumentation übernommen.
- Der Ordner `anderes_projekt` kann nach Abschluss der Template-Erstellung gelöscht werden und ist nicht Teil des eigentlichen Templates.

## Einstieg
- Lies die [GETTING_STARTED.md](GETTING_STARTED.md) für eine Schritt-für-Schritt-Anleitung.
- Siehe [CONTRIBUTING.md](CONTRIBUTING.md) für Mitwirkende.
- Siehe `.documents/` und `.instructions/` für alle Architektur-, Doku- und HowTo-Themen.

## Übersichtlichkeit & Struktur – Best Practices

- Klare, konsistente Ordner- und Dateistruktur (z.  B. domain, data, presentation, application, config, core)
- Sprechende, einheitliche Namen für Dateien, Klassen, Methoden und Variablen
- Kurze, prägnante Funktionen und Klassen (keine "God-Classes")
- Einrückung, Leerzeilen und Klammern nach Style Guide (siehe analysis_options.yaml)
- Kommentare nur dort, wo der Code nicht sprechend selbsterklärend ist, mit Praxisbezug und ggf. Quellenangabe
- Zentrale Ablage von Architektur, Prozessen und HowTos in `.documents/` und `.instructions/`
- Trennung von UI und Logik (State Management, keine Business-Logik in Widgets)
- Widget-Aufteilung: Komplexe UI in eigene Widgets/Funktionen auslagern
- Nutzung von const-Widgets, wo möglich
- Zentrale Styles und Theme-Konfiguration für konsistentes Aussehen
- Teststruktur: Trennung von unit, widget und integration tests in eigenen Ordnern
- Plattformspezifische Ordner und Konfigurationsdateien sauber halten
- Build-Skripte und CI/CD klar strukturieren und dokumentieren
- Feature Flags/Environment Configs für plattformspezifische Einstellungen
- Schritt-für-Schritt-Dokumentation für alle Deployment-Zielsysteme

## Code Style & Formatierung

- Nach jeder Widget- und Klassen-Definition folgt grundsätzlich eine Leerzeile.
- Diese Konvention dient der Übersichtlichkeit und Lesbarkeit und ist auch bei automatischer Formatierung (z.  B. mit `dart format`) zu beachten.
- Weitere Style-Konventionen siehe analysis_options.yaml.

**Quellen & Community-Standards:**
- [Flutter/Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Reso-Coder Tutorials](https://resocoder.com/?s=)
- [Flutter Clean Architecture (Reso-Coder)](https://resocoder.com/)
- [Very Good Ventures Best Practices](https://verygood.ventures/)
- [Flutter.dev Dokumentation](https://docs.flutter.dev/)

Viel Erfolg beim Projektstart und der Weiterentwicklung!

- Siehe `.documents/howto_snackbar.md` für die Nutzung und Erweiterung des SnackBar-Systems.

## Automatisierte Doku-Pflege

- Änderungen an Code, Architektur oder Tests müssen immer in der README.md und Doku-Matrix dokumentiert werden.
- Pre-Commit- und CI-Checks stellen sicher, dass die Doku aktuell bleibt.
- TODOs im Code werden regelmäßig in die Doku übernommen.
- Siehe `.documents/doku_matrix.md` für die zentrale Übersicht.

---

## Automatisierte Doku-Pflege – Bedienungsanweisung

Damit die Dokumentation immer aktuell bleibt, ist ein automatischer Pre-Commit-Hook eingerichtet:

1. **Was macht der Hook?**
   - Prüft, ob bei Änderungen an Code (z.  B. in `lib/`, `test/`, `application/`, `core/`, `presentation/`) auch die `README.md` aktualisiert wurde.
   - Falls nicht, wird der Commit abgebrochen und ein Hinweis ausgegeben.

2. **Wie aktiviere ich den Hook?**
   - Stelle sicher, dass PowerShell als Standard-Shell verwendet wird (Windows-Standard).
   - Die Datei `.git/hooks/pre-commit.ps1` ist bereits im Projekt enthalten.
   - Ggf. muss die Ausführung von Skripten erlaubt werden:
     - Öffne PowerShell als Administrator und führe aus:
       ```powershell
       Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned
       ```
     - (Nur einmalig nötig, falls noch nicht geschehen.)

3. **Wie funktioniert der Workflow?**
   - Bei jedem `git commit` prüft der Hook automatisch die Bedingungen.
   - Falls die Doku nicht aktualisiert wurde, erscheint eine gelbe Warnung und der Commit wird abgebrochen.
   - Aktualisiere dann die `README.md` und/oder `.documents/doku_matrix.md` und führe den Commit erneut aus.

4. **Wie kann ich den Hook anpassen oder deaktivieren?**
   - Passe das Skript in `.git/hooks/pre-commit.ps1` nach Bedarf an.
   - Um den Hook temporär zu deaktivieren, benenne die Datei um oder entferne sie.

**Hinweis:**
- Die automatisierte Doku-Pflege ist ein wichtiger Bestandteil der Projektqualität und hilft, die Übersicht und Nachvollziehbarkeit zu sichern.
- Siehe `.documents/doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien.

---

## Automatischer TODO-Scan aus dem Code

Um alle offenen TODOs im Code zentral zu dokumentieren, steht das Skript `scripts/scan_todos.ps1` zur Verfügung:

1. **Was macht das Skript?**
   - Durchsucht alle relevanten Code-Ordner (`lib/`, `test/`, `application/`, `core/`, `presentation/`) nach `// TODO:`-Kommentaren.
   - Schreibt alle gefundenen TODOs mit Pfad und Zeilennummer in die Datei `TODOs_aus_Code.md` im Projektverzeichnis.

2. **Wie führe ich das Skript aus?**
   - Stelle sicher, dass PowerShell-Skripte ausgeführt werden dürfen (siehe oben).
   - Im Projektverzeichnis ausführen:
     ```powershell
     .\scripts\scan_todos.ps1
     ```
   - Die Datei `TODOs_aus_Code.md` wird automatisch erstellt oder aktualisiert.

3. **Empfohlener Workflow:**
   - Vor jedem Release oder Sprint-Ende das Skript ausführen, um alle offenen TODOs zu konsolidieren.
   - Die Datei `TODOs_aus_Code.md` regelmäßig prüfen und offene Punkte priorisieren.
   - Optional: Die TODO-Liste in den Status-Report oder die Doku-Matrix übernehmen.

**Hinweis:**
- Der automatisierte TODO-Scan hilft, technische Schulden und offene Aufgaben im Blick zu behalten und transparent zu dokumentieren.
- Siehe auch die Bedienungsanweisung zur automatisierten Doku-Pflege oben.

---

## Legacy-/Migrationshinweise (aus storage_hold)

Dieses Template-Projekt wurde aus dem Altprojekt `storage_hold` migriert.

- Ursprünglicher Projektname: **storage_hold**
- Historischer Hinweis: Grundständiges Testprojekt für die Flutter App mit dem Mediendatenteil remote (API) und lokal (Mock).
- Siehe auch: `.documents/doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).

---

## Automatisierte Integration des TODO-Scans in den Pre-Commit-Hook

Um sicherzustellen, dass alle TODOs vor jedem Commit automatisch erfasst werden, kann das Skript `scripts/scan_todos.ps1` direkt im Pre-Commit-Hook aufgerufen werden:

**So funktioniert es:**
- Der Pre-Commit-Hook ruft vor jedem Commit automatisch das Skript auf.
- Die Datei `TODOs_aus_Code.md` wird immer aktuell gehalten.
- Entwickler:innen werden so an offene TODOs erinnert und können diese gezielt pflegen.

**Integration in `.git/hooks/pre-commit.ps1`:**
Füge am Anfang des Pre-Commit-Hooks folgende Zeile ein:

```powershell
# Automatischer TODO-Scan vor jedem Commit
& scripts/scan_todos.ps1
```

**Empfohlener Workflow:**
- Vor jedem Commit werden alle TODOs im Code automatisch gescannt und dokumentiert.
- Prüfe die Datei `TODOs_aus_Code.md` regelmäßig und übertrage wichtige Punkte in die Status-Doku oder Doku-Matrix.

---

## Abschluss-Review & Refactoring-Checkliste (31.05.2025)

**1. Letztes Refactoring vor Entfernung des Quell-Projekts:**
- [ ] Unbenutzte Imports entfernen (siehe Lint-Warnungen)
- [ ] Lint-Warnungen und Hinweise (z.  B. Redundanzen, Annotationen, Super-Parameter) beheben
- [ ] Lesbarkeit und Struktur nach SOLID und Clean Architecture prüfen (keine God-Classes, klare Verantwortlichkeiten)
- [ ] Testabdeckung für alle kritischen UseCases, Services und Provider sicherstellen
- [ ] Automatisierte Tests und Linting vor jedem Merge/Release ausführen

**2. Abschließender Review:**
- [ ] Review-Checkliste aus Status-Report und Doku-Matrix durchgehen
- [ ] Alle Muss-Kriterien aus PRD/MVP und Architektur-Doku erfüllt
- [ ] Alle Kern-User-Flows funktionieren stabil (Code & UI geprüft)
- [ ] Fallback- und Placeholder-Logik überall abgedeckt und getestet
- [ ] UI/UX: Keine groben Brüche, alle wichtigen Elemente zugänglich
- [ ] Architektur: Clean, testbar, keine kritischen TODOs
- [ ] Testabdeckung: Alle kritischen Services/Provider mit Unit-/Integrationstests
- [ ] Offene Bugs/TODOs dokumentiert und priorisiert

**3. Quell-Projekt entfernen:**
- [ ] Sicherstellen, dass alle relevanten Inhalte aus `storage_hold` übernommen und dokumentiert sind
- [ ] Ordner `storage_hold` und ggf. `_migration_src` entfernen
- [ ] Schritt in der Migrationsmatrix und im Changelog dokumentieren

**Hinweis:**
- Nach Abschluss dieser Checkliste ist das Zielprojekt vollständig eigenständig, wartbar und zukunftssicher.
- Die Clean Architecture, SOLID-Prinzipien und Best Practices sind dokumentiert und umgesetzt.
- Die Entfernung des Quell-Projekts ist damit risikolos möglich.

---

## Remote-Repository klonen und lokal einrichten

Um das bereinigte Projekt auf einer neuen Maschine oder in einem neuen Arbeitsverzeichnis zu nutzen, gehe wie folgt vor:

```powershell
cd G:\ProjekteFlutter\
git clone https://github.com/sergioSerafino/visit_app_flutter_android.git
cd .\visit_app_flutter_android
# Optional: Auf den gewünschten Branch wechseln
# git checkout dev
flutter pub get
```

Ab jetzt kannst du wie gewohnt Änderungen vornehmen, mit `git add`, `git commit` und `git push` versionieren und alles mit dem Remote-Repository synchronisieren.

---

### ✅ Branch-Workflow für Entwicklung und MVP-Veröffentlichung

Für eine saubere, nachvollziehbare Entwicklung und eine effiziente MVP-Veröffentlichung empfiehlt sich folgender Branch-Workflow:

#### 🔁 Branch-Struktur

- **main**: Stabile Produktions-/Release-Version. Nur getestete, veröffentlichungsreife Commits werden hier gemerged.
- **dev**: Aktive Entwicklungsbasis. Hier werden alle Features, Bugfixes und Integrationen zusammengeführt und getestet, bevor sie auf main gemerged werden.
- **feature/<name>**: Für einzelne Features, Experimente oder Bugfixes. Nach Fertigstellung Merge in dev.

#### ⚙️ Typischer Workflow

**1. Start:**
- Repository klonen und dev-Branch auschecken.

**2. Neues Feature beginnen:**
```powershell
git checkout dev
git pull
git checkout -b feature/<feature-name>
```

**3. Entwicklung:**
- Im Feature-Branch arbeiten und regelmäßig committen.

**4. Merge in dev:**
```powershell
git checkout dev
git pull
git merge feature/<feature-name>
git push
```

**5. Release-Vorbereitung (MVP):**
```powershell
git checkout main
git pull
git merge dev
git push
```

#### 🏷️ Tagging – Projektzustände markieren (optional, empfohlen)

Verwende Tags, um wichtige Projektzustände dauerhaft zu dokumentieren:

| Zweck        | Beschreibung                        | Beispiel             |
|--------------|-------------------------------------|----------------------|
| Release      | Versionierung                       | v1.0.0               |
| Deployment   | Genaue Deploy-Stände (z.  B. Prod)   | prod-2024-06-01      |
| Milestone    | Relevante Projektpunkte             | after-refactor       |
| Review       | Review-fertiger Stand               | pre-review-audio     |
| Archivierung | Letzter Stand vor Branch-Delete     | archived-feature-x   |

**Beispielhafte Befehle:**
```powershell
git tag v1.0.0
git tag prod-2024-06-01
git tag -a after-refactor -m "Nach Refactoring"
git push --tags
git log -3 --oneline
```

#### 📌 Hinweise

- Feature-Branches können nach dem Merge gelöscht werden:
  ```powershell
  git branch -d feature/<feature-name>
  ```
- Hotfixes für die Produktion können direkt von main abgezweigt werden.
- Für größere Teams: Pull-Requests / Merge-Requests nutzen.
- Tags helfen bei Reproduzierbarkeit, Debugging, Rollbacks und Releases – nicht nur für Versionen!

#### 🗂 Empfohlene Branch-Namen

- **main** – Release/Produktiv
- **dev** – Entwicklung
- **feature/<feature-name>** – z.  B. feature/audio-player

Weitere Details und Beispiele siehe [MIGRATION_HISTORY.md](./MIGRATION_HISTORY.md) und [GETTING_STARTED.md](./GETTING_STARTED.md).

## Git-Hinweis zu nicht gestagten Änderungen

Wenn du Änderungen an Dateien vorgenommen hast, die noch nicht für den nächsten Commit vorgemerkt ("gestaged") sind, zeigt `git status` folgenden Hinweis an:

```
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
```

**Bedeutung:**
- Die aufgelisteten Dateien wurden geändert, sind aber noch nicht für den nächsten Commit vorgemerkt.
- Mit `git add <datei>` kannst du die Änderungen zum Commit vormerken (stagen).
- Mit `git restore <datei>` kannst du die Änderungen an der Datei wieder verwerfen.

**Empfohlener Workflow:**
1. Prüfe mit `git status`, welche Dateien geändert wurden.
2. Verwende `git add <datei>`, um gewünschte Änderungen zu stagen.
3. Führe `git commit` aus, um die gestagten Änderungen zu speichern.
4. Optional: Mit `git restore <datei>` kannst du einzelne Änderungen zurücksetzen.

Weitere Infos: [Git Dokumentation](https://git-scm.com/docs/git-status)

---

## Best Practice: Architektur- und Pattern-Review mit externen Ressourcen (z.  B. Reso Coder)

Um die Codequalität und Architekturentscheidungen kontinuierlich zu verbessern, empfiehlt sich folgender Workflow:

1. **Recherche und Review:**
   - Nutze externe Ressourcen wie die [Reso-Coder Tutorials](https://resocoder.com/?s=) gezielt für Architektur- und Pattern-Reviews.
   - Suche nach relevanten Begriffen (z.  B. "BLoC", "Clean Architecture", "Testing") und vergleiche die eigene Implementierung mit den dort empfohlenen Best Practices.
   - Dokumentiere die wichtigsten Erkenntnisse und Abweichungen direkt in der Projekt-Doku (z.  B. in `.documents/bloc_best_practices_2024.md`).

2. **Empfohlener Ablauf:**
   - **Schritt 1:** Website aufrufen und nach dem gewünschten Pattern/Begriff suchen.
   - **Schritt 2:** Die eigene Implementierung mit den Best Practices aus den Tutorials vergleichen.
   - **Schritt 3:** Ergebnisse und Optimierungsvorschläge dokumentieren und ggf. umsetzen.
   - **Schritt 4:** Lessons Learned und Review-Tabellen in der Doku ergänzen.

---

## Audio-Playback: Verhalten beim Öffnen der EpisodeDetailPage

- **Kein Autoplay:** Beim Navigieren zur EpisodeDetailPage wird die Audiodatei **nicht** automatisch abgespielt.
- **Preload/Buffering:** Die Audiodatei wird im Hintergrund vorgepuffert (mittels `setUrl`), sodass ein schneller Start beim Play-Button möglich ist.
- **Start der Wiedergabe:** Playback beginnt **erst**, wenn der Nutzer explizit auf den Play-Button im BottomPlayerWidget drückt.
- **Testabdeckung:** Ein automatisierter Widget-Test (`test/presentation/pages/episode_detail_no_autoplay_test.dart`) stellt sicher, dass kein Autoplay erfolgt und das Preload korrekt funktioniert.
- **UX-Hinweis:** Diese Optimierung verbessert die Startzeit beim Play und verhindert unerwünschtes Autoplay.

## Audio-Playback: Play/Pause-UX & State-Maschine (Juni 2025)

- Die Play/Pause-Logik im AudioPlayerBloc folgt ab Juni 2025 einer deterministischen State-Maschine ohne Event-Buffering.
- Play/Pause-Events werden nur im passenden State verarbeitet, ansonsten ignoriert oder mit Snackbar quittiert.
- Die UI aktiviert den Play/Pause-Button nur, wenn die Aktion möglich ist (z.B. nicht während Loading).
- Nach jedem Event wird sofort der neue State emittiert, damit die UI direkt reagiert.
- Tests prüfen explizit schnelles, mehrfaches Klicken auf Play/Pause.
- Ziel: Sofortige, robuste UX wie bei führenden Playern (Apple Podcasts, just_audio).

## Audio-Player: Teststrategie & Lessons Learned (Juni 2025)

Siehe auch: [docs/audio_player_best_practices_2025.md](docs/audio_player_best_practices_2025.md) für Details, Codebeispiele und Best Practices.

- Die Widget- und BLoC-Tests für den Audio-Player (insbesondere BottomPlayerWidget) wurden 2025 grundlegend modernisiert und beschleunigt.
- Alle relevanten States (Idle, Loading, Playing, Paused, Error) werden in den Tests gezielt simuliert und geprüft.
- Provider-Overrides und Mock-Backends sorgen für deterministische, schnelle Testläufe (meist < 2 s pro Test).
- Nach jedem Test wird der Widget-Baum abgeräumt, um Pending-Timer-Fehler (z.  B. durch das Marquee-Widget) zu vermeiden.
- **Wichtiger Hinweis:** Einzelne Tests, die das Marquee-Widget oder animierte Timer nutzen (z.  B. Slider-Resume-Test), sind mit `skip: true` markiert, da Flutter hier einen bekannten Pending-Timer-Bug aufweist. Die eigentliche Player-Funktionalität ist durch andere, stabile Tests abgedeckt. Siehe Querverweis und Kommentar im Test.
- Die Lessons Learned und alle Test- und UX-Prinzipien sind in der zentralen Doku dokumentiert.

**Quellen & weiterführende Doku:**
- [audio_player_best_practices_2025.md](docs/audio_player_best_practices_2025.md)
- [audio_architektur_2025.md](docs/audio_architektur_2025.md)
- [bloc_best_practices_2024.md](.documents/bloc_best_practices_2024.md)

---

## Synchronisation von just_audio-Backend und Flutter-UI (Speed/Volume)

**Problem:**
- Die nativen Streams von just_audio (z.B. speedStream, volumeStream) liefern nicht auf allen Plattformen oder in allen Versionen zuverlässig Events.
- Die Flutter-UI (Dropdown, Slider etc.) muss aber immer sofort und reaktiv den aktuellen Wert anzeigen, auch wenn dieser asynchron oder verzögert gesetzt wird.

**Lösung (Best Practice):**
- Nach jedem erfolgreichen Setzen eines Wertes (z.B. setSpeed, setVolume) wird der aktuelle Wert explizit in einen eigenen StreamController gepusht (z.B. _speedController.add(_speed)).
- Die UI (z.B. per StreamBuilder) hört auf diesen Stream und erhält so IMMER ein Event, auch wenn just_audio intern keinen Stream-Event liefert.
- Das gilt analog für Lautstärke (volume):
  - Nach setVolume() -> _volumeController.add(_volume)

**Lessons Learned:**
- Verlasse dich nicht ausschließlich auf die nativen Streams von just_audio, sondern ergänze eigene Streams für alle UI-relevanten Werte.
- So bleibt die UI immer synchron mit dem Backend, unabhängig von Plattform, Player-Status oder Race-Conditions.

**Beispiel für Speed:**
```dart
Future<void> setSpeed(double speed) async {
  await _audioPlayer.setSpeed(speed);
  _speed = speed;
  _speedController.add(_speed); // Manuelles Event für die UI
}
```
**Beispiel für Volume (analog umsetzen!):**
```dart
Future<void> setVolume(double volume) async {
  await _audioPlayer.setVolume(volume);
  _volume = volume;
  _volumeController.add(_volume); // Manuelles Event für die UI
}
```

**Siehe auch:**
- bottom_player_speed_dropdown.dart
- Volume-Fader-Widget
- Doku-Kommentare in lib/core/services/audio_player_bloc.dart

---

## Archivierte/Legacy-Dokumentation

Die Inhalte aus `docs/legacy/` wurden in diese zentrale Dokumentation übernommen:

> Hier werden veraltete, aber historisch oder für spätere Nachvollziehbarkeit relevante Doku-Abschnitte und Code-Fragmente abgelegt.
> - Vor dem endgültigen Entfernen aus dem Projekt werden Inhalte hier gesichert.
> - In der zentralen Doku wird auf diesen Ordner verwiesen.
> - Jede Migration oder größere Änderung wird im Changelog und/oder in der Doku-Matrix dokumentiert.
> 
> **Hinweis:**
> Bitte prüfe vor dem Löschen, ob die Information vollständig und aktuell in der neuen Architektur/Doku abgedeckt ist.

Der Ordner `docs/legacy/` kann nach erfolgreicher Migration entfernt werden.

---

## ToDo: AirPlay/Chromecast-Erweiterung (Juni 2025)

**Ausgangslage & Architektur-Empfehlung:**

- Die aktuelle Audio-Architektur basiert auf einer klaren Trennung von Systemintegration (`AudioHandler`/`audio_service`) und App-Logik (`IAudioPlayerBackend`, z.  B. `JustAudioPlayerBackend`).
- Der `AudioPlayerBloc` vermittelt zwischen UI und Backend und ist über Provider flexibel erweiterbar.
- Die UI und der BLoC sind unabhängig von der konkreten Backend-Implementierung und konsumieren nu das Interface.
r
**Empfehlung für AirPlay/Chromecast:**

1. **Neues Backend anlegen:**
   - Implementiere ein neues Backend (z.B. `AirPlayAudioBackend`, `CastAudioBackend`), das das Interface `IAudioPlayerBackend` erfüllt.
   - Nutze passende Pakete (z.B. [airplay](https://pub.dev/packages/airplay), [cast](https://pub.dev/packages/cast)) für die jeweilige Plattform.
2. **AudioHandler erweitern:**
   - Ergänze die Systemintegration in `MyAudioHandler` um AirPlay/Cast-spezifische Logik (Session-Management, Device Discovery, etc.), falls Lockscreen/Headset/Notification auch für diese Backends benötigt werden.
3. **Provider anpassen:**
   - Im Provider kann je nach Plattform oder User-Wahl das passende Backend injiziert werden.
   - Beispiel:
     ```dart
     final audioPlayerBlocProvider = Provider<AudioPlayerBloc>((ref) {
       // return AudioPlayerBloc(backend: AirPlayAudioBackend());
       // return AudioPlayerBloc(backend: CastAudioBackend());
       return AudioPlayerBloc(backend: JustAudioPlayerBackend());
     });
     ```
4. **UI bleibt unverändert:**
   - Die UI und der BLoC müssen nicht angepasst werden, da sie nur das Interface kennen.

**Fazit:**
- Die Architektur ist bereits optimal vorbereitet für AirPlay/Cast.
- Es genügt, ein neues Backend nach dem Vorbild von `JustAudioPlayerBackend` zu implementieren und im Provider zu verwenden.
- Die Systemintegration (z.B. Lockscreen, Headset, Notification) kann über den `AudioHandler` erweitert werden.

**Optional:**
- Für AirPlay/Cast-Status im UI kann das Interface um entsprechende Streams/Properties erweitert werden.
- Für plattformübergreifende Features (z.B. Multiroom) kann das Backend flexibel erweitert werden.

---

# TODO: Flexible Lokalisierungskonfiguration für die App

## Konzept (siehe auch hosts_page.dart und preferences_page.dart)

- **Lokalisierungsquellen:**
  - System-Lokalisierung (Flutter: Localizations.localeOf(context))
  - Content-Lokalisierung (z. B. aus Collection/Content)
  - Benutzereinstellung (über preferences_page)

- **Einstellungsoptionen in preferences_page:**
  - „Automatisch (System)“
  - „Sprache aus Collection/Content“
  - Liste aller unterstützten Sprachen (Dropdown)

- **Speicherung:**
  - Auswahl persistent in SharedPreferences

- **Verwendung:**
  - App verwendet die gewählte Locale für Übersetzungen und Formatierungen (intl, AppLocalizations, DateFormat etc.)
  - Beispiel-Logik (siehe hosts_page.dart):
    ```dart
    Locale getAppLocale(BuildContext context, String? userPref, String? contentLocale) {
      if (userPref == 'system' || userPref == null) {
        return Localizations.localeOf(context);
      } else if (userPref == 'content' && contentLocale != null) {
        return Locale(contentLocale);
      } else {
        return Locale(userPref); // z.B. 'de', 'en'
      }
    }
    ```

- **Vorteile:**
  - Maximale Flexibilität für den User
  - App kann dynamisch auf Content-Lokalisierung reagieren
  - Einheitliche Formatierung und Übersetzung

**Querverweise:**
- hosts_page.dart (Datumsausgabe, dynamische Felder)
- preferences_page.dart (Einstellungen für Sprache)
- README.md (Architektur/UX)

## Dynamische Lokalisierung in den Models

- Das Modell `LocalizationConfig` enthält:
  - `defaultLanguageCode`: Bevorzugte Sprache für Content oder UI (z.  B. aus RSS oder JSON)
  - `localizedTexts`: Map für dynamisch geladene Übersetzungen (z.  B. Buttonlabels, Begrüßung etc.)

- Diese Felder können genutzt werden, um UI-Elemente oder Content dynamisch in der passenden Sprache anzuzeigen.
- Beispiel: Wenn `localizedTexts['welcome']` existiert, kann dieser Wert anstelle eines statischen Strings angezeigt werden.
- Die eigentliche dynamische Lokalisierung ist im Modell vorbereitet, wird aber in der UI aktuell nur für das Datumsfeld genutzt.

**Querverweis:** Siehe auch hosts_page.dart und preferences_page.dart für die Verwendung und geplante Erweiterung.

---

# TODO für nächsten Meilenstein: Zentrale Nutzung von PodcastHostCollection und Auslagerung aller RSS-Metadaten

- Nach Abschluss des aktuellen Refactorings soll die gesamte App (insbesondere HostsPage und alle UI-Widgets) ausschließlich mit dem zentralen, persistenten Modell `PodcastHostCollection` arbeiten.
- Alle RSS-Metadaten (z.  B. Website, Impressum, Kontakt) und Host-Infos werden im MergeService in das Modell übernommen und stehen dann persistent zur Verfügung.
- Die UI greift nur noch auf das Modell zu, keine Einzelabrufe oder Provider-Logik mehr in Widgets.
- Siehe dazu die Doku-Quellen:
  - `.instructions/adr-001-merge-strategy.md` (Merge-Strategie & Priorisierung)
  - `.instructions/howto_merge_caching.md` (Caching & Persistenz)
  - `.instructions/howto_merge_decisions_and_field_sources.md` (Feldherkunft & Mapping)
  - `.instructions/prd_white_label_podcast_app.md` (Architektur, Datenfluss)
  - `lib/tenants/HOWTO_BRANDING_TENANTS.md` (Branding, Fallback)

---

# Hinweis zur RSS-Metadaten-Bearbeitung (Admin/Entwicklung)

- Das Widget `HostRssMetaTile` bleibt auch nach der Umstellung auf persistente Speicherung der RSS-Metadaten im Modell einsatzbereit.
- Es dient als Fallback und Werkzeug für Admin- und Entwicklungsarbeiten, um RSS-Felder (z.  B. E-Mail, Website, Impressum) weiterhin dynamisch und aktuell aus dem Feed anzuzeigen und zu prüfen.
- Auch nach der Persistenz kann es für Debugging, Migration und initiale Bearbeitung genutzt werden.
- Siehe auch: `.instructions/adr-001-merge-strategy.md`, `.instructions/howto_merge_decisions_and_field_sources.md`, `.instructions/prd_white_label_podcast_app.md`.

---

## Repository-Pattern & flexible API-Parameter (zukunftssicher)

**Ziel:**
- Die Steuerung von API-Parametern wie `limit` (z. B. Anzahl der iTunes-Ergebnisse) erfolgt zentral, plattformunabhängig und ist leicht auf andere APIs adaptierbar.
- Die UI und UseCases sind unabhängig von der konkreten API-Implementierung (iTunes, Spotify, Mock etc.).

**Umsetzung:**
- Das Interface `PodcastRepository` nimmt alle relevanten API-Parameter (limit, country, entity, media) als optionale Parameter entgegen.
- Die Implementierungen (`ApiPodcastRepository`, `MockPodcastRepository` etc.) reichen diese Parameter an die jeweilige API oder Mock-Logik weiter.
- Das Ergebnis-Limit wird immer aus dem zentralen Provider (`itunesResultCountProvider`) geholt und an das Repository übergeben.
- Die Provider (z. B. `podcastCollectionProvider`, `podcastEpisodeProvider`) sind so gestaltet, dass sie das Limit automatisch weiterreichen.
- Ein Plattformwechsel (z. B. von iTunes zu Spotify) ist durch Austausch der Repository-Implementierung möglich, ohne die UI oder UseCases anzupassen.

**Querverweise:**
- `lib/data/repositories/podcast_repository.dart` (Interface)
- `lib/data/repositories/api_podcast_repository.dart` (API-Implementierung)
- `lib/data/repositories/mock_podcast_repository.dart` (Mock-Implementierung)
- `lib/application/providers/itunes_result_count_provider.dart` (zentraler Provider für das Limit)
- `lib/application/providers/podcast_provider.dart` (Provider-Logik)

**Best Practices:**
- Siehe Kommentare und Docstrings in den oben genannten Dateien.
- Die Architektur folgt Clean Architecture und ist für zukünftige API-Erweiterungen vorbereitet.
- Die Tests und Mocks müssen nach Interface-Änderungen neu generiert werden (siehe Build-Runner-Hinweis).

---

## TODOs & Empfehlungen für Caching und Fallback-Strategie

- Hinweis-Felder für HostsPage ergänzen, wenn Host-Informationsfelder (z. B. aus RSS) noch nicht verfügbar sind. (Siehe auch `.documents/migration_plan_podcast_cache_hivebox.md`)
- Retry-Mechanismus für RSS-Abruf und Merge implementieren. (Siehe `.instructions/howto_merge_caching.md`)
- Validierungslogik für Cache und API-Abruf klar dokumentieren und ggf. als Utility/Service kapseln. (Siehe PRD und `.instructions/adr-001-merge-strategy.md`)
- Lessons Learned und typische Fehlerquellen weiterhin dokumentieren (z. B. in `.documents/migration_plan_podcast_cache_hivebox.md`)

---

## Nächste Schritte für robustes Caching

1. **Analyse:**
   - Prüfen, wie die Provider (`podcastCollectionProvider`, `podcastEpisodeProvider`) auf den Cache zugreifen und welche Bedingungen zu Fallbacks führen.
   - Reihenfolge: Cache → API → Placeholder.
2. **Definition des Soll-Verhaltens:**
   - Was soll im Cache landen? (Komplette Collection, Episoden, Metadaten?)
   - Wie lange ist ein Cache-Eintrag gültig? (TTL, Timestamp)
   - Was ist der gewünschte Fallback?
3. **Gezieltes, seitenweises Testen:**
   - Caching für einzelne Seiten/Use-Cases gezielt aktivieren und UI-Verhalten beobachten.
   - Fehlerquellen und Nebeneffekte dokumentieren.

**Querverweise:**
- `.documents/migration_plan_podcast_cache_hivebox.md`
- `.instructions/howto_merge_caching.md`
- `.instructions/adr-001-merge-strategy.md`
- PRD: `.instructions/prd_white_label_podcast_app.md`
