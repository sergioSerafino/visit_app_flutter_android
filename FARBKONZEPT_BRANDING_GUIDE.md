# Farbgebung & Branding in der App (IST-Zustand & Empfehlungen)

## 1. IST-Zustand: Farbverwendung in der App

- **Theme/ColorScheme:**
  - Viele Stellen nutzen `Theme.of(context).colorScheme.primary`, `secondary`, `surface`, `surfaceTint` usw.
  - Overlay/Scrolleffekte nutzen Utility mit `surfaceTint` (Flutter-konform).
- **Branding-Farben:**
  - Aus dem Host-Modell: `host.branding.primaryColorHex`, `host.branding.secondaryColorHex` (meist als Basisfarbe für Header, Buttons, etc.).
  - Fallback: Wenn Branding-Farbe fehlt, wird auf Theme-Farbe zurückgegriffen.
- **Kein zentrales Farbkonzept:**
  - Es gibt keine zentrale Stelle, die aus 1-2 Branding-Farben ein vollständiges ColorScheme (inkl. Nuancen, Dark/Light) generiert.
  - Nuancen, Helligkeitsstufen, Dark/Light-Varianten werden nicht systematisch aus den Branding-Farben abgeleitet.

## 2. Problem & Ziel

- **Problem:**
  - Mit nur 1-2 Branding-Farben ist es schwer, ein konsistentes, modernes und barrierefreies UI zu gestalten (insb. für Dark/Light-Mode, Overlays, Nuancen).
  - Flutter/Material3 erwartet ein vollständiges ColorScheme (mind. 5-8 Hauptfarben + Nuancen).
- **Ziel:**
  - Aus den Branding-Farben (primary, secondary) ein vollständiges ColorScheme generieren (inkl. surface, background, error, onPrimary, ...).
  - Automatische Ableitung von Nuancen (heller/dunkler), ggf. mit Algorithmen wie HSLuv, MaterialColor, oder Tools wie FlexColorScheme.
  - Dark/Light-Mode und Overlays systematisch unterstützen.

## 3. Empfohlener Ansatz (Flutter-konform)

- **a) Zentrale Farb-Utility:**
  - Schreibe eine Utility, die aus 1-2 Hex-Farben ein vollständiges ColorScheme generiert (z. B. mit FlexColorScheme oder eigener Logik).
  - Beispiel: `generateColorSchemeFromBranding(primary, secondary)`
- **b) ThemeData dynamisch erzeugen:**
  - Erzeuge das Theme (inkl. ColorScheme) dynamisch beim Start/bei Tenant-Wechsel.
  - Setze das Theme global per Provider/State.
- **c) Nuancen & Overlays:**
  - Nutze Algorithmen wie HSLuv, MaterialColor, oder FlexColorScheme, um Nuancen (heller/dunkler) zu berechnen.
  - Für Overlays: Nutze weiterhin die Utility mit surfaceTint, aber sorge dafür, dass surfaceTint sinnvoll aus dem Branding abgeleitet wird.
- **d) Dokumentation & Querverweise:**
  - Diese Datei dient als zentrale Doku und Einstiegspunkt für alle Farbthemen.
  - Querverweise auf: `core/utils/color_utils.dart`, Theme-Provider, Branding-Modell.

## 4. Weiteres Vorgehen

- Schrittweise Migration: Bestehende Stellen, die direkt Branding-Farben nutzen, auf das zentrale ColorScheme umstellen.
- Testen: UI in Light/Dark-Mode, mit verschiedenen Branding-Farben.
- Optional: FlexColorScheme als Package nutzen (https://pub.dev/packages/flex_color_scheme) für professionelle Material3-Farbpaletten.

---

**Querverweise:**
- Farb-Utility: `lib/core/utils/color_utils.dart`
- Theme-Provider: (ggf. anlegen)
- Branding-Modell: `host.branding.primaryColorHex`, `host.branding.secondaryColorHex`

**Letztes Update:** 2025-06-19
