enum DataSourceType {
  /// Daten von der iTunes API
  itunes,

  /// Daten aus einem RSS-Feed
  rss,

  /// Lokale JSON-Daten (z. B. about.json)
  json,

  /// Lokale Datenquellen (z. B. Caching, Hive)
  local,
}
