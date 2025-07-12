# Repository-Pattern, Serialisierung und Caching – Ursachenanalyse & Lösungsansatz

## Problemstellung

Beim Aktivieren der Speichermethoden (`savePodcastCollection`, `savePodcastEpisodes`) werden auf der HivePage keine gespeicherten podcastBox-Datensätze angezeigt. Die UI zeigt nur die Episoden-Liste, andere Felder (z. B. `artistName`, `artworkUrl600`, `primaryGenreName`) fehlen, und es erfolgt ein Fallback auf Placeholder. Der RSS-Abruf schlägt ebenfalls fehl, ohne Snackbar-Feedback.

## Ursachenanalyse

1. **Repository-Pattern:**
   - Das Repository-Pattern trennt die Datenquellen (API, Cache, Mock) und steuert, welche Datenquelle verwendet wird.
   - Ein leeres oder nicht korrekt implementiertes `cached_podcast_repository.dart` kann dazu führen, dass keine Daten aus dem Cache gelesen oder geschrieben werden.
   - Änderungen am Repository-Verhalten (z. B. durch Aktivieren der Speichermethoden) können dazu führen, dass die App nur noch auf den Cache zugreift, der aber leer ist oder falsch serialisiert wurde.

2. **Serialisierung:**
   - Die Serialisierung der Modelle (z. B. `PodcastCollection`) muss konsistent und kompatibel mit Hive erfolgen.
   - Die Mapper-Klassen sind essenziell, um Freezed-Modelle korrekt in Hive-Modelle zu überführen (siehe `.documents/migration_local_cache_client_hivebox_lessons_learned.md`).
   - Eine fehlende oder fehlerhafte Serialisierung kann dazu führen, dass Felder nicht gespeichert oder nicht korrekt ausgelesen werden.

3. **UI-Verhalten:**
   - Die UI orientiert sich an den gemergten, persistierten Modellen und zeigt nur die Felder an, die tatsächlich im Cache vorhanden sind.
   - Fehlen Felder im Cache, werden Placeholder angezeigt.

## Lösungsansatz

- **Implementiere das `cached_podcast_repository.dart` analog zu den anderen Repositories (API, Mock), mit korrekter Serialisierung und Zugriff auf den Cache.**
- **Nutze Mapper-Klassen für die Serialisierung und Deserialisierung der Modelle.**
- **Prüfe, ob die Methoden in `local_cache_client.dart` und ggf. `merged_collection_cache_service.dart` die Datenquellen wie gewünscht bündeln und abrufen können.**
- **Stelle sicher, dass die UI nach dem Merge und Persistieren der Daten auf die vollständigen Modelle zugreift.**
- **Teste die Cache-Anzeige auf der HivePage nach jedem Speichervorgang.**

## Querverweise
- `.documents/migration_plan_podcast_cache_hivebox.md` (Migrations- und Testplan)
- `.documents/hive_cache_user_trigger_plan.md` (User-Trigger und Cache-Analyse)
- `.documents/migration_local_cache_client_hivebox_lessons_learned.md` (Lessons Learned & Best Practices zur Serialisierung)

---

**Letztes Update:** 12.07.2025
