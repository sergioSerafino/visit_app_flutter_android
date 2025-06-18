// pages/hosts_page.dart
// HostsPage: Übersicht und Detailinformationen zu Host, Podcast/RSS und Portfolio.
// Clean Architecture: Präsentationsschicht, keine direkte Datenlogik.
// UI/UX: StickyHeader für alle Abschnitte, robuste async-Fehlerbehandlung, konsistente Gestaltung.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../widgets/simple_section_header.dart';
import '../widgets/tenant_logo_widget.dart';
import '../widgets/social_links_bar.dart';
import '../widgets/host_bio_section.dart';
import '../widgets/host_logo_section.dart';
import '../widgets/host_mission_section.dart';
import '../widgets/host_image_and_artist_section.dart';
import '../widgets/host_logo_image_section.dart';
import '../widgets/host_rss_description_section.dart';
import '../widgets/host_social_links_section.dart';
import '../widgets/host_last_updated_section.dart';
import '../widgets/host_info_tile.dart';
import '../widgets/host_website_tile.dart';
import '../widgets/host_section_header.dart';
import '../widgets/host_dynamic_fields_section.dart';
import '../widgets/host_scroll_spacer_section.dart';
import '../../application/providers/podcast_provider.dart';
import '../../domain/common/api_response.dart';
import '../../application/providers/collection_provider.dart' as coll_prov;
import '../../application/providers/rss_metadata_provider.dart';
import '../../core/utils/tenant_asset_loader.dart';
import '../widgets/splash_cover_image.dart';

