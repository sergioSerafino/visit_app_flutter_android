import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStateStatus { online, offline, retrying }

final connectionStateProvider =
    StateProvider<ConnectionStateStatus>((ref) => ConnectionStateStatus.online);
