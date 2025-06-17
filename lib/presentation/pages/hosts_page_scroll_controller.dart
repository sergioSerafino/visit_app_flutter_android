import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hostsPageScrollProvider =
    ChangeNotifierProvider<HostsPageScrollController>(
        (ref) => HostsPageScrollController());

class HostsPageScrollController extends ChangeNotifier {
  final ScrollController controller = ScrollController();
  bool _showShadow = false;

  bool get showShadow => _showShadow;

  HostsPageScrollController() {
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
