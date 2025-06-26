# Aktivierung und Dokumentation des Placeholder-Fallbacks für Offline- und Fehlerfälle

## Hintergrund
Die App ist so konzipiert, dass sie bei fehlender Internetverbindung, API-Fehlern oder leeren Datenquellen **immer** lauffähig bleibt und ein UI anzeigt. Dies wird durch eine mehrstufige Fallback-Strategie erreicht:

1. **API** (bevorzugt)
2. **Cache** (lokale Daten, z.B. Hive)
3. **Lokale JSON** (z.B. aus assets/tenants/)
4. **Placeholder** (Demo-/Default-Daten, garantiert immer vorhanden)

## Aktueller Stand
- Die Placeholder-Modelle sind in `lib/core/placeholders/placeholder_content.dart` und `placeholder_loader_service.dart` implementiert.
- In der UI (z.B. `PodcastPage`, `LandingPage`) gibt es bereits Code, der im Placeholder-Modus Dummy-Daten anzeigt.
- In der Praxis ist der Placeholder-Fallback aber aktuell **deaktiviert** oder wird nicht automatisch genutzt, wenn API und Cache fehlschlagen.

## Anpassung (Juni 2025)
- Die Provider (z.B. `podcastCollectionProvider`) werden so angepasst, dass sie bei Netzwerkfehlern oder leeren Datenquellen **automatisch** auf Placeholder-Daten zurückfallen.
- Ziel: Die App zeigt immer ein UI, auch wenn keine Verbindung und keine gecachten Daten vorhanden sind.
- Die Aktivierung des Placeholder-Fallbacks wird im Code und in dieser Doku dokumentiert.

## ToDo vor Release
- **Zielzustand festlegen:**
  - Soll der Placeholder-Fallback im Produktivbetrieb aktiv bleiben (Demo/White-Label-Mode)?
  - Oder soll im Fehlerfall ein expliziter Fehler/Offline-Hinweis angezeigt werden?
- **FeatureFlag/Config:**
  - Optional kann der Placeholder-Fallback über ein FeatureFlag oder eine Umgebungsvariable steuerbar gemacht werden.
- **Tests:**
  - Widget- und Integrationstests für Offline- und Fehlerfälle ergänzen.

## Hinweise für Reviewer
- Die Aktivierung des Placeholder-Fallbacks ist für Demo, Test und White-Label-Setups **empfohlen**.
- Für den Produktivbetrieb sollte das Verhalten mit dem Product Owner abgestimmt werden.
- Siehe auch: `.instructions/architecture_clean_architecture.md`, `.instructions/prd_white_label_podcast_app.md`, `.documents/einschaetzung_naechste_schritte_persistenz_interceptor.md`

---

**Letzte Änderung:** 26.06.2025
**Bearbeiter:** GitHub Copilot
