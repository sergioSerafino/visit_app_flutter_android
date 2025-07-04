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
        // Pattern Matching statt isSuccess
        return apiResponse.when(
          success: (data) {
            if (data.podcasts.isEmpty) return const SizedBox.shrink();
            final podcast = data.podcasts.first;
            final feedUrl = podcast.feedUrl ?? '';
            final rssMetaAsync = ref.watch(rssMetadataProvider(feedUrl));
            return rssMetaAsync.when(
              data: (rssMeta) => rssMeta?.description != null &&
                      rssMeta!.description!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        rssMeta.description!,
                        style: const TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (e, st) => const SizedBox.shrink(),
            );
          },
          error: (_) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}
