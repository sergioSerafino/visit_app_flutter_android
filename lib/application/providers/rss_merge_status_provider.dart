import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RssMergeStatus { pending, success, error, offline }

final rssMergeStatusProvider =
    StateProvider<RssMergeStatus>((ref) => RssMergeStatus.pending);
