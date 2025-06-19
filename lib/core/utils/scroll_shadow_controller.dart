import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scrollShadowControllerProvider =
    ChangeNotifierProvider<ScrollShadowController>(
        (ref) => ScrollShadowController());

class ScrollShadowController extends ChangeNotifier {
  final ScrollController controller = ScrollController();
  bool _showShadow = false;

  bool get showShadow => _showShadow;

  ScrollShadowController() {
    controller.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow = controller.offset > 0;
    if (shouldShow != _showShadow) {
      _showShadow = shouldShow;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
