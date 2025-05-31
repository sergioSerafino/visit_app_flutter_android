// filepath: lib/application/providers/data_mode_provider.dart
// - dataSourceProvider - toggleDataSource() : API oder Mock

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/repository_source_type.dart';
import '../controllers/should_load_controller.dart';
import 'podcast_provider.dart';

/// Steuert, ob Daten von der API oder aus einem Mock geladen werden
final dataSourceProvider = StateProvider<RepositorySourceType>(
  (ref) => RepositorySourceType.api,
);

/// Helper zum Umschalten zwischen API und Mock
void toggleDataSource(WidgetRef ref) {
  final current = ref.read(dataSourceProvider);
  final next = current == RepositorySourceType.api
      ? RepositorySourceType.mock
      : RepositorySourceType.api;

  ref.read(dataSourceProvider.notifier).state = next;

  // Optional: Reset aller relevanten States
  ref.invalidate(podcastCollectionProvider);
  ref.read(shouldLoadEpisodesProvider.notifier).reset();
}
