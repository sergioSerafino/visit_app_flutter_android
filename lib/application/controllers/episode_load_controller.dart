// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu StateNotifier, Lade-Controller und Teststrategie.
// Lessons Learned: EpisodeLoadController steuert den Ladeprozess für Episoden mit expliziten Zustandswechseln und Logging. Besonderheiten: UI-Feedback, testbare Ladeabfolge, Logging für Debugging. Siehe zugehörige Provider und Tests.
//
// Weitere Hinweise: Die Architektur erlaubt flexible Erweiterung um weitere Ladezustände und unterstützt Clean-Architektur-Prinzipien. Siehe ADR-003 für Teststrategie und Lessons Learned.

// Migration aus storage_hold, Stand 30.05.2025
// Kommentare und Prinzipien gemäß Doku übernommen

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../domain/enums/episode_load_state.dart';
import '../../core/logging/logger_config.dart';

class EpisodeLoadController extends StateNotifier<EpisodeLoadState> {
  EpisodeLoadController(this.ref) : super(EpisodeLoadState.initial) {
    // Automatischer Retry bei Netzrückkehr
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((dynamic result) {
      final connResult = result is List
          ? (result.isNotEmpty ? result.first : ConnectivityResult.none)
          : result;
      if (connResult != ConnectivityResult.none &&
          state == EpisodeLoadState.placeholder) {
        logDebug(
            '[EpisodeLoadController] Netz wieder da, automatischer Retry ausgelöst.',
            tag: LogTag.ui,
            color: LogColor.green);
        loadEpisodes();
      }
    });
  }
  final Ref ref;
  StreamSubscription<dynamic>? _connectivitySubscription;

  /// Direkt auf "Platzhalter" setzen (z. B. in PostFrameCallback)
  void startPlaceholder() {
    _logStateChange(EpisodeLoadState.placeholder);
    logDebug('[EpisodeLoadController] State → placeholder',
        tag: LogTag.ui, color: LogColor.yellow);
    state = EpisodeLoadState.placeholder;
  }

  /// Zeige sehr kurz Spinner, dann Platzhalter → dann echte Daten
  Future<void> performEpisodesLoadingSequence() async {
    logDebug('[EpisodeLoadController] Lade-Sequenz gestartet',
        tag: LogTag.ui, color: LogColor.cyan);
    state = EpisodeLoadState.loading;
    await Future.delayed(const Duration(milliseconds: 1600));
    logDebug('[EpisodeLoadController] State → placeholder (kurzer Spinner)',
        tag: LogTag.ui, color: LogColor.yellow);
    state = EpisodeLoadState.placeholder;
    await Future.delayed(const Duration(milliseconds: 1000));
    logDebug('[EpisodeLoadController] State → loaded (nach Lade-Sequenz)',
        tag: LogTag.ui, color: LogColor.green);
    state = EpisodeLoadState.loaded;
  }

  /// Falls z. B. auf Cover getippt wird: Direkt zum echten Daten-Load
  void loadEpisodes() {
    logDebug(
        '[EpisodeLoadController] Manuelles oder automatisches Retry: State → loaded',
        tag: LogTag.ui,
        color: LogColor.green);
    _logStateChange(EpisodeLoadState.loaded);
    state = EpisodeLoadState.loaded;
  }

  /// Setzt auf Initial zurück
  void reset() {
    logDebug('[EpisodeLoadController] State → initial (Reset)',
        tag: LogTag.ui, color: LogColor.red);
    _logStateChange(EpisodeLoadState.initial);
    state = EpisodeLoadState.initial;
  }

  void _logStateChange(EpisodeLoadState newState) {
    logDebug('[EpisodeLoadController] Neuer State: $newState',
        tag: LogTag.ui, color: LogColor.cyan);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
