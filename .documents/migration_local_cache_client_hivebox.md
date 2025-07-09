# Migration LocalCacheClient auf HiveBox podcastHostCollections

## Ziel
Der LocalCacheClient soll als Service bestehen bleiben, aber intern die neue strukturierte Hive-Box `podcastHostCollections` nutzen. Damit wird ein einheitliches, robustes Persistenz- und Caching-System ohne Redundanz geschaffen.

## Vorgehen (Juli 2025)
1. **Analyse**: Die bisherige Implementierung nutzt eine flache Key-Value-Box (`podcastBox`).
2. **Migration**: Alle Lese-/Schreiboperationen werden so angepasst, dass sie mit der Box `podcastHostCollections` und dem Modell `HivePodcastHostCollection` arbeiten.
3. **Mapping**: Die Konvertierung zwischen Freezed-Modell (`PodcastHostCollection`) und Hive-Modell (`HivePodcastHostCollection`) erfolgt über die Mapper-Klasse.
4. **API**: Das Interface des LocalCacheClient bleibt erhalten (SOLID: Open/Closed Principle).
5. **Teststrategie**: Es werden Unit- und Integrations-Tests für die neue Persistenzschicht ergänzt.
6. **Lessons Learned**: Vorteile, Stolpersteine und Best Practices werden dokumentiert.

## Quellen & Best Practices
- [Flutter Hive Dokumentation](https://docs.hivedb.dev/)
- [Dart Effective Dart](https://dart.dev/guides/language/effective-dart)
- `.documents/datenpersistenz_architektur_vorgehen.md`
- `.documents/datenpersistenz_provider_abrufanalyse.md`
- README.md (Abschnitt Persistenz)

---

**Letzte Änderung:** 09.07.2025 (automatisch durch Copilot dokumentiert)
