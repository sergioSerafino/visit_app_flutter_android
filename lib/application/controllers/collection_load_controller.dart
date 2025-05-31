// lib/application/controllers/collection_load_controller.dart
// Migration aus storage_hold, Stand 30.05.2025
// Kommentare und Prinzipien gemäß Doku übernommen
//
// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu StateNotifier, Collection-Loading und Teststrategie.
// Lessons Learned: CollectionLoadController steuert den Ladeprozess für Collections mit expliziten Zustandswechseln, Logging und Fehlerbehandlung. Besonderheiten: UI-Feedback, testbare Ladeabfolge, Logging für Debugging. Siehe zugehörige Provider und Tests.
//
// Weitere Hinweise: Die Architektur erlaubt flexible Erweiterung um weitere Ladezustände und Fehlerbehandlung und unterstützt Clean-Architektur-Prinzipien. Siehe ADR-003 für Teststrategie und Lessons Learned.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/enums/collection_load_state.dart';
import '../../../core/logging/logger_config.dart';

class CollectionLoadController extends StateNotifier<CollectionLoadState> {
  CollectionLoadController(this.ref) : super(CollectionLoadState.initial);

  final Ref ref;

  /// UI-Zyklus starten mit Ladespinner → Platzhalter → echte Daten
  Future<void> performCollectionLoadingSequence() async {
    _log("⏳ Ladezustand: loading");
    state = CollectionLoadState.loading;

    await Future.delayed(const Duration(milliseconds: 500));
    _log("🧱 Ladezustand: placeholder");
    state = CollectionLoadState.placeholder;

    await Future.delayed(const Duration(milliseconds: 1500));
    _log("✅ Ladezustand: loaded");
    state = CollectionLoadState.loaded;
  }

  void loadCollection() {
    _log("🔁 Direkter Load");
    state = CollectionLoadState.loaded;
  }

  void reset() {
    _log("🔄 Reset auf initial");
    state = CollectionLoadState.initial;
  }

  void setError() {
    _log("❌ Fehlerstatus");
    state = CollectionLoadState.error;
  }

  void _log(String msg) =>
      logDebug("[CollectionLoad] $msg", tag: LogTag.ui, color: LogColor.cyan);
}
