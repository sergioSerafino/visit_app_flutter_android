// pages/hosts_page.dart
// HostsPage: Übersicht und Detailinformationen zu Host, Podcast/RSS und Portfolio.
// Clean Architecture: Präsentationsschicht, keine direkte Datenlogik.
// UI/UX: StickyHeader für alle Abschnitte, robuste async-Fehlerbehandlung, konsistente Gestaltung.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticky_headers/sticky_headers.dart';
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
    // AsyncValue für PodcastCollection (wird im Podcast-/RSS-Abschnitt verwendet)
    final podcastCollectionAsync = ref.watch(
      podcastCollectionProvider(host.collectionId),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          // --- StickyHeader: Lokale Host-Informationen ---
          StickyHeader(
            header: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 24.0, right: 24.0),
              child: Text('Lokale Host-Informationen',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Host-Basisdaten
                //PERFEKT: als 'hostName' (=='artistName' -> dann speichern)
                InfoTile(label: 'Host Name', value: host.hostName),
                //PERFEKT: als 'description' (aus RSS)
                InfoTile(label: 'Beschreibung', value: host.description),
                //PERFEKT: als 'socialLinks' (aus JSON)
                InfoTile(
                    label: 'Social Links',
                    value: host.contact.socialLinks?.entries
                            .map((e) => '${e.key}: ${e.value}')
                            .join(', ') ??
                        '-'),
                //PERFEKT: als 'websiteUrl' (aus JSON)
                InfoTile(
                    label: 'Website', value: host.contact.websiteUrl ?? '-'),
                //PERFEKT: als 'impressumUrl' (aus JSON)
                InfoTile(
                    label: 'Impressum',
                    value: host.contact.impressumUrl ?? '-'),
                //PERFEKT: als 'bio' (aus JSON)
                InfoTile(label: 'Bio', value: host.content.bio ?? '-'),
                //PERFEKT: als 'mission' (aus JSON)
                InfoTile(label: 'Mission', value: host.content.mission ?? '-'),
                //PERFEKT: als 'lastUpdated' (aus JSON)
                InfoTile(
                    label: 'Last Updated',
                    value: host.lastUpdated?.toIso8601String() ?? '-'),
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
                // PortfolioTab-Status (aus HostCard übernommen)
                if (host.features.showPortfolioTab ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Chip(
                      label: Text('PortfolioTab aktiviert',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondary.withAlpha(51),
                    ),
                  ),
                if (!(host.features.showPortfolioTab ?? true))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Chip(
                      label: Text('PortfolioTab deaktiviert',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onError)),
                      backgroundColor:
                          Theme.of(context).colorScheme.error.withAlpha(51),
                    ),
                  ),
                // Visuelle Trennung zum nächsten Abschnitt
                const Divider(height: 32),
              ],
            ),
          ),
          // --- StickyHeader: Podcast-/RSS-Informationen (async, robust) ---
          StickyHeader(
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Podcast-/RSS-Informationen',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: podcastCollectionAsync.when(
                data: (apiResponse) {
                  // Fehler- und Datenprüfung
                  if (!apiResponse.isSuccess || apiResponse.data == null) {
                    return const Text('Keine PodcastCollection geladen');
                  }
                  final podcast = apiResponse.data!.podcasts.firstOrNull;
                  if (podcast == null) {
                    return const Text('Kein Podcast gefunden');
                  }
                  final feedUrl = podcast.feedUrl ?? '';
                  // AsyncValue für RSS-Metadaten (wird im UI-Baum weiter unten verwendet)
                  final rssMetaAsync = ref.watch(rssMetadataProvider(feedUrl));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Podcast-Basisdaten
                      //PERFEKT: als 'collectionName' (Podcast Titel)
                      InfoTile(
                          label: 'Podcast Titel',
                          value: podcast.collectionName),
                      //PERFEKT: als 'artistName' (aus iTunes)
                      InfoTile(label: 'Artist', value: podcast.artistName),
                      //PERFEKT: als 'artworkUrl600' (aus iTunes)
                      InfoTile(label: 'Artwork', value: podcast.artworkUrl600),
                      //PERFEKT: als 'artworkUrl600' (Bild)
                      if (podcast.artworkUrl600.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  podcast.artworkUrl600,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[300],
                                    width: 180,
                                    height: 180,
                                    child: Icon(Icons.broken_image,
                                        size: 48, color: Colors.grey[500]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      //PERFEKT: als 'numberOfEpisodes' (aus Podcast)
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
                                  //PERFEKT: als 'meta.hostName' (aus RSS)
                                  InfoTile(
                                      label: 'RSS Host Name',
                                      value: meta.hostName ?? '-'),
                                  //PERFEKT: als 'meta.description' (aus RSS)
                                  InfoTile(
                                      label: 'RSS Beschreibung',
                                      value: meta.description ?? '-'),
                                  //PERFEKT: als 'meta.contactEmail' (aus RSS)
                                  InfoTile(
                                      label: 'Kontakt E-Mail (RSS)',
                                      value: meta.contactEmail ?? '-'),
                                  //PERFEKT: als 'meta.websiteUrl' (aus RSS)
                                  InfoTile(
                                      label: 'Website (RSS)',
                                      value: meta.websiteUrl ?? '-'),
                                  //PERFEKT: als 'meta.longPrimaryGenreName' (aus RSS)
                                  InfoTile(
                                      label: 'Kategorie bei iTunes',
                                      value: meta.longPrimaryGenreName ?? '-'),
                                ],
                              ),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (e, st) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 32),
                                SizedBox(height: 8),
                                Text('Fehler beim Laden der RSS-Metadaten'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.error_outline, color: Colors.red, size: 32),
                      SizedBox(height: 8),
                      Text('Fehler beim Laden der Podcast-Daten'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // --- StickyHeader: Angebote / Portfolio (optional, je nach FeatureFlag) ---
          StickyHeader(
            header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Angebote / Portfolio',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hier können Portfolio-spezifische Felder/Widgets ergänzt werden
                if (host.features.showPortfolioTab ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Portfolio-Inhalte folgen ...',
                        style: Theme.of(context).textTheme.bodyLarge),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Kein Portfolio verfügbar',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
              ],
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
