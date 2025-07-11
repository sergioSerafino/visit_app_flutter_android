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
import '../widgets/host_scroll_spacer_section.dart';
import '../../application/providers/podcast_provider.dart';
import '../../application/providers/collection_provider.dart' as coll_prov;
import '../widgets/host_rss_meta_tile.dart';
import '../../application/providers/overlay_header_provider.dart';
import '../../application/providers/overlay_tab_provider.dart';
import '../widgets/safe_image.dart';
import '../../core/messaging/snackbar_messages.dart';
import '../../application/providers/rss_provider.dart';
import '../../application/providers/rss_merge_status_provider.dart';
import '../../core/messaging/snackbar_manager.dart';

class HostsPage extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  final double? initialScrollOffset;
  final void Function(bool)? onScrollChanged;
  const HostsPage(
      {super.key,
      this.scrollController,
      this.initialScrollOffset,
      this.onScrollChanged});

  @override
  ConsumerState<HostsPage> createState() => _HostsPageState();
}

class _HostsPageState extends ConsumerState<HostsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
    if (widget.initialScrollOffset != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients &&
            _scrollController.offset != widget.initialScrollOffset) {
          _scrollController.jumpTo(widget.initialScrollOffset!);
        }
      });
    }
  }

  void _onScroll() {
    final show = _scrollController.hasClients && _scrollController.offset > 0;
    ref.read(overlayHeaderProvider.notifier).setOverlay(show);
    ref
        .read(overlayTabProvider.notifier)
        .setOverlay(1, show); // Tab 1 = HostsPage
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
    ref.listen<RssMergeStatus>(rssMergeStatusProvider, (prev, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (next == RssMergeStatus.error) {
          ref
              .read(snackbarManagerProvider.notifier)
              .showByKey('host_fetch_failed');
        }
        if (next == RssMergeStatus.success) {
          ref
              .read(snackbarManagerProvider.notifier)
              .showByKey('host_info_saved');
        }
        if (next == RssMergeStatus.offline) {
          ref
              .read(snackbarManagerProvider.notifier)
              .showByKey('host_update_failed_offline');
        }
      });
    });
    initializeDateFormatting('de_DE', null);
    final host = ref.watch(coll_prov.hostModelProvider);
    final showOverlay = ref.watch(overlayTabProvider)[1] ?? false;
    final baseColor = host.branding.primaryColorHex != null
        ? Color(
            int.parse(host.branding.primaryColorHex!.replaceFirst('#', '0xff')))
        : Theme.of(context).colorScheme.primary;
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
            overlayActive: showOverlay,
            baseColor: baseColor,
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
                          if (apiResponse == null) {
                            return null;
                          }
                          // Sicheres Pattern Matching statt isSuccess-Getter
                          return apiResponse.when(
                            success: (data) {
                              if (data.podcasts.isEmpty) return null;
                              final podcast = data.podcasts.first;
                              return podcast.artistName.isNotEmpty
                                  ? podcast.artistName
                                  : null;
                            },
                            error: (_) => null,
                            loading: () => null,
                          );
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
            overlayActive: showOverlay,
            baseColor: baseColor,
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
                          // Pattern Matching statt isSuccess
                          return apiResponse.when(
                            success: (data) {
                              if (data.podcasts.isEmpty)
                                return const SizedBox.shrink();
                              final podcast = data.podcasts.first;
                              if (podcast.artworkUrl600.isEmpty)
                                return const SizedBox.shrink();
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 12),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SafeImage(
                                      imageUrl: podcast.artworkUrl600,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                            error: (_) => const SizedBox.shrink(),
                            loading: () => const SizedBox.shrink(),
                          );
                        },
                        error: (_, __) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
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
            overlayActive: showOverlay,
            baseColor: baseColor,
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
                          return apiResponse.when(
                            success: (data) {
                              if (data.podcasts.isEmpty) return const Text('Keine PodcastCollection geladen');
                              final podcast = data.podcasts.firstOrNull;
                              if (podcast == null) return const Text('Kein Podcast gefunden');
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InfoTile(label: 'Podcast Titel', value: podcast.collectionName),
                                  //PERFEKT: als 'hostName' (=='artistName' -> dann speichern)
                                  InfoTile(label: 'Artist', value: podcast.artistName),
                                  // für Admin (direkter Zugriff, keine Provider-Logik)
                                  // InfoTile(
                                  //     label: 'Feed URL', value: podcast.feedUrl ?? '-'),
                                  // InfoTile(
                                  //     label: 'PodcastId',
                                  //     value: podcast.collectionId.toString()),
                                ],
                              );
                            },
                            error: (_) => const Text('Keine PodcastCollection geladen'),
                            loading: () => const Text('Lade PodcastCollection...'),
                          );
                        },
                        error: (_, __) => const Text('Keine PodcastCollection geladen'),
                        loading: () => const Text('Lade PodcastCollection...'),
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
