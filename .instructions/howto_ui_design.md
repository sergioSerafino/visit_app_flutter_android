<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: architecture_clean_architecture.md, project_structure_best_practices.md -->

# Offene UI/Design-Optimierungen (Stand: 27.05.2025)

## Status
- UI-Refactoring und Design-Tuning (Apple-Style, 4/8/12pt-Raster, Typografie etc.) sind bewusst für später offen gelassen.
- Die aktuelle Architektur und Provider-Struktur ist so gestaltet, dass UI/UX-Anpassungen jederzeit modular und gezielt möglich sind.

## TODO für spätere Optimierung
- Apple-gerechter Look (z. B. Cupertino-Widgets, native iOS-Transitions)
- Konsistentes 4/8/12pt-Raster für Abstände, Schriftgrößen, UI-Elemente
- Dynamische Typografie und Theme-Optimierung
- Responsive Design für verschiedene Geräte
- Accessibility-Verbesserungen (Kontrast, Lesbarkeit, Screenreader)
- UI/UX-Review und gezielte Modernisierung

**Hinweis:**
Diese Punkte sind in der Architektur-Doku und den Refactoring-Schritten als "später optimierbar" markiert. Sie können jederzeit gezielt umgesetzt werden, ohne die Clean Architecture oder die Provider-Struktur zu brechen.

- Die bisherigen Anordnungen der UI-Elemente (Listen, Buttons, Texte etc.) sind grundsätzlich sinnvoll und entsprechen dem aktuellen Stand der App.
- Offene Optimierungs- und Designwünsche (z.B. Apple-Style, Raster, Accessibility) werden immer Schritt für Schritt und in enger Abstimmung am bestehenden Layout umgesetzt.
- Bei jedem UI-Refactoring oder Designschritt sollte gezielt nachgefragt werden, ob die gewünschte Wirkung im UI tatsächlich erreicht wird (z.B. "Wird dies und jenes durch diesen Schritt im UI erreicht?").
- Ziel: Bestehende Nutzerführung und Funktionalität bleiben erhalten, Design- und UX-Verbesserungen werden iterativ und nachvollziehbar integriert.

---

**Nächste Schritte:**
- Fortsetzung der Architektur- und Test-Optimierungen (Registry, Validierung, Clean-Up, Testabdeckung, weitere Caching-Strategien).
- UI/Design-Optimierungen können später gezielt nachgeholt werden.

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Ursprünglicher Hinweis: Offene UI/Design-Optimierungen, Apple-Style, Accessibility, 4/8/12pt-Raster etc. wurden im Altprojekt als "später optimierbar" markiert.
- Siehe auch: `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Verwandte Themen: `architecture_clean_architecture.md`, `project_structure_best_practices.md` (siehe Altprojekt).
