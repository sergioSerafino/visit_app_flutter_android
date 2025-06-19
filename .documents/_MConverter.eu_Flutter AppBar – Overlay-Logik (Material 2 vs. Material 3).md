![](media/ra4tflz2.png){width="0.2829855643044619in"
height="0.2829855643044619in"}![](media/lmutjzuj.png){width="0.9878007436570428in"
height="0.1701388888888889in"}

**Flutter** **AppBar** **--** **Overlay-Logik** **(Material** **2**
**vs.** **Material** **3)**

**Zusammenfassung:** In Flutter steuert die *Overlay-Logik* von AppBar,
wie sich Hintergrundfarbe, Material-Elevation und Farbüberlagerungen
(sog. *Surface* *Tint* oder *Elevation* *Overlay*) verhalten. Bei
Material 2 (bisheriger Standard) wurden Schatten und bei dunklen Themes
zusätzliche weiße Überlagerungen verwendet, um Erhebungen sichtbar zu
machen. In Material 3 (Flutter 3.x) kommt ein
**surfaceTintColor**-Mechanismus hinzu, der die AppBar-Farbe je nach
Elevation mit dem Farbton des Oberflächenmusters überblendet. Die
folgenden Abschnitte erläutern den Ablauf im Quellcode von Flutter
(AppBar- und Material-Implementierung) und zeigen, wie Entwickler
Einfluss nehmen können.

**Material** **2** **vs.** **Material** **3** **--** **Standardwerte**
**und** **Farbwahl**

> • **Material** **2** **(Voreinstellungen):** In früheren
> Flutter-Versionen (Material 2) ist die Standard-Hintergrundfarbe der
> AppBar ColorScheme.primary im Hellen Theme,
>
> ColorScheme.surface im Dunklen
> [1](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2454%20Color%3F%20get%20backgroundColor%20%3D,60)
> . Die Standard-Elevation beträgt 4.0 (Schattenfarbe schwarz)
> [2](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2440%20class%20_AppBarDefaultsM2%20extends%20AppBarTheme,637%3A%20kToolbarHeight%2C%202447)
> . Beispiel:
>
> // Defaults M2 (aus Flutter-Quellcode): elevation: 4.0,
>
> shadowColor: Color(0xFF000000), toolbarHeight: kToolbarHeight (56dp),
>
> backgroundColor: (brightness==dark) ? colorScheme.surface :
> colorScheme.primary,
>
> foregroundColor: (brightness==dark) ? colorScheme.onSurface :
> colorScheme.onPrimary,
>
> • **Material** **3** **(Voreinstellungen):** Ab Flutter 3 nutzt man
> Material 3-Design. Die AppBar-Hintergrundfarbe ist standardmäßig
> colorScheme.surface
> [3](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2496%20%40override%202497%20Color%3F%20get,Colors%20.%20647)
> , die Elevation 0.0 (kein Schatten), stattdessen wird bei
> scrolledUnderElevation (Standard 3.0) ein Elevations-Effekt angewendet
> [4](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2485%20elevation%20%3A%200,0%2C%202489)
> . Die Toolbar-Höhe erhöht sich auf 64dp
> [4](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2485%20elevation%20%3A%200,0%2C%202489)
> . Die Standard-**shadowColor** und **surfaceTintColor** sind in M3
> Colors.transparent
> [3](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2496%20%40override%202497%20Color%3F%20get,Colors%20.%20647)
> , d.h. keine voreingestellte Farbüberlagerung oder Schattenwurf. Als
> Default-Vordergrundfarbe gilt
>
> colorScheme.onSurface
> [3](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2496%20%40override%202497%20Color%3F%20get,Colors%20.%20647)
> .

**Hintergrundfarbe** **mit** **MaterialState** **(scrolledUnder)**

