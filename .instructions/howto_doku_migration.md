# HowTo: Doku-Migration – Zentrale Übernahme und Vereinheitlichung der Dokumentation

## 1. Universeller Best Practice: Rekursive Suche nach Markdown-Dateien

**Vor jeder Migration müssen alle Projektordner rekursiv nach Markdown-Dateien (`.md`) durchsucht werden!**

> In Altprojekten sind Doku-Dateien oft verstreut (z.B. in Feature-, Build- oder Unterordnern). Um vollständige und zentrale Dokumentation im Zielprojekt zu gewährleisten, müssen alle `.md`-Dateien identifiziert und übernommen werden.

**Empfohlener PowerShell-Befehl:**
```powershell
Get-ChildItem -Path "<Projektpfad>" -Filter *.md -Recurse | Select-Object FullName
```
> Ersetze `<Projektpfad>` durch das Quellprojekt-Root (z.B. `G:\ProjekteFlutter\storage_hold`).

## 2. Vorgehen bei der Migration
1. Führe die rekursive Suche nach `.md`-Dateien im Quellprojekt durch und verschaffe dir einen Überblick über alle vorhandenen Doku-Dateien.
2. Überführe alle relevanten Markdown-Dateien in die zentrale Doku-Struktur des Templates (`.documents`, `.instructions`, README.md etc.).
3. Vergleiche und mergen die Inhalte gemäß [howto_doku_instruction_merge.md](../.documents/howto_doku_instruction_merge.md).
4. Entferne veraltete, redundante oder projektspezifisch nicht mehr relevante Doku.
5. Aktualisiere Querverweise und Links.
6. Führe abschließend einen Review auf Vollständigkeit und Konsistenz durch.

## 3. Hinweise
- Dokumentiere im Migrationsprotokoll, welche Dateien übernommen, angepasst oder entfernt wurden.
- Halte dich an die Best-Practice-Struktur für zentrale, LLM-freundliche Dokumentation.
