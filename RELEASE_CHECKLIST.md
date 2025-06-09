# Release-Checkliste

Diese Checkliste enthält alle Aufgaben, die vor dem Release des Projekts erledigt oder geprüft werden müssen. Sie ist mit der zentralen [README.md](README.md) verknüpft und sollte regelmäßig aktualisiert werden.

## ToDos vor Release

- [ ] **Branding/Assets:** Sind alle Logos, assetLogo.png und Fallbacks korrekt eingebunden und in der pubspec.yaml eingetragen?
- [ ] **RSS/Podcast:** Funktioniert das Live-Laden und Caching der RSS-Metadaten zuverlässig (auch nach App-Restart und bei leerem Cache)?
- [ ] **UI/UX:** Sind alle dynamischen InfoTiles und Host-/Podcast-Informationen vollständig und korrekt dargestellt?
- [ ] **Fehlerbehandlung:** Werden alle Fehlerfälle (Netzwerk, Parsing, leere Daten) im UI und im Log klar angezeigt?
- [ ] **Debug-Ausgaben:** Sind alle Debug- und Log-Ausgaben entfernt oder auf ein sinnvolles Minimum reduziert?
- [ ] **Tests:** Sind alle Unit-, Widget- und Integrationstests grün? Gibt es Testabdeckung für die wichtigsten Features?
- [ ] **Doku:** Sind alle HowTos, Architektur- und Deployment-Dokumente aktuell und vollständig?
- [ ] **pubspec.yaml:** Sind alle Assets, Abhängigkeiten und Versionen korrekt eingetragen?
- [ ] **CI/CD:** Funktioniert der Build und das Deployment auf allen Zielplattformen (Android, iOS, Web, ...)?
- [ ] **Sonstiges:**
  - [ ] Nach Netzwerk-Kosten und Datenverbrauch prüfen (z.B. RSS-Reload, Bild-Downloads, Streaming)
  - [ ] Temporäre Dateien, Dummy-Modelle und Testdaten entfernt?
  - [ ] README und Getting Started aktuell?
  - [ ] Lizenz und Copyright?

---

*Diese Datei ist mit der zentralen README.md verlinkt. Bitte vor jedem Release durchgehen!*
