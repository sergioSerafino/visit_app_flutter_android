# DEV/ENV-Flag & kDebugMode für Fehlerausgabe

<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->

## Ziel
- Fehler und Debug-Ausgaben (z. B. ungültige CollectionId, CRUD-Operationen) werden nur im Debug-Mode (`kDebugMode`) an Entwickler ausgegeben
- Im Produktivmodus bleibt die User-Experience ruhig und vertrauenswürdig

## Umsetzung
- Nutze `import 'package:flutter/foundation.dart';` und `if (kDebugMode) { ... }`
- Beispiel:
```dart
if (kDebugMode) {
  print('Nur im Debug-Mode sichtbar!');
}
```
- In allen relevanten Services und Providern für Logging, Fehlerausgabe und Dev-Only-Features verwenden

## Nächste Schritte
- kDebugMode für weitere Services (MergeService, FeatureFlags, CRUD in Hive) übernehmen
- Dokumentation und Best Practices ergänzen

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Ursprünglicher Hinweis: DEV/ENV-Flag & kDebugMode für Fehlerausgabe, Logging und Dev-Only-Features.
- Siehe auch: `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Weitere Best Practices und Anwendungsbeispiele im Altprojekt dokumentiert.
