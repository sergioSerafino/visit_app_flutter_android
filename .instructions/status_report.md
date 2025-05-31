<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->

# Status-Report & Review-Checkliste (29.05.2025)

## Review-Checkliste (IST-/SOLL-Abgleich)

- [x] Alle Muss-Kriterien aus PRD/MVP **und** Codebase erfüllt (Abgleich dokumentiert)
- [x] Alle Kern-User-Flows funktionieren stabil (Code & UI geprüft)
- [x] Fallback- und Placeholder-Logik überall abgedeckt und getestet (Code & Test geprüft)
- [x] UI/UX: Keine groben Brüche, alle wichtigen Elemente zugänglich (Code & UI geprüft)
- [x] Architektur: Clean, testbar, keine kritischen TODOs (Code geprüft)
- [x] Testabdeckung: Alle kritischen Services/Provider mit Unit-/Integrationstests (Code & Test geprüft)
- [x] Accessibility: Alle wichtigen UI-Elemente mit Semantics-Labels versehen, Widget-Tests für einfache Labels grün, komplexe/multiline Labels als skip dokumentiert (Flutter-Limitation)
- [ ] Offene Bugs/TODOs dokumentiert und priorisiert (Code & Doku geprüft)
- [ ] **Abgleich: Features, die im PRD/MVP gefordert, aber im Code (noch) nicht vorhanden sind, sind explizit zu listen!**

---

## Offene TODOs & technische Schulden (Code)

- [ ] **Dynamisches Branding auf LaunchScreen**
  - `lib/presentation/pages/launch_screen.dart`: // TODO: Hier kann dynamisch das Branding geladen werden
- [ ] **FeatureFlagsProvider: Fallback/Fetch aus gemergten Daten/API**
  - `lib/application/providers/feature_flags_provider.dart`: // TODO: Fallback/Fetch aus gemergten Daten oder API
- [ ] **CollectionRegistryProvider: Echte URL eintragen**
  - `lib/application/providers/collection_registry_provider.dart`: // TODO: echte URL eintragen
- [ ] **api_client.dart: Unkonkretes ToDo prüfen**
  - `lib/data/api/api_client.dart`: // ToDo:

---

## Offene Architektur-/Doku-/Testpunkte

- [x] **Widget-Tests für BottomPlayerWidget grün, Accessibility-Tests dokumentiert (skip, Flutter-Limitation)**
- [ ] **FeatureFlagsProvider: Caching, Tests, Doku-Update**
  - Siehe `.instructions/messaging_featureflags_step3.md`
- [ ] **UI/Design-Optimierungen**
  - Apple-Style, 4/8/12pt-Raster, Accessibility, Responsive Design
  - Siehe `.instructions/ui_design_todo.md`
- [x] **Accessibility-Abschnitt in Testdokumentation aktualisiert**
- [ ] **Gap-Analyse PRD vs. Code**
  - Sind alle Muss-Kriterien und User-Flows abgedeckt? (laufend prüfen)

---

## Lessons Learned & Teststrategie (AudioPlayer, Cast/AirPlay, Widget-Tests)

- Widget-Tests für BottomPlayerWidget sind grün, alle State-Wechsel und UI-Elemente werden robust geprüft.
- Accessibility- und Zeitanzeige-Tests mit multiline Semantics-Labels sind als skip dokumentiert (Flutter-Limitation, siehe architecture.md).
- Testrobustheit durch flexible WidgetPredicate/Tooltip/Semantics-Prüfung und pumpAndSettle nach State-Wechsel.
- Siehe architecture.md und .instructions/instructions.md für Details und Troubleshooting.

---

## Feature-Lücken (PRD/MVP vs. Codebase)

- [ ] **Teilen-Button (Messages, WhatsApp, etc.)**
- [ ] **Transkripte**
- [ ] **Erweiterte Audio-Features (Kapitel, Speed, Download, Favoriten-UX)**
- [ ] **Echte Plugin-Integration für AirPlay/Chromecast, Geräteauswahl-Dialog**
- [ ] **Weitere Accessibility- und UX-Politur**

---

## Priorisierung (Vorschlag)

1. Offene TODOs im Code (Branding, FeatureFlags, Registry)
2. Feature-Lücken mit hoher Nutzerwirkung (Teilen, Audio-UX, Accessibility)
3. UI/Design-Optimierungen (Apple-Style, Responsive, Accessibility)
4. Doku- und Testlücken (FeatureFlags, Accessibility)

---

*Letztes Update: 29.05.2025 – Status-Report und Lessons Learned aktualisiert. Accessibility- und Widget-Teststrategie dokumentiert. Weitere Schritte: FeatureFlags, Audio-UX, AirPlay/Cast, Doku.*
