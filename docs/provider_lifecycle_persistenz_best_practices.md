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

---

## Praxisfall: ScrollController/Provider-State nach Navigation (HomePage/LandingPage)

### Problemstellung
Beim Navigieren von der HomePage über das Menü zurück zur LandingPage und anschließendem erneuten Betreten der HomePage (z.B. nach Klick auf 'Starten') tritt folgendes Problem auf:
- Der ScrollIndicator in der PodcastPage (erster Tab) verschwindet.
- Nach erneutem Navigieren kommt es zu einem Fehler beim Wiederbetreten der HomePage.
- Ursache: ScrollController und Provider-State (z.B. collectionLoadControllerProvider, episodeLoadControllerProvider) werden nicht sauber zurückgesetzt oder neu initialisiert.

### Analyse (Stand 08.07.2025)
- Die Controller werden zwar im dispose entsorgt, aber beim erneuten Betreten nicht immer korrekt neu initialisiert.
- Provider sind global und bleiben über Page-Wechsel hinweg erhalten, was zu inkonsistentem State führen kann.
- Nach Navigation (LandingPage → HomePage) fehlt ein expliziter State-Reset.

### Best Practices & Lösungsansätze
- **Provider explizit invalidieren:** Beim Verlassen der HomePage oder beim erneuten Betreten gezielt Provider wie collectionLoadControllerProvider und episodeLoadControllerProvider invalidieren (`ref.invalidate(...)`).
- **Controller robust neu initialisieren:** Im initState der HomePage/PodcastPage sicherstellen, dass der ScrollController immer neu angelegt wird.
- **Optional: ProviderScope für HomePage:** Die HomePage in einen eigenen ProviderScope legen, um einen frischen State zu erzwingen.
- **Overlay/ScrollIndicator-Logik prüfen:** Sicherstellen, dass der Overlay-Status beim Tab-Wechsel und beim erneuten Betreten der Seite korrekt gesetzt wird.

### Beispiel (Code-Snippet)
```dart
// Beim Verlassen der HomePage oder im onPressed von 'Starten' auf der LandingPage:
ref.invalidate(collectionLoadControllerProvider);
ref.invalidate(episodeLoadControllerProvider);

// Optional: HomePage in eigenen ProviderScope einbetten
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => ProviderScope(child: HomePage()),
  ),
);
```

### Lessons Learned
- State-Management in Flutter/Riverpod benötigt explizite State-Resets bei Navigation.
- ProviderScope und gezieltes Invalidate sind zentrale Werkzeuge für robusten State.
- Controller und Provider sollten bei jedem Page-Entry neu initialisiert werden, wenn die Seite als „frisch“ erscheinen soll.

---

**Rückfragen und weitere Best-Practice-Impulse gerne @workspace!**
