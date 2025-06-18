import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/rss_metadata_provider.dart';

/// Zeigt die RSS-Beschreibung (aus RSS-Metadaten) auf der HostsPage an.
///
/// Holt die Beschreibung asynchron und zeigt sie nur an, wenn sie vorhanden ist.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostRssDescriptionSection extends ConsumerWidget {
  final AsyncValue<dynamic> podcastCollectionAsync;
  final int collectionId;
  const HostRssDescriptionSection({
    super.key,
    required this.podcastCollectionAsync,
    required this.collectionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // RSS-Beschreibung (aus RSS-Metadaten)
    return podcastCollectionAsync.when(
      data: (apiResponse) {
        // Prüfe nur auf null und leere Daten, nicht auf isSuccess
        if (apiResponse == null || apiResponse.data == null) {
          return const SizedBox.shrink();
        }
        final podcast = apiResponse.data!.podcasts.isNotEmpty
            ? apiResponse.data!.podcasts.first
            : null;
        if (podcast == null) {
          return const SizedBox.shrink();
        }
        final feedUrl = podcast.feedUrl ?? '';
        final rssMetaAsync = ref.watch(rssMetadataProvider(feedUrl));
        return rssMetaAsync.when(
          data: (rssMeta) =>
              rssMeta?.description != null && rssMeta!.description!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        rssMeta.description!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (e, st) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}