class HostsPage extends ConsumerWidget {
  const HostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initializeDateFormatting('de_DE', null);
    // Host-Model aus Provider holen (zentral für alle Abschnitte)
    final host = ref.watch(coll_prov.hostModelProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // --- StickyHeader: Lokale Host-Informationen ---
          const HostSectionHeader(
            title: 'Über Sabine',
            showShadow: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // assetLogo ganz oben
                  HostLogoSection(
                    collectionId: host.collectionId,
                    assetLogo: host.branding.assetLogo,
                    scaleFactor: 0.5,
                  ),

                  // Mission-Beschreibung
                  // Mission als großes Zitat
                  if (host.content.mission != null &&
                      host.content.mission!.isNotEmpty)
                    HostMissionSection(mission: host.content.mission!),

                  // hostImage direkt unterhalb der Mission
                  // Artist-Name mittig unterhalb des hostImage
                  if (host.hostImage != null && host.hostImage!.isNotEmpty)
                    HostImageAndArtistSection(
                      collectionId: host.collectionId.toString(),
                      hostImage: host.hostImage!,
                      artistName: (() {
                        final podcastCollectionAsync = ref.watch(
                          podcastCollectionProvider(host.collectionId),
                        );
                        final apiResponse =
                            podcastCollectionAsync.asData?.value;
                        if (apiResponse == null ||
                            !apiResponse.isSuccess ||
                            apiResponse.data == null ||
                            apiResponse.data!.podcasts.isEmpty) {
                          return null;
                        }
                        final podcast = apiResponse.data!.podcasts.first;
                        return podcast.artistName.isNotEmpty
                            ? podcast.artistName
                            : null;
                      })(),
                    ),
                  const SizedBox(height: 12.0),

                  // Bio-Beschreibung
                  if (host.content.bio != null && host.content.bio!.isNotEmpty)
                    HostBioSection(bio: host.content.bio!),

                  // logo (SplashCoverImage) nach der Bio
                  HostLogoImageSection(
                    collectionId: host.collectionId,
                    logoUrl: host.branding.logoUrl,
                  ),

                  // RSS-Beschreibung (aus RSS-Metadaten)
                  HostRssDescriptionSection(
                    podcastCollectionAsync: ref.watch(
                      podcastCollectionProvider(host.collectionId),
                    ),
                    collectionId: host.collectionId,
                  ),
                  // const SizedBox(height: 20.0),

                  // Last Updated
                  if (host.lastUpdated != null)
                    HostLastUpdatedSection(lastUpdated: host.lastUpdated!),

                  /*    
                  InfoTile(
                      label: 'Primärfarbe',
                      value: host.branding.primaryColorHex ?? '-'),

                  InfoTile(
                      label: 'Sekundärfarbe',
                      value: host.branding.secondaryColorHex ?? '-'),
              */
                ],
              ),
            ),
          ),

          // --- StickyHeader: Kontakt / Visit ---
          const HostSectionHeader(
            title: '(Anfahrt,) Visit & Kontakt',
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // E-Mail (aus RSS)
                  Builder(
                    builder: (context) {
                      final podcastCollectionAsync = ref.watch(
                        podcastCollectionProvider(host.collectionId),
                      );
                      return podcastCollectionAsync.when(
                        data: (apiResponse) {
                          if (!apiResponse.isSuccess ||
                              apiResponse.data == null) {
                            return const InfoTile(label: 'E-Mail', value: '-');
                          }
                          final podcast = apiResponse.data!.podcasts.isNotEmpty
                              ? apiResponse.data!.podcasts.first
                              : null;
                          if (podcast == null) {
                            return const InfoTile(label: 'E-Mail', value: '-');
                          }
                          final feedUrl = podcast.feedUrl ?? '';
                          final rssMetaAsync =
                              ref.watch(rssMetadataProvider(feedUrl));
                          return rssMetaAsync.when(
                            data: (rssMeta) => rssMeta?.contactEmail != null &&
                                    rssMeta!.contactEmail!.isNotEmpty
                                ? Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.email,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => launchUrl(Uri.parse(
                                              'mailto:${rssMeta.contactEmail}')),
                                          child: Text(
                                            rssMeta.contactEmail!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            loading: () => const SizedBox.shrink(),
                            error: (e, st) => const SizedBox.shrink(),
                          );
                        },
                        loading: () =>
                            const InfoTile(label: 'E-Mail', value: '...'),
                        error: (e, st) =>
                            const InfoTile(label: 'E-Mail', value: '-'),
                      );
                    },
                  ),
                  // Social Links Bar
                  if (host.contact.socialLinks != null &&
                      host.contact.socialLinks!.isNotEmpty)
                    HostSocialLinksSection(
                      socialLinks: host.contact.socialLinks!,
                    ),
                ],
              ),
            ),
          ),
          // --- StickyHeader: Angebote / Portfolio ---
          const HostSectionHeader(
            title: 'Portfolio & weitere Angebote',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Website
                  Builder(
                    builder: (context) {
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
                            data: (rssMeta) => rssMeta?.websiteUrl != null &&
                                    rssMeta!.websiteUrl!.isNotEmpty
                                ? Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.public,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => launchUrl(
                                              Uri.parse(rssMeta.websiteUrl!)),
                                          child: Text(
                                            rssMeta.websiteUrl!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            loading: () => const SizedBox.shrink(),
                            error: (e, st) => const SizedBox.shrink(),
                          );
                        },
                        loading: () =>
                            const InfoTile(label: 'Website', value: '...'),
                        error: (e, st) => InfoTile(
                            label: 'Website',
                            value: host.contact.websiteUrl ?? '-'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Podcast-Cover
                  Builder(
                    builder: (context) {
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
                          if (podcast == null ||
                              podcast.artworkUrl600.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  podcast.artworkUrl600,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey,
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
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
          // --- StickyHeader: Weitere Informationen ---
          const HostScrollSpacerSection(),
          const HostSectionHeader(
            title: 'Weitere Informationen',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamische Host-Felder
                  HostDynamicFieldsSection(
                    host: host,
                    // isAdmin: true, // Optional, falls Admin-Felder angezeigt werden sollen
                  ),

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
                              // für Admin (direkter Zugriff, keine Provider-Logik)
                              // InfoTile(
                              //     label: 'Feed URL', value: podcast.feedUrl ?? '-'),
                              // InfoTile(
                              //     label: 'PodcastId',
                              //     value: podcast.collectionId.toString()),
                              // InfoTile(
                              //     label: 'Artwork',
                              //     value: podcast.artworkUrl600),
                              // if (podcast.artworkUrl600.isNotEmpty)
                              //   Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         vertical: 12.0),
                              //     child: Row(
                              //       children: [
                              //         Spacer(),
                              //         ClipRRect(
                              //           borderRadius: BorderRadius.circular(8),
                              //           child: Image.network(
                              //             podcast.artworkUrl600,
                              //             width: 120,
                              //             height: 120,
                              //             fit: BoxFit.cover,
                              //             errorBuilder:
                              //                 (context, error, stackTrace) =>
                              //                     Container(
                              //               width: 120,
                              //               height: 120,
                              //               color: Colors.grey,
                              //               child: const Icon(Icons.error),
                              //             ),
                              //           ),
                              //         ),
                              //         Spacer(),
                              //       ],
                              //     ),
                              //   ),
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
class InfoTile extends HostInfoTile {
  const InfoTile({super.key, required super.label, required super.value});
}

// WebsiteTile: Zeigt eine Website als klickbaren Link an.
class WebsiteTile extends HostWebsiteTile {
  const WebsiteTile({super.key, required super.label, required super.url});

  @override
  Widget build(BuildContext context) {
    final isValid = url.isNotEmpty && url != '-';
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
            child: isValid
                ? GestureDetector(
                    onTap: () async {
                      final uri = Uri.tryParse(url);
                      if (uri != null) {
                        // ignore: deprecated_member_use
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text(
                      url,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  )
                : Text(url, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
