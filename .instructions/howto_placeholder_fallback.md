# HowTo: Robuster Placeholder- und Fallback-Mechanismus in Flutter

## Ziel
Die App soll auch ohne Internetverbindung oder bei API-/Cache-Fehlern immer sinnvolle Demo-/Fallback-Daten anzeigen und nie leer/weiß bleiben. Die Fallback-Logik ist zentral, testbar und unabhängig von Netzwerk-Interceptors.

---

## 1. Fallback-Basis schaffen (ohne Interceptor)
- **Repository:** Gibt IMMER ein valides Modell zurück. Bei Fehlern (API, Cache, Netzwerk) **oder wenn die Collection leer ist** wird ein Placeholder-Modell aus `PlaceholderContent` geliefert.
  - **Wichtig:** Auch wenn die API/Cache-Logik "erfolgreich" läuft, aber keine Podcasts liefert (`collection.podcasts.isEmpty`), muss der Placeholder zurückgegeben werden:
    ```dart
    if (collection.podcasts.isEmpty) {
      return ApiResponse.success(PlaceholderContent.podcastCollection);
    }
    ```
- **UI:** Fragt das Modell ab und prüft auf `isPlaceholder`. Im Fallback-Fall werden die Werte direkt aus `PlaceholderContent` angezeigt (z.B. Hostname, CollectionName, etc.).
  - **Wichtig:** Auch im Fehlerfall (`error: (_) => ...`) sollte die UI auf die zentralen Placeholder-Werte zugreifen:
    ```dart
    error: (_) => welcomeHeader(
      PlaceholderContent.podcastCollection.podcasts.first.artistName,
      context: context,
    ),
    ```
- **Vorteil:** Die App bleibt immer benutzbar, unabhängig von Netzwerk oder Interceptor.

**Beispiel (LandingPage):**
```dart
final dynamicHostName = collection.isPlaceholder
    ? PlaceholderContent.podcastCollection.podcasts.first.artistName
    : (podcast?.collectionName ?? "Gastgeber-Format");
```

---

## 2. Interceptor erst danach ergänzen
- **Dio-Interceptor:** Wird erst nach der Fallback-Basis ergänzt, um Netzwerkfehler abzufangen, Retry zu ermöglichen und Feedback (Snackbar, Logging) zu geben.
- **Wichtig:** Der Interceptor ist für die User-Experience zuständig, nicht für die Grundfunktionalität. Die App bleibt auch ohne Interceptor immer benutzbar.

---

## 3. Vorteile dieser Reihenfolge
- **Testbarkeit:** Fallback-Logik kann unabhängig von Netzwerk getestet werden.
- **Wartbarkeit:** Placeholder-Werte sind zentral in `PlaceholderContent` gepflegt.
- **Robustheit:** Die App bleibt nie leer, auch wenn Netzwerk, API oder Cache ausfallen.

---

## 4. Empfohlene Reihenfolge
1. Fallback-Logik und zentrale Placeholder-Modelle implementieren.
2. Erst danach Interceptor/Retry/Feedback für Netzwerk-UX einbauen.

---

## Weiterführende Doku & Querverweise
- [OFFLINE_RETRY_FEEDBACK_DOKU.md](../OFFLINE_RETRY_FEEDBACK_DOKU.md): Architektur, Retry-Interceptor, Feedback-System
- [TESTSTRATEGIE_OFFLINE_RETRY.md](../TESTSTRATEGIE_OFFLINE_RETRY.md): Teststrategie und Testfälle für Offline/Retry
- [core/placeholders/placeholder_content.dart](../lib/core/placeholders/placeholder_content.dart): Zentrale Placeholder-Modelle
- [lib/data/repositories/api_podcast_repository.dart](../lib/data/repositories/api_podcast_repository.dart): Fallback-Logik im Repository
- [lib/presentation/pages/landing_page.dart](../lib/presentation/pages/landing_page.dart): Beispielhafte UI-Integration

---

**Letztes Update:** 30.06.2025
