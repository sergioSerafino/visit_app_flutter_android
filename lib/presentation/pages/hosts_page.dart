// pages/hosts_page.dart
// HostsPage: Übersicht und Detailinformationen zu Host, Podcast/RSS und Portfolio.
// Clean Architecture: Präsentationsschicht, keine direkte Datenlogik.
// UI/UX: StickyHeader für alle Abschnitte, robuste async-Fehlerbehandlung, konsistente Gestaltung.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';
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
import '../widgets/host_rss_meta_tile.dart';
import '../../application/providers/overlay_header_provider.dart';

class HostsPage extends ConsumerStatefulWidget {
  final void Function(bool)? onScrollChanged;
  const HostsPage({super.key, this.onScrollChanged});

  @override
  ConsumerState<HostsPage> createState() => _HostsPageState();
}

class _HostsPageState extends ConsumerState<HostsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = _scrollController.hasClients && _scrollController.offset > 0;
    ref.read(overlayHeaderProvider.notifier).setOverlay(show);
    if (widget.onScrollChanged != null) {
      widget.onScrollChanged!(show);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('de_DE', null);
    // Host-Model aus Provider holen (zentral für alle Abschnitte)
    final host = ref.watch(coll_prov.hostModelProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // --- StickyHeader: Lokale Host-Informationen ---
          HostSectionHeader(
            title: host.sectionTitles?['about'] ??
                'Bio / Mission / Persona / About',
            showShadow: true,
            color: host.branding.primaryColorHex != null
                ? Color(int.parse(
                    host.branding.primaryColorHex!.replaceFirst('#', '0xff')))
                : Theme.of(context).colorScheme.primary,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // hostImage direkt
                  // Artist-Name mittig unterhalb des hostImage
                  if (host.hostImage != null && host.hostImage!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: HostImageAndArtistSection(
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
                    ),
                  const SizedBox(height: 12.0),

                  // Bio-Beschreibung
                  if (host.content.bio != null && host.content.bio!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: HostBioSection(bio: host.content.bio!),
                    ),

                  // logo (SplashCoverImage)
                  HostLogoImageSection(
                    collectionId: host.collectionId,
                    logoUrl: host.branding.logoUrl,
                  ),

                  // RSS-Beschreibung (aus RSS-Metadaten)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
                    child: HostRssDescriptionSection(
                      podcastCollectionAsync: ref.watch(
                        podcastCollectionProvider(host.collectionId),
                      ),
                      collectionId: host.collectionId,
                    ),
                  ),
                  // const SizedBox(height: 20.0),

                  // assetLogo
                  HostLogoSection(
                    collectionId: host.collectionId,
                    assetLogo: host.branding.assetLogo,
                    scaleFactor: 0.65,
                  ),

                  // Mission-Beschreibung
                  // Mission als großes Zitat
                  if (host.content.mission != null &&
                      host.content.mission!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: HostMissionSection(mission: host.content.mission!),
                    ),

                  // Last Updated
                  if (host.lastUpdated != null)
                    HostLastUpdatedSection(lastUpdated: host.lastUpdated!),
                ],
              ),
            ),
          ),

          // --- StickyHeader: Anfahrt / Visit / Kontakt ---
          HostSectionHeader(
            title: host.sectionTitles?['portfolio'] ?? 'Angebote / Entdecken',
            color: host.branding.primaryColorHex != null
                ? Color(int.parse(
                    host.branding.primaryColorHex!.replaceFirst('#', '0xff')))
                : Theme.of(context).colorScheme.primary,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
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

                  // Website (aus RSS, dynamisch per Provider)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: HostRssMetaTile(
                      collectionId: host.collectionId.toString(),
                      icon: Icons.public,
                      extractor: (rssMeta) {
                        final url = rssMeta?.websiteUrl ?? '';
                        return url.replaceFirst(
                            RegExp(r'^https?://(www\.)?'), '');
                      },
                      originalValueExtractor: (rssMeta) =>
                          rssMeta?.websiteUrl ?? '',
                      onTap: (value) => launchUrl(Uri.parse(value)),
                    ),
                  ),

                  // Host-Website (aus HostModel)
                  if (host.contact.websiteUrl != null &&
                      host.contact.websiteUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.public,
                              color: host.branding.secondaryColorHex != null
                                  ? Color(int.parse(host
                                      .branding.secondaryColorHex!
                                      .replaceFirst('#', '0xff')))
                                  : Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                launchUrl(Uri.parse(host.contact.websiteUrl!)),
                            child: Text(
                              host.contact.websiteUrl!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        host.branding.secondaryColorHex != null
                                            ? Color(int.parse(host
                                                .branding.secondaryColorHex!
                                                .replaceFirst('#', '0xff')))
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // --- StickyHeader: Angebote / Portfolio ---
          HostSectionHeader(
            title:
                host.sectionTitles?['contact'] ?? 'Anfahrt / Visit / Kontakt',
            color: host.branding.primaryColorHex != null
                ? Color(int.parse(
                    host.branding.primaryColorHex!.replaceFirst('#', '0xff')))
                : Theme.of(context).colorScheme.primary,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Social Links Bar
                  if (host.contact.socialLinks != null &&
                      host.contact.socialLinks!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: HostSocialLinksSection(
                        socialLinks: host.contact.socialLinks!,
                        iconColor: host.branding.primaryColorHex != null
                            ? Color(int.parse(host.branding.secondaryColorHex!
                                .replaceFirst('#', '0xff')))
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),

                  // E-Mail (aus RSS, dynamisch per Provider)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: HostRssMetaTile(
                      collectionId: host.collectionId.toString(),
                      icon: Icons.email,
                      extractor: (rssMeta) => rssMeta?.contactEmail ?? '',
                      onTap: (value) => launchUrl(Uri.parse('mailto:$value')),
                    ),
                  ),

                  // Host E-Mail (aus HostModel)
                  // if (host.contact.email != null &&
                  //     host.contact.email!.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  //     child: Center(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Icon(Icons.email,
                  //               color: Theme.of(context).colorScheme.primary),
                  //           const SizedBox(width: 8),
                  //           GestureDetector(
                  //             onTap: () => launchUrl(
                  //                 Uri.parse('mailto:${host.contact.email!}')),
                  //             child: Text(
                  //               host.contact.email!,
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyLarge
                  //                   ?.copyWith(
                  //                     color: Colors.blue,
                  //                     decoration: TextDecoration.underline,
                  //                   ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
          const HostScrollSpacerSection(),
/*
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
          ),*/
        ],
      ),
    );
  }
}

// InfoTile: Einfache Zeile für Label/Wert-Paare, wie in HostCard genutzt.
class InfoTile extends HostInfoTile {
  const InfoTile({super.key, String? label, required super.value})
      : super(label: label ?? '');
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

// HostRssMetaTile: Zeigt ein Feld aus den RSS-Metadaten an (z.B. E-Mail, Website).
// (ausgelagert nach ../widgets/host_rss_meta_tile.dart)

// PodcastMetaInfoTile: Zeigt Metainformationen zu einem Podcast an (Titel, Artist, ...).
