# Provider-Lifecycle, Persistenz und State-Management: Architektur-Entscheidung & Alternativen

## Status Quo
- Globale Provider (z. B. podcastCollectionProvider, podcastEpisodeProvider, collectionIdProvider) sind **nicht** als autoDispose deklariert.
- Sie bleiben über Page-Wechsel hinweg erhalten, um Ladekosten zu sparen und Caching zu ermöglichen.
- Seitengebundene Provider (z. B. episodePagingProvider) nutzen autoDispose.

## Begründung
- Performance: Bereits geladene Inhalte bleiben im Speicher, solange die App läuft.
- UX: Kein unnötiges Neuladen/Caching bei Navigation.
- Architektur: Trennung zwischen globalem App-State und seitengebundenem State.

## Alternativen & Best Practices

### a) Persistenz auf Storage-Ebene
- Provider initialisieren ihren State aus Storage (Hive, SharedPrefs, SQLite).
- State bleibt auch nach App-Restart erhalten.

### b) Scoped ProviderScope für Subtrees
- Für bestimmte App-Bereiche (z. B. pro Mandant/User) eigenen ProviderScope nutzen.
- Ermöglicht gezielten State-Reset bei Wechsel.

### c) autoDispose mit keepAlive
- Provider als autoDispose deklarieren, aber mit ref.keepAlive() gezielt am Leben halten.
- Feingranulare Kontrolle über Lebensdauer und Speicherverbrauch.

### d) Explicit Refresh/Invalidate
- Provider bleiben global, können aber gezielt invalidiert/refreshed werden.
- Verhindert stale Daten und ermöglicht gezielte Updates.

### e) Hydrated State Management
- Persistenz von State über App-Restarts hinweg (ähnlich HydratedBloc).

### f) State Restoration (Flutter)
- Flutter State Restoration für bestimmte Widgets/Pages.

## Abwägung für dieses Projekt
- Die aktuelle Trennung ist für Podcast-/Content-Apps optimal.
- Mit wachsender Persistenz kann die Rolle der Provider weiter Richtung „State-Proxy“ für Storage verschoben werden.
- Ein späterer Wechsel auf Scoped ProviderScopes oder gezieltes autoDispose/keepAlive ist jederzeit möglich.

## Quellen & Querverweise
- .documents/einschaetzung_naechste_schritte_persistenz_interceptor.md
- .documents/riverpod_provider_architektur.mmd
- Riverpod-Doku: ProviderScope, autoDispose
- .instructions/architecture_clean_architecture.md
- .documents/collectionId_flow_overview_with_branding.mmd

---

**Fazit:**
Die aktuelle Lösung ist für die Anforderungen und die geplante Persistenz optimal. Mit wachsender Persistenz und Multi-Host-Fähigkeit kann ein Wechsel auf Scoped ProviderScopes oder gezieltes autoDispose/keepAlive sinnvoll werden. Ein explizites DI für ConsumerStatefulWidgets ist nicht notwendig, da Riverpod dies bereits kapselt.
