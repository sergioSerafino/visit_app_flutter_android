// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu StateNotifier, Lade-Controller und Teststrategie.
// Lessons Learned: EpisodeLoadController steuert den Ladeprozess für Episoden mit expliziten Zustandswechseln und Logging. Besonderheiten: UI-Feedback, testbare Ladeabfolge, Logging für Debugging. Siehe zugehörige Provider und Tests.
//
// Weitere Hinweise: Die Architektur erlaubt flexible Erweiterung um weitere Ladezustände und unterstützt Clean-Architektur-Prinzipien. Siehe ADR-003 für Teststrategie und Lessons Learned.

// Migration aus storage_hold, Stand 30.05.2025
// Kommentare und Prinzipien gemäß Doku übernommen

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/enums/episode_load_state.dart';
import '../../../core/logging/logger_config.dart';

class EpisodeLoadController extends StateNotifier<EpisodeLoadState> {
  EpisodeLoadController(this.ref) : super(EpisodeLoadState.initial);
  final Ref ref;

  /// Direkt auf "Platzhalter" setzen (z. B. in PostFrameCallback)
  void startPlaceholder() {
    _logStateChange(EpisodeLoadState.placeholder);
    state = EpisodeLoadState.placeholder;
  }

  /// Zeige sehr kurz Spinner, dann Platzhalter → dann echte Daten
  Future<void> performEpisodesLoadingSequence() async {
    logDebug("🔁 Ladeprozess gestartet", tag: LogTag.ui, color: LogColor.green);

    state = EpisodeLoadState.loading;

    // sehr kurzes Feedback Lade-Indikator
    await Future.delayed(const Duration(milliseconds: 1600));
    state = EpisodeLoadState.placeholder;

    // kurzes Feedback Lade-Indikator
    await Future.delayed(const Duration(milliseconds: 1000));
    state = EpisodeLoadState.loaded;

    logDebug(
      "✅ Ladeprozess abgeschlossen",
      tag: LogTag.ui,
      color: LogColor.green,
    );
  }

  /// Falls z. B. auf Cover getippt wird: Direkt zum echten Daten-Load
  void loadEpisodes() {
    _logStateChange(EpisodeLoadState.loaded);
    state = EpisodeLoadState.loaded;
  }

  /// Setzt auf Initial zurück
  void reset() {
    _logStateChange(EpisodeLoadState.initial);
    state = EpisodeLoadState.initial;
  }

  void _logStateChange(EpisodeLoadState newState) {
    logDebug('[EpisodeLoad] State: [36m$newState[0m',
        tag: LogTag.ui, color: LogColor.cyan);
  }
}
