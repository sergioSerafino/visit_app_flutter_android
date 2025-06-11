<!--
Hinweis: Wenn mehrere Geräte/Emulatoren angeschlossen sind, muss die Device-ID beim Auslesen per Skript angegeben werden. Beispiel:

scripts\device_info_to_md.ps1 <Device-ID>

Die Device-ID findest du mit:
    adb devices

Das Skript kann so angepasst werden, dass die Device-ID als Parameter übernommen wird und alle adb-Befehle mit -s <Device-ID> ausgeführt werden.
-->
# DEVICES.md

## Zielgeräte für App-Optimierung

| Name/Modell              | Hersteller | Android-Version | Auflösung (px) | Pixeldichte (dpi) | Seitenverhältnis | Besonderheiten         |
|--------------------------|------------|-----------------|----------------|-------------------|------------------|-----------------------|
| SM-A217F                 | samsung    | 12              | 720x1600       | 280               |                  |                       |
| sdk_gphone64_x86_64      | Google     | 15              | 1280x2856      | 480               |                  |                       |
<!-- Weitere Geräte hier ergänzen -->

> **Tipp:**
> Fülle die Tabelle automatisiert mit dem Skript `scripts/device_info_to_md.ps1` aus.

## Geräteinfos automatisch auslesen

1. Gerät per USB anschließen und autorisieren
2. PowerShell öffnen und ausführen:
   ```powershell
   scripts\device_info_to_md.ps1 <Device-ID>
   ```
   (Device-ID findest du mit `adb devices`)
3. Die wichtigsten Infos werden in diese Tabelle übernommen.

---

## Responsive-Strategie

- Responsive Layouts mit MediaQuery, LayoutBuilder, OrientationBuilder
- Breakpoints für Smartphone/Tablet
- Schriftgrößen und Abstände dynamisch
- Siehe auch: lib/core/utils/device_info_helper.dart

---

## Siehe auch
- [Flutter Responsive Design Guide](https://docs.flutter.dev/development/ui/layout/responsive)
- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- [responsive_framework](https://pub.dev/packages/responsive_framework)
