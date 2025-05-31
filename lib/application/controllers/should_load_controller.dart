// Migration aus storage_hold, Stand 30.05.2025
// Kommentare und Prinzipien gemäß Doku übernommen
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShouldLoadController extends StateNotifier<bool> {
  ShouldLoadController() : super(false);

  void loadEpisodes() {
    state = true;
  }

  void reset() {
    state = false;
  }
}

/// Provider für die Steuerung des Ladezustands der Episoden
final shouldLoadEpisodesProvider =
    StateNotifierProvider<ShouldLoadController, bool>(
  (ref) => ShouldLoadController(),
);
