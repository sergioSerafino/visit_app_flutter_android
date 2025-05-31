// filepath: lib/application/providers/episode_controller_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/episode_load_controller.dart';
import '../../../domain/enums/episode_load_state.dart';

final episodeLoadControllerProvider =
    StateNotifierProvider<EpisodeLoadController, EpisodeLoadState>(
  (ref) => EpisodeLoadController(ref),
);
