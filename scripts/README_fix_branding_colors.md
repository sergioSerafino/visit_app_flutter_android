# Branding-Checker & Auto-Fixer für secondaryColorHex

Dieses Skript (`fix_branding_colors.dart`) prüft alle `host_model.json`-Dateien im Verzeichnis `lib/tenants/` und setzt fehlende oder ungültige `secondaryColorHex`-Werte im Branding automatisch auf einen gewünschten Placeholder (Standard: `#EEEEEE`).

## Verwendung

1. **Voraussetzung:** Dart SDK installiert (wird mit Flutter geliefert)
2. **Ausführen:**
   ```powershell
   dart scripts/fix_branding_colors.dart
   ```
3. **Ergebnis:**
   - Alle Brandings werden geprüft.
   - Fehlende/ungültige `secondaryColorHex` werden automatisch gesetzt und die Datei wird überschrieben.
   - Das Skript gibt eine Liste der korrigierten Dateien aus oder meldet, dass alles korrekt ist.

## Typische Anwendungsfälle
- Nach dem Einpflegen neuer Mandanten/Brandings
- Vor Release/Deployment als QS-Check
- Als Pre-Commit-Hook oder im CI/CD-Workflow

## Anpassung
- Der Placeholder-Wert kann im Skript (Konstante `placeholderSecondary`) angepasst werden.

## Beispiel-Ausgabe
```
✔️  secondaryColorHex in lib/tenants/collection_1469653179/host_model.json gesetzt auf #EEEEEE
Fertig. 1 Branding(s) korrigiert.
```

## Hinweise
- Das Skript ist idempotent und kann beliebig oft ausgeführt werden.
- Es werden nur Dateien geändert, bei denen ein Fehler gefunden wurde.

---

**Tipp:**
Für weitere Branding-Checks oder Automatisierungen kann das Skript leicht erweitert werden (z. B. Prüfung auf gültige Hex-Werte, Prüfung anderer Branding-Felder etc.).
