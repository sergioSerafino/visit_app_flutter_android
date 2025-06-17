// pages/hosts_page.dart
// HostsPage: Übersicht und Detailinformationen zu Host, Podcast/RSS und Portfolio.
// Clean Architecture: Präsentationsschicht, keine direkte Datenlogik.
// UI/UX: StickyHeader für alle Abschnitte, robuste async-Fehlerbehandlung, konsistente Gestaltung.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/sticky_info_header.dart';
import '../widgets/simple_section_header.dart';
import '../widgets/tenant_logo_widget.dart';
import '../../core/utils/sticky_info_header_constants.dart';
import '../../application/providers/podcast_provider.dart';
import '../../domain/common/api_response.dart';
import '../../application/providers/collection_provider.dart' as coll_prov;
import '../../application/providers/rss_metadata_provider.dart';

class HostsPage extends ConsumerWidget {
  const HostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Host-Model aus Provider holen (zentral für alle Abschnitte)
    final host = ref.watch(coll_prov.hostModelProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // --- StickyHeader: Lokale Host-Informationen ---
          SliverPersistentHeader(
            pinned: true,
            delegate: SimpleSectionHeader(
              title: 'Lokale Host-Informationen',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- NEU: RSS Beschreibung direkt unter Ü1 ---
                  Builder(
                    builder: (context) {
                      // PodcastCollection holen
                      final podcastCollectionAsync = ref.watch(
                        podcastCollectionProvider(host.collectionId),
                      );
                      return podcastCollectionAsync.when(
                        data: (apiResponse) {
                          if (!apiResponse.isSuccess ||
                              apiResponse.data == null) {
                            return const SizedBox.shrink();
                          }
                          final podcast = apiResponse.data!.podcasts.isNotEmpty
                              ? apiResponse.data!.podcasts.first
                              : null;
                          if (podcast == null) {
                            return const SizedBox.shrink();
                          }
                          final feedUrl = podcast.feedUrl ?? '';
                          final rssMetaAsync =
                              ref.watch(rssMetadataProvider(feedUrl));
                          return rssMetaAsync.when(
                            data: (rssMeta) => InfoTile(
                              label: 'RSS Beschreibung',
                              value: rssMeta?.description ?? '-',
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (e, st) => const SizedBox.shrink(),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (e, st) => const SizedBox.shrink(),
                      );
                    },
                  ),
                  // Bio
                  InfoTile(label: 'Bio', value: host.content.bio ?? '-'),
                  // Mission
                  InfoTile(
                      label: 'Mission', value: host.content.mission ?? '-'),
                  // assetLogo
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TenantLogoWidget(
                      collectionId: host.collectionId,
                      assetLogo: host.branding.assetLogo,
                      scaleFactor: 0.5,
                    ),
                  ),
                  // Last Updated
                  InfoTile(
                    label: 'Last Updated',
                    value: host.lastUpdated?.toIso8601String() ?? '-',
                  ),
                  //PERFEKT: als 'primaryColorHex' (aus Branding)
                  InfoTile(
                      label: 'Primärfarbe',
                      value: host.branding.primaryColorHex ?? '-'),
                  //PERFEKT: als 'secondaryColorHex' (aus Branding)
                  InfoTile(
                      label: 'Sekundärfarbe',
                      value: host.branding.secondaryColorHex ?? '-'),
                  //PERFEKT: als 'email' (aus Contact)
                  InfoTile(label: 'Kontakt', value: host.contact.email ?? '-'),
                  //PERFEKT: als 'showPortfolioTab' (aus Features)
                  InfoTile(
                      label: 'PortfolioTab',
                      value: (host.features.showPortfolioTab ?? false)
                          ? 'aktiviert'
                          : 'deaktiviert'),
                  // ...weitere Felder/Kommentare aus der alten Version ggf. ergänzen...
                ],
              ),
            ),
          ),
          // --- StickyHeader: Podcast-/RSS-Informationen ---
          SliverPersistentHeader(
            pinned: true,
            delegate: SimpleSectionHeader(
              title: 'Podcast-/RSS-Informationen',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Builder(
                builder: (context) {
                  final podcastCollectionAsync = ref.watch(
                    podcastCollectionProvider(host.collectionId),
                  );
                  return podcastCollectionAsync.when(
                    data: (apiResponse) {
                      if (!apiResponse.isSuccess || apiResponse.data == null) {
                        return const Text('Keine PodcastCollection geladen');
                      }
                      final podcast = apiResponse.data!.podcasts.isNotEmpty
                          ? apiResponse.data!.podcasts.first
                          : null;
                      if (podcast == null) {
                        return const Text('Kein Podcast gefunden');
                      }
                      final feedUrl = podcast.feedUrl ?? '';
                      final rssMetaAsync =
                          ref.watch(rssMetadataProvider(feedUrl));
                      return rssMetaAsync.when(
                        data: (rssMeta) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kontakt E-Mail (RSS)
                            InfoTile(
                              label: 'Kontakt E-Mail (RSS)',
                              value: rssMeta?.contactEmail ?? '-',
                            ),
                            // Social Links
                            InfoTile(
                              label: 'Social Links',
                              value: host.contact.socialLinks?.entries
                                      .map((e) => '${e.key}: ${e.value}')
                                      .join(', ') ??
                                  '-',
                            ),
                          ],
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (e, st) => const SizedBox.shrink(),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (e, st) => const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ),
          // --- StickyHeader: Angebote / Portfolio ---
          SliverPersistentHeader(
            pinned: true,
            delegate: SimpleSectionHeader(
              title: 'Angebote / Portfolio',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (host.features.showPortfolioTab ?? false)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Portfolio-Inhalte folgen ...',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
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
                  InfoTile(
                      label: 'Mission', value: host.content.mission ?? '-'),
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
                  // InfoTile(
                  //     label: 'Branding Logo',
                  //     value: host.branding.logoUrl ?? '-'),
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
                  Builder(
                    builder: (context) {
                      final podcastCollectionAsync = ref.watch(
                        podcastCollectionProvider(host.collectionId),
                      );
                      return podcastCollectionAsync.when(
                        data: (apiResponse) {
                          if (!apiResponse.isSuccess ||
                              apiResponse.data == null) {
                            return const Text(
                                'Keine PodcastCollection geladen');
                          }
                          final podcast =
                              apiResponse.data!.podcasts.firstOrNull;
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
                              InfoTile(
                                  label: 'Artist', value: podcast.artistName),
                              // InfoTile(label: 'Genre', value: podcast.primaryGenreName),
                              // für Admin
                              // InfoTile(
                              //     label: 'Feed URL', value: podcast.feedUrl ?? '-'),
                              // InfoTile(label: 'Feed URL (Debug)', value: feedUrl),
                              // für Admin
                              // InfoTile(
                              //     label: 'PodcastId',
                              //     value: podcast.collectionId.toString()),
                              //PERFEKT:
                              InfoTile(
                                  label: 'Artwork',
                                  value: podcast.artworkUrl600),
                              if (podcast.artworkUrl600.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Row(
                                    children: [
                                      Spacer(), // schiebt das Bild ganz nach rechts
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          podcast.artworkUrl600,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: 120,
                                            height: 120,
                                            color: Colors.grey,
                                            child: const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Spacer(), // schiebt das Bild ganz nach rechts
                                    ],
                                  ),
                                ),
                              // für Admin
                              // InfoTile(
                              //     label: 'Debug Only',
                              //     value: podcast.debugOnly?.toString() ?? '-'),
                            ],
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (e, st) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// InfoTile: Einfache Zeile für Label/Wert-Paare, wie in HostCard genutzt.
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
