// filepath: lib/application/providers/data_mode_provider.dart
// - dataSourceProvider - toggleDataSource() : API oder Mock

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_provider.dart' as theme_prov;
import 'collection_provider.dart' as collection_prov;
import 'feature_flags_provider.dart';
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

  // Debug-Log für Nachvollziehbarkeit
  // ignore: avoid_print
  print('[toggleDataSource] Datenquelle gewechselt auf: $next');

  // Reset aller relevanten States (Branding, Host, FeatureFlags, Podcast, etc.)
  ref.invalidate(podcastCollectionProvider);
  ref.read(shouldLoadEpisodesProvider.notifier).reset();
  ref.invalidate(theme_prov.brandingProvider); // Theme/Branding
  ref.invalidate(collection_prov.hostModelProvider); // HostModel
  ref.invalidate(featureFlagsProvider); // FeatureFlags
  // Optional: Weitere Provider invalidieren, falls benötigt

  // Nach dem Invalidate: explizit CollectionId-Listener triggern, damit Branding/HostModel asynchron neu geladen werden
  final collectionId = ref.read(collection_prov.collectionIdProvider);
  // ignore: avoid_print
  print(
      '[toggleDataSource] Triggere Branding/Host-Reload für CollectionId: $collectionId');
}

///
/// toggleDataSource: Umschalten zwischen API- und Mock-Modus
///
/// - Invalidiert alle Provider, die von der Datenquelle abhängen:
///   - podcastCollectionProvider: Podcast-Daten
///   - shouldLoadEpisodesProvider: Episoden-Controller
///   - brandingProvider: Dynamisches Branding/Theming
///   - hostModelProvider: Host-spezifische Daten
///   - featureFlagsProvider: Feature-Flags pro Collection/Host
///
/// Dadurch wird sichergestellt, dass nach einem Wechsel des Datenmodus
/// (API/Mock) alle UI-Elemente und States korrekt neu geladen werden.
///
