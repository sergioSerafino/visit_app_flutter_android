# Overlay- und AppBar-Handling: Globale und lokale Steuerung

## Übersicht

Die AppBar und die BottomNavigationBar passen sich beim Scrollen (z. B. in der HostsPage) brandingkonform an und zeigen einen Overlay-/Schatteneffekt, wie man es von Flutter erwartet. Die Steuerung erfolgt zentral und robust über einen Riverpod StateNotifier.

## Globale Steuerung (Provider)
- Der Overlay-Status wird über den Provider `overlayHeaderProvider` (StateNotifier) verwaltet.
- Jede Seite (z. B. HostsPage) kann den Overlay-Status setzen, indem sie beim Scrollen den Provider aktualisiert.
- Die HomePage liest den Overlay-Status aus dem Provider und passt AppBar und BottomNavigationBar entsprechend an.
- Beim Tabwechsel wird der Overlay-Status automatisch zurückgesetzt, wenn der neue Tab keinen Overlay benötigt.

## Lokale Steuerung (ScrollController)
- Jede Seite, die den Overlay-Effekt steuern soll, besitzt einen eigenen ScrollController.
- Im Scroll-Callback wird geprüft, ob gescrollt wurde (offset > 0) und der Overlay-Status entsprechend gesetzt.
- Die Verwaltung der Controller erfolgt robust im initState/dispose.

## AppBar und BottomNavigationBar
- Die Overlay-/Schattenfarbe wird direkt als Hintergrundfarbe gesetzt:
  - Im Light Mode: Brandingfarbe + Schwarz-Overlay (Color.alphaBlend).
  - Im Dark Mode: Brandingfarbe + ElevationOverlay.
- Die AppBar bleibt brandingkonform, der homeHeader ist immer linksbündig.
- Die BottomNavigationBar zieht farblich mit und erhält denselben Overlay-Effekt.

## Vorteile
- Keine State-Leaks oder Race Conditions durch zentrale Provider-Logik.
- Flutter-typisches Verhalten (AppBar und BottomBar reagieren wie erwartet).
- Einfach erweiterbar für weitere Tabs oder Seiten.

---
Letzte Aktualisierung: 19.06.2025
