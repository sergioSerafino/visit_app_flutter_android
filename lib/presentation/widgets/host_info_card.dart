// pages/hosts_page.dart
// HostsPage: Übersicht und Detailinformationen zu Host, Podcast/RSS und Portfolio.
// Clean Architecture: Präsentationsschicht, keine direkte Datenlogik.
// UI/UX: StickyHeader für alle Abschnitte, robuste async-Fehlerbehandlung, konsistente Gestaltung.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/sticky_info_header.dart';
import '../widgets/simple_section_header.dart';
import '../widgets/tenant_logo_widget.dart';
import '../widgets/social_links_bar.dart';
import '../../core/utils/sticky_info_header_constants.dart';
import '../../application/providers/podcast_provider.dart';
import '../../domain/common/api_response.dart';
import '../../application/providers/rss_metadata_provider.dart';
import '../../core/utils/tenant_asset_loader.dart';
import '../widgets/splash_cover_image.dart';
import '../../domain/models/host_model.dart';

class HostsPage extends ConsumerWidget {
  const HostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ...existing code...
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

class WebsiteTile extends StatelessWidget {
  final String label;
  final String url;
  const WebsiteTile({super.key, required this.label, required this.url});

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

class HostInfoCard extends ConsumerWidget {
  final Host host;
  const HostInfoCard({super.key, required this.host});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // assetLogo ganz oben
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: TenantLogoWidget(
                  collectionId: host.collectionId,
                  assetLogo: host.branding.assetLogo,
                  scaleFactor: 0.5,
                ),
              ),
              // Mission-Beschreibung
              InfoTile(label: 'Mission', value: host.content.mission ?? '-'),
              // logo (SplashCoverImage)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.28,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: 0.7,
                        child: SplashCoverImage(
                          assetPath:
                              TenantAssetLoader(host.collectionId).imagePath(),
                          imageUrl: host.branding.logoUrl,
                          scaleFactor: 1.0,
                          duration: const Duration(milliseconds: 800),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Bio-Beschreibung
              InfoTile(label: 'Bio', value: host.content.bio ?? '-'),
              // hostImage
              if (host.hostImage != null && host.hostImage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'lib/tenants/collection_${host.collectionId}/assets/${host.hostImage}',
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              InfoTile(
                label: 'Last Updated',
                value: host.lastUpdated?.toIso8601String() ?? '-',
              ),
              const Divider(height: 32),
              // --- Kontakt / Visit ---
              Consumer(
                builder: (context, ref, _) {
                  final podcastCollectionAsync = ref.watch(
                    podcastCollectionProvider(host.collectionId),
                  );
                  return podcastCollectionAsync.when(
                    data: (apiResponse) {
                      if (!apiResponse.isSuccess || apiResponse.data == null) {
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
                        data: (rssMeta) => InfoTile(
                          label: 'E-Mail',
                          value: rssMeta?.contactEmail ?? '-',
                        ),
                        loading: () =>
                            const InfoTile(label: 'E-Mail', value: '...'),
                        error: (e, st) =>
                            const InfoTile(label: 'E-Mail', value: '-'),
                      );
                    },
                    loading: () =>
                        const InfoTile(label: 'E-Mail', value: '...'),
                    error: (e, st) =>
                        const InfoTile(label: 'E-Mail', value: '-'),
                  );
                },
              ),
              if (host.contact.socialLinks != null &&
                  host.contact.socialLinks!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SocialLinksBar(socialLinks: host.contact.socialLinks!),
                ),
              const Divider(height: 32),
              // --- Angebote & Portfolio ---
              Consumer(
                builder: (context, ref, _) {
                  final podcastCollectionAsync = ref.watch(
                    podcastCollectionProvider(host.collectionId),
                  );
                  return podcastCollectionAsync.when(
                    data: (apiResponse) {
                      if (!apiResponse.isSuccess || apiResponse.data == null) {
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
                        data: (rssMeta) {
                          final website =
                              rssMeta?.websiteUrl?.isNotEmpty == true
                                  ? rssMeta!.websiteUrl!
                                  : (host.contact.websiteUrl ?? '-');
                          return WebsiteTile(
                            label: 'Website',
                            url: website,
                          );
                        },
                        loading: () =>
                            const InfoTile(label: 'Website', value: '...'),
                        error: (e, st) => InfoTile(
                            label: 'Website',
                            value: host.contact.websiteUrl ?? '-'),
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
              Consumer(
                builder: (context, ref, _) {
                  final podcastCollectionAsync = ref.watch(
                    podcastCollectionProvider(host.collectionId),
                  );
                  return podcastCollectionAsync.when(
                    data: (apiResponse) {
                      if (!apiResponse.isSuccess || apiResponse.data == null) {
                        return const SizedBox.shrink();
                      }
                      final podcast = apiResponse.data!.podcasts.isNotEmpty
                          ? apiResponse.data!.podcasts.first
                          : null;
                      if (podcast == null || podcast.artworkUrl600.isEmpty) {
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
              const Divider(height: 32),
              // --- Weitere Informationen ---
              InfoTile(label: 'Host Name', value: host.hostName),
              InfoTile(label: 'Beschreibung', value: host.description),
              InfoTile(
                  label: 'Social Links',
                  value: host.contact.socialLinks?.entries
                          .map((e) => '${e.key}: ${e.value}')
                          .join(', ') ??
                      '-'),
              InfoTile(
                  label: 'Impressum', value: host.contact.impressumUrl ?? '-'),
              InfoTile(label: 'Bio', value: host.content.bio ?? '-'),
              InfoTile(label: 'Mission', value: host.content.mission ?? '-'),
              InfoTile(
                  label: 'Primärfarbe',
                  value: host.branding.primaryColorHex ?? '-'),
              InfoTile(
                  label: 'Sekundärfarbe',
                  value: host.branding.secondaryColorHex ?? '-'),
              InfoTile(
                label: 'PortfolioTab',
                value: (host.features.showPortfolioTab ?? false)
                    ? 'aktiviert'
                    : 'deaktiviert',
              ),
              InfoTile(
                label: 'Last Updated',
                value: host.lastUpdated?.toIso8601String() ?? '-',
              ),
              // Dynamische Host-Felder
              //PERFEKT: als HAUPTE SEKTION
              InfoTile(
                  label: 'CollectionId', value: host.collectionId.toString()),
              InfoTile(
                  label: 'Primäres Genre', value: host.primaryGenreName ?? '-'),
              // verleichen mit
              InfoTile(
                  label: 'Kontakt E-Mail', value: host.contact.email ?? '-'),
              // für Admin
              InfoTile(label: 'RSS-Feed', value: host.content.rss ?? '-'),
              InfoTile(
                  label: 'PortfolioTab',
                  value: (host.features.showPortfolioTab ?? false).toString()),
              InfoTile(
                  label: 'Branding Primary',
                  value: host.branding.primaryColorHex ?? '-'),
              InfoTile(
                  label: 'Branding Secondary',
                  value: host.branding.secondaryColorHex ?? '-'),
              InfoTile(
                  label: 'Branding Logo', value: host.branding.logoUrl ?? '-'),
              InfoTile(
                  label: 'Theme Mode', value: host.branding.themeMode ?? '-'),
              InfoTile(
                  label: 'Debug Only',
                  value: host.debugOnly?.toString() ?? '-'),
              //PERFEKT: als 'host.lastUpdated'
            ],
          ),
        ),
      ),
    );
  }
}
