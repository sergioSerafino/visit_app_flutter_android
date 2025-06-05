import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/podcast_episode_model.dart';

/// Provider für die aktuell ausgewählte/abgespielte Episode
final currentEpisodeProvider = StateProvider<PodcastEpisode?>((ref) => null);
