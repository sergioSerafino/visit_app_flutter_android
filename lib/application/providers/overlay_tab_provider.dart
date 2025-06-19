import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Overlay-Status pro Tab (TabIndex → OverlayStatus)
class OverlayTabStateNotifier extends StateNotifier<Map<int, bool>> {
  OverlayTabStateNotifier() : super({});

  void setOverlay(int tabIndex, bool value) {
    state = {...state, tabIndex: value};
  }

  bool getOverlay(int tabIndex) {
    return state[tabIndex] ?? false;
  }

  void resetAll() {
    state = {};
  }
}

final overlayTabProvider =
    StateNotifierProvider<OverlayTabStateNotifier, Map<int, bool>>(
  (ref) => OverlayTabStateNotifier(),
);
