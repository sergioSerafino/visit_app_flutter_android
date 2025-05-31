<!-- Siehe auch: ../doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->

# AirPlay/Chromecast Architektur & ToDo (Stand: 28.05.2025)

## Ziel
Eine zukunftssichere, testbare und modulare Integration von AirPlay und Chromecast für Audio-Playback im BottomPlayerWidget und der gesamten App.

---

## Architektur-Skizze

**1. Service-Layer:**
- `CastAirPlayService` (Interface):
  - Discovery von Cast/AirPlay-Geräten
  - Verbindungsaufbau/-abbau
  - Status-Stream (isAvailable, isConnected, deviceName)
  - Abstraktion für verschiedene Plattformen/Plugins
- Implementierungen:
  - `CastAirPlayServiceChromecast` (z.B. mit `cast`-Paket)
  - `CastAirPlayServiceAirPlay` (z.B. mit `flutter_to_airplay`)
  - Mock für Tests

**2. Provider-Layer:**
- `castAirPlayProvider` (Riverpod StateNotifier/Provider):
  - Kapselt Service, stellt Status und Events für die UI bereit
  - Ermöglicht Mocking und Testbarkeit

**3. UI-Layer:**
- `CastAirPlayButton` (Widget):
  - Zeigt Cast/AirPlay-Icon, Status (verbunden/verfügbar/ausgegraut)
  - OnPressed: Verbindungsaufbau/-abbau, Geräteauswahl (optional)
  - Accessibility: Semantics-Label, Statusanzeige
- Integration in `BottomPlayerWidget` und ggf. `EpisodeDetailPage`

**4. AudioPlayerBloc/Service:**
- Erweiterung um Casting-Events und -States (z.B. `StartCasting`, `StopCasting`, `CastingError`)
- State: `isCasting`, `castingDeviceName`, Fehlerbehandlung
- UI kann Player-Steuerung auch während Casting anbieten

**5. Teststrategie:**
- Mock-Implementierung für Service und Provider
- Widget- und Integrationstests für Button, Status, State-Wechsel
- Testfälle: Gerät verfügbar/nicht verfügbar, verbunden/getrennt, Fehlerfall

---

## ToDo-Liste für Integration

1. [ ] Interface & Mock für `CastAirPlayService` anlegen
2. [ ] Riverpod-Provider für Cast/AirPlay-Status implementieren
3. [ ] UI-Widget `CastAirPlayButton` mit Statusanzeige und Semantics-Labels
4. [ ] Integration in `BottomPlayerWidget` (UI, State, Events)
5. [ ] Erweiterung von `AudioPlayerBloc` um Casting-Events/-States
6. [ ] Implementierung (Stub) für Chromecast (z.B. mit `cast`-Paket)
7. [ ] Implementierung (Stub) für AirPlay (z.B. mit `flutter_to_airplay`)
8. [ ] Widget- und Integrationstests für Button, Provider, State-Wechsel
9. [ ] Doku & Lessons Learned ergänzen (architecture.md)

---

## Hinweise & Best Practices
- Plattformabhängige Features immer über Interface + Provider abstrahieren
- UI-Logik und Plattformcode strikt trennen (Clean Architecture)
- Accessibility und Statusanzeige von Anfang an berücksichtigen
- Schrittweise Integration: Erst UI/Provider/Mock, dann echte Plattform-Implementierung

---

*Diese Datei dient als Architektur- und ToDo-Referenz für die AirPlay/Chromecast-Integration. Sie wird laufend aktualisiert und ergänzt.*
