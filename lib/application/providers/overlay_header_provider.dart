import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverlayHeaderState extends StateNotifier<bool> {
  OverlayHeaderState() : super(false);

  void setOverlay(bool value) {
    if (state != value) state = value;
  }
}

final overlayHeaderProvider = StateNotifierProvider<OverlayHeaderState, bool>(
    (ref) => OverlayHeaderState());
