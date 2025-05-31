# Wichtiger Best Practice: Vor jeder Migration rekursiv nach Markdown-Dateien suchen

**Bevor du mit dem Doku-/Instruction-Merge beginnst, führe in allen Projektordnern eine rekursive Suche nach Markdown-Dateien (`.md`) durch!**

> Hintergrund: In Altprojekten sind Doku-Dateien oft verstreut (z.B. in Unterordnern, Build-/Feature-Ordnern, etc.). Um keine relevante Dokumentation zu verlieren, müssen alle `.md`-Dateien identifiziert und zentral übernommen werden.

**Empfohlener PowerShell-Befehl:**
```powershell
Get-ChildItem -Path "<Projektpfad>" -Filter *.md -Recurse | Select-Object FullName
```
> Ersetze `<Projektpfad>` durch das Wurzelverzeichnis deines Quellprojekts (z.B. `G:\ProjekteFlutter\storage_hold`).

---

# HowTo: Doku-/Instruction-Merge zwischen altem Projekt und Template

## 1. Checkliste für den Doku-/Instruction-Merge

**A. Vorbereitung**
- Klone beide Repos lokal in getrennte Ordner (z. B. `empty_flutter_template` und `storage_hold`).
- Öffne beide Projekte parallel in VS Code oder einem anderen Editor mit guter Diff-Unterstützung.

**B. Wichtige Doku-/Instruction-Ordner und -Dateien**
- .documents (im Template, ggf. im alten Projekt als Markdown im Root oder in eigenen Doku-Ordnern)
- .instructions (im Template, ggf. im alten Projekt als HowTo- oder Build-Dateien)
- README.md, CONTRIBUTING.md, GETTING_STARTED.md
- ggf. weitere HowTos, ADRs, Build- und Setup-Anleitungen

---

## 2. PowerShell-Skript für den Datei-Vergleich (optional)

```powershell
# Passe die Pfade an deine lokalen Verzeichnisse an!
$alt = "G:\ProjekteFlutter\storage_hold"
$template = "G:\ProjekteFlutter\empty_flutter_template"

# Vergleiche zentrale Doku-Ordner
Compare-Object -ReferenceObject (Get-ChildItem "$alt\.documents" -Recurse | Select-Object -ExpandProperty Name) `
               -DifferenceObject (Get-ChildItem "$template\.documents" -Recurse | Select-Object -ExpandProperty Name) `
               | Out-File "C:\Temp\documents_diff.txt"

Compare-Object -ReferenceObject (Get-ChildItem "$alt\.instructions" -Recurse | Select-Object -ExpandProperty Name) `
               -DifferenceObject (Get-ChildItem "$template\.instructions" -Recurse | Select-Object -ExpandProperty Name) `
               | Out-File "C:\Temp\instructions_diff.txt"
```
> Damit bekommst du eine Liste aller Dateien, die nur in einem der beiden Projekte existieren.

---

## 3. Empfohlener Merge-Workflow

1. **Vergleiche die README.md, CONTRIBUTING.md, GETTING_STARTED.md**  
   - Öffne beide Versionen nebeneinander.
   - Übernimm projektspezifische Hinweise aus dem alten Projekt, aber halte dich an die Struktur und Querverweise des Templates.

2. **Vergleiche .documents und .instructions**  
   - Für jede Datei:  
     - Wenn sie nur im Template existiert → übernehmen.
     - Wenn sie nur im alten Projekt existiert → prüfen, ob sie noch relevant ist, ggf. übernehmen und anpassen.
     - Wenn sie in beiden existiert → Inhalte vergleichen, Unterschiede zusammenführen (Template als Basis, projektspezifische Ergänzungen einbauen).
   - Nutze VS Code „Dateien vergleichen“ oder ein Tool wie `meld`.

3. **ADR-/Entscheidungsdokumente**  
   - Prüfe, ob projektspezifische Architekturentscheidungen (z. B. in `decisions/`) übernommen werden sollen.

4. **HowTos, Build- und Setup-Anleitungen**  
   - Ergänze projektspezifische HowTos, falls sie im Template fehlen.

5. **Nach dem Merge**  
   - Linting und Formatierung prüfen (`dart format .`, `flutter analyze`).
   - Querverweise und Links in der Doku aktualisieren.
   - Alles committen und pushen.

---

## 4. Tipp: Automatisiertes Kopieren einzelner Dateien

Wenn du z. B. alle HowTos aus dem alten Projekt übernehmen willst:
```powershell
Copy-Item "G:\ProjekteFlutter\storage_hold\.documents\howto_*.md" "G:\ProjekteFlutter\empty_flutter_template\.documents\" -Force
```

---

## 5. Checkliste für die manuelle Review
- [ ] README.md, CONTRIBUTING.md, GETTING_STARTED.md verglichen und zusammengeführt
- [ ] .documents und .instructions abgeglichen, doppelte/alte Inhalte entfernt
- [ ] Projektspezifische HowTos und ADRs übernommen
- [ ] Querverweise und Links aktualisiert
- [ ] Linting und Formatierung geprüft
- [ ] Alles getestet und committet

---

## 6. Nützliche Git-Befehle für die Migration und den Doku-Merge

### Branches und Stand verwalten
```powershell
# Neuen Branch für Migration anlegen und wechseln
git checkout -b develop

# Branch auf Remote pushen
git push -u origin develop

# Branch auf main zurücksetzen (lokal)
git reset --hard main

# Branch auf einen bestimmten Tag zurücksetzen
git reset --hard v1.0.0
git reset --hard <commit—hash>

# Stand auf Remote erzwingen (Achtung: destructive!)
git push --force
```

### Tags und Releases
```powershell
# Tag auf aktuellen Stand setzen
git tag v0.9.0 -m "Initial Commit: Aktueller Stand des Empty Flutter Templates als Ausgangspunkt für weitere Entwicklung."

# Tag ins Remote-Repository pushen
git push origin v0.9.0

# Alle Tags anzeigen
git tag
```

### Synchronisation und Status
```powershell
# Aktuellen Branch und Status anzeigen
git branch
git status

# Branch auf Remote pushen (z. B. main)
git push -u origin main

# Änderungen von main in develop mergen
git checkout develop
git merge main
git push origin develop
```

### Historie und Vergleich
```powershell
# Alle Commits seit einem bestimmten Tag anzeigen
git log --oneline --reverse v1.0.0..HEAD
```

---

**Hinweis:**
Diese Git-Befehle sind typische Beispiele für Migration, Branch-Management und Doku-Abgleich. Passe sie bei Bedarf an deine lokale Umgebung und Branch-Namen an.

---

**Fazit:**  
Mit dieser Anleitung und den Skripten kannst du den Doku-/Instruction-Merge zwischen altem Projekt und Template effizient, nachvollziehbar und konsistent durchführen.  
Wenn du ein konkretes Skript für einen bestimmten Ordner oder eine automatisierte Zusammenführung für bestimmte Dateitypen möchtest, sag Bescheid!
