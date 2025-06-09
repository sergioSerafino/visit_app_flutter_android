// pages/hosts_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/podcast_provider.dart';
import '../../core/utils/tenant_asset_loader.dart';
import '../../domain/common/api_response.dart';
import '../../application/providers/collection_provider.dart' as coll_prov;
import '../../application/providers/rss_metadata_provider.dart';
import '../widgets/host_info_card.dart';
import '../widgets/splash_cover_image.dart';

class HostsPage extends ConsumerWidget {
  const HostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(coll_prov.hostModelProvider);
    final collectionId = host.collectionId;
    final podcastCollectionAsync = ref.watch(
      podcastCollectionProvider(collectionId),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Fester Header oder beliebiges Widget
          // SplashCoverImage als Artwork oben in der Card
          SplashCoverImage(
            assetPath: TenantAssetLoader(host.collectionId)
                .assetLogoPath(host.branding.assetLogo),
            scaleFactor: 0.5,
            duration: const Duration(milliseconds: 800),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 24.0, right: 24.0),
            child: Text('Lokale Host-Informationen',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 8),
          // Scrollbarer Bereich
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Dynamische Host-Felder
                InfoTile(label: 'Host Name', value: host.hostName),

                //PERFEKT: als HAUPTE SEKTION
                InfoTile(label: 'Beschreibung', value: host.description),
                // InfoTile(label: 'CollectionId', value: host.collectionId.toString()),
                // InfoTile(
                //     label: 'Primäres Genre', value: host.primaryGenreName ?? '-'),

                // verleichen mit
                // InfoTile(label: 'Kontakt E-Mail', value: host.contact.email ?? '-'),

                InfoTile(
                    label: 'Social Links',
                    value: host.contact.socialLinks?.entries
                            .map((e) => '${e.key}: ${e.value}')
                            .join(', ') ??
                        '-'),
                InfoTile(
                    label: 'Website', value: host.contact.websiteUrl ?? '-'),

                InfoTile(
                    label: 'Impressum',
                    value: host.contact.impressumUrl ?? '-'),
                InfoTile(label: 'Bio', value: host.content.bio ?? '-'),
                InfoTile(label: 'Mission', value: host.content.mission ?? '-'),

                // für Admin
                // InfoTile(label: 'RSS-Feed', value: host.content.rss ?? '-'),

                // für Admin
                // InfoTile(
                //     label: 'PortfolioTab',
                //     value: (host.features.showPortfolioTab ?? false).toString()),

                // für Admin
                // InfoTile(
                //     label: 'Branding Primary',
                //     value: host.branding.primaryColorHex ?? '-'),

                // für Admin
                // InfoTile(
                //     label: 'Branding Secondary',
                //     value: host.branding.secondaryColorHex ?? '-'),

                InfoTile(
                    label: 'Branding Logo',
                    value: host.branding.logoUrl ?? '-'),

                // für Admin
                // InfoTile(label: 'Theme Mode', value: host.branding.themeMode ?? '-'),

                // für Admin
                // InfoTile(
                // label: 'Debug Only', value: host.debugOnly?.toString() ?? '-'),

                //PERFEKT: als 'host.lastUpdated'
                InfoTile(
                    label: 'Last Updated',
                    value: host.lastUpdated?.toIso8601String() ?? '-'),
                const Divider(height: 32),

                Text('Podcast-/RSS-Informationen',
                    style: Theme.of(context).textTheme.headlineMedium),

                const SizedBox(height: 12),
                podcastCollectionAsync.when(
                  data: (apiResponse) {
                    if (!apiResponse.isSuccess || apiResponse.data == null) {
                      return const Text('Keine PodcastCollection geladen');
                    }
                    final podcast = apiResponse.data!.podcasts.firstOrNull;
                    if (podcast == null)
                      return const Text('Kein Podcast gefunden');
                    final feedUrl = podcast.feedUrl ?? '';
                    final rssMetaAsync =
                        ref.watch(rssMetadataProvider(feedUrl));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // für dynamische Inline-Ersetzung
                        InfoTile(
                            label: 'Podcast Titel',
                            value: podcast.collectionName),

                        //PERFEKT: als 'hostName' (=='artistName' -> dann speichern)
                        InfoTile(label: 'Artist', value: podcast.artistName),

                        // InfoTile(label: 'Genre', value: podcast.primaryGenreName),

                        InfoTile(
                            label: 'Feed URL', value: podcast.feedUrl ?? '-'),

                        InfoTile(label: 'Feed URL (Debug)', value: feedUrl),

                        // für Admin
                        // InfoTile(
                        //     label: 'PodcastId',
                        //     value: podcast.collectionId.toString()),

                        //PERFEKT:
                        InfoTile(
                            label: 'Artwork', value: podcast.artworkUrl600),

                        //PERFEKT: als 'numberOfEpisodes' ()
                        InfoTile(
                            label: 'Episodenanzahl',
                            value: podcast.episodes.length.toString()),

                        const Divider(height: 24),
                        // --- RSS-Metadaten direkt aus Feed (live, nicht gemergt) ---
                        rssMetaAsync.when(
                          data: (meta) => meta == null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Keine RSS-Metadaten gefunden'),
                                    Text('Debug: meta == null'),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //PERFEKT: als 'meta.hostName'
                                    InfoTile(
                                        label: 'RSS Host Name',
                                        value: meta.hostName ?? '-'),

                                    //PERFEKT: als 'meta.description'
                                    InfoTile(
                                        label: 'RSS Beschreibung',
                                        value: meta.description ?? '-'),

                                    //PERFEKT: als 'meta.contactEmail'
                                    InfoTile(
                                        label: 'Kontakt E-Mail (RSS)',
                                        value: meta.contactEmail ?? '-'),

                                    //PERFEKT: als 'meta.websiteUrl'
                                    InfoTile(
                                        label: 'Website (RSS)',
                                        value: meta.websiteUrl ?? '-'),

                                    // für Admin als aktuelles RRS-Backup von 'artworkUrl600'
                                    // InfoTile(
                                    //     label: 'Logo RSS (hochauflösendes Cover)',
                                    //     value: meta.logoUrl ?? '-'),

                                    // für Admin
                                    // InfoTile(
                                    //     label: 'RSS Sprache',
                                    //     value: meta.defaultLanguageCode ?? '-'),

                                    //PERFEKT: als 'longPrimaryGenreName'
                                    InfoTile(
                                        label: 'Kategorie bei iTunes',
                                        value:
                                            meta.longPrimaryGenreName ?? '-'),
                                  ],
                                ),
                          loading: () => const CircularProgressIndicator(),
                          error: (err, stack) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fehler beim Laden der RSS-Metadaten: $err'),
                              Text('Debug: $stack'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        HostInfoCard(host: host),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Fehler beim Laden: $err'),
                ),
              ],
            ),
          ),
          // Optional: Fester Footer/Player/Widget
          // MyBottomPlayerWidget(),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const InfoTile({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 160,
              child: Text('$label:',
                  style: Theme.of(context).textTheme.bodyMedium)),
          Expanded(
              child: Text(value, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
