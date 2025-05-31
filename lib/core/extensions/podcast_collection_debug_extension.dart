// lib/core/extensions/podcast_collection_debug_extension.dart

import '../../../core/logging/logger_config.dart';
import '../../../domain/models/podcast_collection_model.dart';

extension PodcastCollectionDebug on PodcastCollection {
  void debugPrettyPrint() {
    logDebug("🎧 PodcastCollection (total: ${podcasts.length})");

    for (var p in podcasts) {
      logDebug(
        "📀 ${p.collectionName} von ${p.artistName} "
        "(${p.episodes.length} Episoden)",
      );

      for (var e in p.episodes.take(3)) {
        logDebug("  • 🎙️ ${e.trackName} (${e.releaseDate.toIso8601String()})");
      }

      if (p.episodes.length > 3) {
        logDebug("  …und ${p.episodes.length - 3} mehr");
      }

      logDebug(""); // Leerzeile für bessere Lesbarkeit
    }
  }
}