Im AppBar -Build-Code wird zuerst die *Basis*-Hintergrundfarbe
ermittelt. Die Reihenfolge ist dabei: **Widget-Property** (
AppBar.backgroundColor ), dann **AppBarTheme.backgroundColor**, dann
Default-Wert (aus \_AppBarDefaultsM2 oder \_AppBarDefaultsM3 ) [5
6](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=900%20final%20Color%20backgroundColor%20%3D,backgroundColor%21%2C%20905%20%29%3B%20906)
. Zusätzlich berücksichtigt Flutter den *MaterialState* scrolledUnder :
Bei einer scrollenden Seite kann die AppBar beim „Unter-Scrollen"
(überlappt wird) eine andere Farbe verwenden (z.B.

> colorScheme.surfaceContainer bei M3). Das geschieht so (vereinfacht):
>
> 1
>
> Set\<MaterialState\> states = \<MaterialState\>{
>
> if (settings?.isScrolledUnder ?? \_scrolledUnder)
> MaterialState.scrolledUnder,
>
> };
>
> Color backgroundColor = \_resolveColor(states, widget.backgroundColor,
> appBarTheme.backgroundColor, defaults.backgroundColor!);
>
> Color scrolledUnderBackground = \_resolveColor(states,
> widget.backgroundColor, appBarTheme.backgroundColor,
> Theme.of(context).colorScheme.surfaceContainer);
>
> Color effectiveBackgroundColor =
> states.contains(MaterialState.scrolledUnder) ? scrolledUnderBackground
>
> : backgroundColor;

Diese Logik nutzt MaterialStateProperty.resolveAs , damit z.B. auch
*MaterialStateColor*-Objekte passend aufgelöst werden können
[5](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=900%20final%20Color%20backgroundColor%20%3D,backgroundColor%21%2C%20905%20%29%3B%20906)
[7](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=914%20final%20Color%20effectiveBackgroundColor%20%3D,scrolledUnderBackground%20%20%3A%20%20201)
. Dadurch bekommt die AppBar etwa im gescrollten Zustand eine leicht
abgewandelte Farbe (typisch dunkleres Grau im M3-Design).

**Elevation** **und** **Farbüberlagerungen** **(ElevationOverlay**
**vs.** **Surface** **Tint)**

Je nach Material-Version wird die finale Farbe der AppBar- Material
-Komponente anders berechnet:

