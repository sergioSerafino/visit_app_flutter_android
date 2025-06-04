// pages/hosts_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/theme_provider.dart' as theme_prov;
import '../../application/providers/collection_provider.dart' as coll_prov;
import '../../application/providers/podcast_provider.dart';
import '../../domain/common/api_response.dart';

class HostsPage extends ConsumerWidget {
  const HostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hole das aktuelle Branding und Theme
    final branding = ref.watch(theme_prov.brandingProvider);
    final theme = ref.watch(theme_prov.appThemeProvider);
    // Hole das dynamisch geladene HostModel
    final host = ref.watch(coll_prov.hostModelProvider);
    final logoUrl = host.branding.logoUrl ?? "";
    final showPortfolioTab = host.features.showPortfolioTab ?? false;
    final collectionId = ref.watch(coll_prov.collectionIdProvider);
    final podcastCollectionAsync =
        ref.watch(podcastCollectionProvider(collectionId));

    return Scaffold(
      // AppBar entfernt
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Card(
          color: theme.colorScheme.primary.withAlpha(25), // ca. 10% Deckkraft
          elevation: 4,
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary,
                  backgroundImage:
                      (logoUrl.isNotEmpty) ? NetworkImage(logoUrl) : null,
                  child: (logoUrl.isEmpty)
                      ? Icon(Icons.person,
                          size: 48,
                          color: theme.colorScheme.primary.withAlpha(180))
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  host.hostName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  host.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Kontakt:  ${host.contact.email}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Primärfarbe: ${branding.primaryColorHex ?? "-"}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sekundärfarbe: ${branding.secondaryColorHex ?? "-"}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                if (showPortfolioTab)
                  Chip(
                    label: Text('PortfolioTab aktiviert',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.onSecondary)),
                    backgroundColor: theme.colorScheme.secondary.withAlpha(51),
                  ),
                if (!showPortfolioTab)
                  Chip(
                    label: Text('PortfolioTab deaktiviert',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.onError)),
                    backgroundColor: theme.colorScheme.error.withAlpha(51),
                  ),
                const SizedBox(height: 16),
                // Statusanzeige für PodcastCollection
                Builder(
                  builder: (context) {
                    return podcastCollectionAsync.when(
                      data: (apiResponse) {
                        if (apiResponse.isSuccess && apiResponse.data != null) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_done,
                                  color:
                                      theme.colorScheme.primary.withAlpha(180)),
                              const SizedBox(width: 8),
                              Text('RSS/Podcast-Daten geladen und gemerged',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.secondary)),
                            ],
                          );
                        } else if (apiResponse is Error) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_off,
                                  color:
                                      theme.colorScheme.primary.withAlpha(180)),
                              const SizedBox(width: 8),
                              Text('RSS/Podcast-Daten NICHT geladen',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.error)),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.secondary),
                              ),
                              const SizedBox(width: 8),
                              Text('Lade RSS/Podcast-Daten...',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onPrimary)),
                            ],
                          );
                        }
                      },
                      loading: () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.secondary),
                          ),
                          const SizedBox(width: 8),
                          Text('Lade RSS/Podcast-Daten...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimary)),
                        ],
                      ),
                      error: (err, stack) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_off,
                              color: theme.colorScheme.primary.withAlpha(180)),
                          const SizedBox(width: 8),
                          Text('Fehler beim Laden der RSS/Podcast-Daten',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.colorScheme.error)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
