import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/podcast_provider.dart';
import '../../application/providers/rss_metadata_provider.dart';
import '../../domain/common/api_response.dart';

/// Universelles Widget für die Anzeige eines RSS-Metadatenfelds (z. B. E-Mail, Website) aus dem RSS-Provider.
///
/// Zeigt das Feld nur an, wenn es im RSS vorhanden und nicht leer ist.
/// [label] = Titel der Zeile, [icon] = optionales Icon, [extractor] = Funktion, die den Wert aus rssMeta extrahiert.
class HostRssMetaTile extends ConsumerWidget {
  final String collectionId;
  final String? label;
  final IconData? icon;
  final String? Function(dynamic rssMeta) extractor;
  final void Function(String value)? onTap;
  final String? Function(dynamic rssMeta)? originalValueExtractor;

  const HostRssMetaTile({
    super.key,
    required this.collectionId,
    this.label,
    this.icon,
    required this.extractor,
    this.onTap,
    this.originalValueExtractor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcastCollectionAsync =
        ref.watch(podcastCollectionProvider(int.parse(collectionId)));
    return podcastCollectionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (apiResponse) {
        if (!apiResponse.isSuccess || apiResponse.data == null) {
          return const SizedBox.shrink();
        }
        final podcasts = apiResponse.data!.podcasts;
        if (podcasts.isEmpty) return const SizedBox.shrink();
        final podcast = podcasts.first;
        final feedUrl = podcast.feedUrl ?? '';
        final rssMetaAsync = ref.watch(rssMetadataProvider(feedUrl));
        return rssMetaAsync.when(
          data: (rssMeta) {
            final value = extractor(rssMeta);
            final originalValue = originalValueExtractor != null
                ? originalValueExtractor!(rssMeta)
                : value;
            if (value == null || value.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(icon, color: Theme.of(context).colorScheme.primary),
                    if (icon != null) const SizedBox(width: 8),
                    if (label != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '$label:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    GestureDetector(
                      onTap: onTap != null && originalValue != null
                          ? () => onTap!(originalValue)
                          : null,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: onTap != null
                                  ? (Theme.of(context).colorScheme.secondary)
                                  : null,
                              decoration: onTap != null
                                  ? TextDecoration.underline
                                  : null,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (e, st) => const SizedBox.shrink(),
        );
      },
    );
  }
}
