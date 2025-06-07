# AudioFeature TODO: Einheitliche Anzeige der Abspieldauer im Player-UI

**Sachverhalt:**
- Die duration im Player kommt aktuell aus dem Audio-Backend, konkret aus der just_audio-Integration (`_audioPlayer.duration`).
- just_audio liest die Dauer aus den Metadaten der Mediendatei/des Streams.
- Die Podcast-API liefert `trackTimeMillis` als erwartete Länge laut Server.
- Diese Werte können voneinander abweichen (z.B. fehlerhafte Metadaten, Livestreams, API-Fehler).
- Im Player-UI und im Bloc wird immer die aktuelle duration aus dem Backend (just_audio) verwendet, weil nur diese garantiert mit dem tatsächlich geladenen Stream übereinstimmt. Die API-Angabe (`trackTimeMillis`) wird nur als Fallback oder zum Vergleich genutzt.
- Im Debug-Log werden beide Werte ausgegeben, um Abweichungen sichtbar zu machen.

**Offene Frage/Lösung zu finden:**
- Welche Abspieldauer (duration) soll im UI abgebildet werden?
  - just_audio.duration (wie aktuell, entspricht tatsächlicher Datei)?
  - trackTimeMillis (API-Wert)?
  - Beides anzeigen? Fallback-Logik?
- Ziel: Einheitliche, nachvollziehbare Anzeige der Abspieldauer im Player-UI.

## Ergänzung: Logik der Zeit-Anzeige (links/rechts) im Player-UI

**Aktuelles Verhalten:**
- Die linke Zeit zeigt immer die aktuelle Abspielposition an (z.B. 0:00 im Preload/Paused(0)-State).
- Die rechte Zeit zeigt die verbleibende Zeit (negativ, z.B. -1:00), sobald eine gültige Duration vom Backend (just_audio) vorliegt.
- Ist keine gültige Duration bekannt (z.B. im ungeladenen Zustand), wird rechts ein Fallback-Wert ("0h 0m 0s") angezeigt.

**Begründung:**
- Die linke Zeit spiegelt exakt die aktuelle Position wider, unabhängig vom Ladezustand.
- Die rechte Zeit ist an die Verfügbarkeit einer echten Duration gebunden, da nur dann eine Restzeit berechnet werden kann.
- Dieses Verhalten entspricht dem UX-Standard moderner Audio-Player (Spotify, Apple Podcasts etc.).

**Sonderfall Preload/Paused(0):**
- Nach Preload (Paused, position=0, duration>0) zeigt der Player links "0h 00m 00s" und rechts z.B. "-0h 01m 00s" (bei 60s Duration).
- Erst wenn keine Duration bekannt ist, steht rechts der Fallback.

**Empfehlung:**
- Dieses Verhalten ist gewollt und sollte in der UI-Dokumentation so festgehalten werden.
- Optional: Im Fallback-Zustand kann ein Platzhalter wie "--:--" verwendet werden, um die Unterscheidung zu verdeutlichen.

---
