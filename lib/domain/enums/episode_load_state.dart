// lib/domain/enums/episode_load_state.dart

enum EpisodeLoadState {
  initial, // noch nichts angeklickt, nur eine Dummy-Liste z.B. "leer 1", "leer 2",.. zu sehen
  loading, // nach Tap, vor Platzhalter
  placeholder, // Dummy-Liste z.B. "leer 1", "leer 2",.. sichtbar
  loaded, // echte Episoden, API- oder Mock- geladen
}
