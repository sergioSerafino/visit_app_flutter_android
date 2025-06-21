import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItunesResultCountNotifier extends StateNotifier<int> {
  ItunesResultCountNotifier() : super(200); // Default: 5

  void setCount(int value) {
    state = value;
  }
}

final itunesResultCountProvider =
    StateNotifierProvider<ItunesResultCountNotifier, int>(
        (ref) => ItunesResultCountNotifier());