> • **Material** **2:** Das Material -Widget der AppBar nimmt bei
> nicht-transparenter Form meist die Basisfarbe und nutzt
> ElevationOverlay.applyOverlay , um bei dunklem Theme je nach elevation
> eine weiße Transluzenz darüber zu legen
> [8](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/material.dart.html#:~:text=501%20final%20Color%20color%20%3D,23)
> . Das ergibt im Dunkelmodus einen
>
> Aufhellungseffekt proportional zur Erhebung. Beispiel (aus
> Flutter-Source):
>
> if (!useMaterial3) {
>
> final Color color = ElevationOverlay.applyOverlay(context,
> backgroundColor, elevation);
>
> // \... -\> setzt color als endgültige Material-Farbe }
>
> (In hellem Theme bleibt einfach die Basisfarbe, und der Schatten wird
> durch shadowColor sichtbar.)
>
> • **Material** **3:** Hier wird **kein** weißer Overlay mehr genutzt
> (Material 3 eliminiert applyOverlay
> [9](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html#:~:text=69%20%2F%2F%2F%20Applies%20an%20overlay,overlay%20is%20no%20longer%20used)
> ). Stattdessen verwendet Flutter ein *surface* *tint*: Das Material
> -Widget führt
>
> ElevationOverlay.applySurfaceTint(color, surfaceTint, elevation) aus
> [8](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/material.dart.html#:~:text=501%20final%20Color%20color%20%3D,23)
> . Dabei wird der übergebene surfaceTintColor (z.B. aus dem Theme oder
> der AppBar-Eigenschaft) mit einer opazitäts-adaptierten Version auf
> die Basisfarbe aufgeblendet
> [10](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html#:~:text=19%20%2F%2F%2F%20Applies%20a%20surface,color%20to%20indicate%20they%20are)
> . Flutter-Quellcode:
>
> 2
>
> if (theme.useMaterial3) {
>
> // M3: Farbton-Overlay je nach Elevation
>
> final Color finalColor = ElevationOverlay.applySurfaceTint(
> backgroundColor, widget.surfaceTintColor, widget.elevation);
>
> // \... setzt finalColor als Material-Farbe } else {
>
> // M2: klassisches Overlay (nur im dunklen Theme)
>
> final Color finalColor = ElevationOverlay.applyOverlay( context,
> backgroundColor, widget.elevation);
>
> }
>
> Dabei ist widget.surfaceTintColor standardmäßig null (oder
> AppBarTheme.surfaceTintColor ), und Flutter nutzt als Fallback
> theme.colorScheme.surfaceTint (z.B. Marken-Farbton)
> [11](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=%3F%3F%20defaults%20,surfaceTint%20%3A%20null)
> . Praktisch bedeutet das: Bei
>
> Höhe \> 0 erscheint die AppBar-Fläche im Material 3-Standard leicht
> mit dem Oberflächenfarbton überlagert -- ein subtiler Farbwechsel,
> sichtbar im Zusammenspiel von Elevation und
>
> surfaceTintColor .

**Rolle** **von** **AppBarTheme** **und** **MaterialTheme**

> • **AppBarTheme:** Bestimmt Standardwerte für AppBar-Eigenschaften.
> Beispielsweise kann man AppBarTheme(surfaceTintColor: \...) festlegen.
> Wird surfaceTintColor hier
>
> definiert, überschreibt es das Theme-Fallback. Ähnlich für
> backgroundColor , foregroundColor , shadowColor etc. Ist nichts
> gesetzt, greift der *default* aus \_AppBarDefaultsM2/M3
> [12](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=MaterialType%20,scrolledUnderElevation)
> . Wichtig: In M3 ist der Default für surfaceTintColor
> Colors.transparent
> [13](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2502%20%40override%202503%20Color%3F%20get,647%3B%202507)
> , was bedeutet, dass ohne eigenes Tint-Setting kein Farbton-Effekt
>
> genutzt wird.
>
> • **MaterialTheme** **(ThemeData):** Das Flag theme.useMaterial3
> entscheidet in AppBar, ob M3-Logik angewendet wird (siehe Code-Auswahl
> M2 vs M3-Defaults)
> [14](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=IconButtonTheme%20,context)
> . Viele Farben kommen aus
>
> theme.colorScheme . So definiert das Theme z.B. colorScheme.surface
> für die Standard-Hintergrundfarbe in M3, colorScheme.onSurface für
> Schrift-/Icon-Farbe
> [3](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2496%20%40override%202497%20Color%3F%20get,Colors%20.%20647)
> . Im Dunkelmodus wird ggf. colorScheme.primary/onPrimary (M2) oder nur
> onSurface (M3) verwendet
> [1](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2454%20Color%3F%20get%20backgroundColor%20%3D,60)
> [3](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2496%20%40override%202497%20Color%3F%20get,Colors%20.%20647)
> . Diese Themewerte fließen in backgroundColor und foregroundColor ein.

**Praktische** **Anpassungen** **/** **Beispielcode**

> • **Custom** **surfaceTintColor** **:** Möchte man den
> Überlagerungseffekt manuell steuern, kann man surfaceTintColor im
> AppBar (oder AppBarTheme) setzen. Beispiel:
>
> AppBar(
>
> backgroundColor: Colors.white,
>
> surfaceTintColor: Colors.red, // statt Transparent elevation: 4,
>
> )
>
> 3
>
> Dann erhält die AppBar bei Elevation=4 einen leichten Rotton (Opacity
> = Funktion(von Elevation) aus der Material3-Definition
> [10](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html#:~:text=19%20%2F%2F%2F%20Applies%20a%20surface,color%20to%20indicate%20they%20are)
> ). Will man **kein** Overlay, setzt man surfaceTintColor:
> Colors.transparent .
>
> • **MaterialState-Farben:** Mit MaterialStateColor lassen sich
> unterschiedliche Farben für scrolledUnder definieren:
>
> AppBar(
>
> backgroundColor: MaterialStateColor.resolveWith((states) { return
> states.contains(MaterialState.scrolledUnder)
>
> ? Colors.grey\[800\]! : Colors.blue;
>
> }), elevation: 4,
>
> )
>
> Die AppBar ruft intern \_resolveColor auf, sodass sie automatisch
> zwischen „normaler" und „unter-gescrollter" Farbe wechselt
> [5](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=900%20final%20Color%20backgroundColor%20%3D,backgroundColor%21%2C%20905%20%29%3B%20906)
> .
>
> • **ThemeData/AppBarTheme:** Man kann im ThemeData globale
> Standardwerte festlegen:
>
> ThemeData( useMaterial3: true,
>
> appBarTheme: AppBarTheme( backgroundColor: Colors.blueGrey,
> surfaceTintColor: Colors.green, elevation: 4,
>
> ), )
>
> Dann verwenden alle AppBars diese Defaults, wenn sie selbst nichts
> spezifizieren. • **Manuelle** **Overlay-Berechnung:** Wer eigene
> Berechnungen benötigt, kann direkt
>
> ElevationOverlay nutzen:
>
> Color computeOverlay(Color baseColor, double elevation) { return
> ElevationOverlay.applySurfaceTint(
>
> baseColor,
>
> Colors.red, // eigener Farbton elevation,
>
> ); }
>
> Dies entspricht dem Material3-Standard-Algorithmus
> [10](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html#:~:text=19%20%2F%2F%2F%20Applies%20a%20surface,color%20to%20indicate%20they%20are)
> und erlaubt z.B. eigene Tint-Formeln.

**Quellen** **und** **Referenzen**

> • Flutter-Quellcode **AppBar** (Build-Logik): Zeigt den Umgang mit
> backgroundColor , surfaceTintColor , elevation und
> MaterialState.scrolledUnder
> [5](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=900%20final%20Color%20backgroundColor%20%3D,backgroundColor%21%2C%20905%20%29%3B%20906)
> [15](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=1203%20color%3A%20theme%20,surfaceTintColor)
> .
>
> • Flutter-Quellcode **Material** ( material.dart ): Implementierung
> des eigentlichen Renderns, u.a. ElevationOverlay.applySurfaceTint vs.
> applyOverlay
> [8](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/material.dart.html#:~:text=501%20final%20Color%20color%20%3D,23)
> [10](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html#:~:text=19%20%2F%2F%2F%20Applies%20a%20surface,color%20to%20indicate%20they%20are)
> .
>
> 4
>
> • Flutter-Quellcode **ElevationOverlay** ( elevation_overlay.dart ):
> Beschreibt, wie bei M3 der Farbton-Overlay berechnet wird (Alpha-Blend
> abhängig von Elevation)
> [10](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html#:~:text=19%20%2F%2F%2F%20Applies%20a%20surface,color%20to%20indicate%20they%20are)
> .
>
> • Flutter-Quellcode **AppBarTheme-Defaults**: Unterschiedliche
> Defaults für M2/M3 (Elevation, Farben, Toolbar-Höhe)
> [2](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2440%20class%20_AppBarDefaultsM2%20extends%20AppBarTheme,637%3A%20kToolbarHeight%2C%202447)
> [4](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2485%20elevation%20%3A%200,0%2C%202489)
> .

[1](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2454%20Color%3F%20get%20backgroundColor%20%3D,60)
[2](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2440%20class%20_AppBarDefaultsM2%20extends%20AppBarTheme,637%3A%20kToolbarHeight%2C%202447)
[3](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2496%20%40override%202497%20Color%3F%20get,Colors%20.%20647)
[4](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2485%20elevation%20%3A%200,0%2C%202489)
[5
6](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=900%20final%20Color%20backgroundColor%20%3D,backgroundColor%21%2C%20905%20%29%3B%20906)
[7](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=914%20final%20Color%20effectiveBackgroundColor%20%3D,scrolledUnderBackground%20%20%3A%20%20201)
[11](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=%3F%3F%20defaults%20,surfaceTint%20%3A%20null)
[12](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=MaterialType%20,scrolledUnderElevation)
[13](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=2502%20%40override%202503%20Color%3F%20get,647%3B%202507)
[14](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=IconButtonTheme%20,context)
[15](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html#:~:text=1203%20color%3A%20theme%20,surfaceTintColor)
app_bar.dart \[flutter/packages/flutter/lib/src/material/
app_bar.dart\] - Codebrowser

<https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/app_bar.dart.html>

[8](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/material.dart.html#:~:text=501%20final%20Color%20color%20%3D,23)
material.dart
\[flutter/packages/flutter/lib/src/material/material.dart\] -
Codebrowser
<https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/material.dart.html>

[9](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html#:~:text=69%20%2F%2F%2F%20Applies%20an%20overlay,overlay%20is%20no%20longer%20used)
[10](https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html#:~:text=19%20%2F%2F%2F%20Applies%20a%20surface,color%20to%20indicate%20they%20are)
elevation_overlay.dart
\[flutter/packages/flutter/lib/src/material/elevation_overlay.dart\]
-Codebrowser

<https://codebrowser.dev/flutter/flutter/packages/flutter/lib/src/material/elevation_overlay.dart.html>

> 5
