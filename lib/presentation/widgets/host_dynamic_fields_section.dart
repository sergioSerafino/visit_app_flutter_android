import 'package:flutter/material.dart';
import '../widgets/host_info_tile.dart';

/// Zeigt dynamische Host-Felder als Liste von InfoTiles auf der HostsPage an.
///
/// Wird für verschiedene Felder wie Host Name, Beschreibung, CollectionId etc. verwendet.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostDynamicFieldsSection extends StatelessWidget {
  final dynamic host;
  final bool isAdmin;
  const HostDynamicFieldsSection(
      {super.key, required this.host, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    // Dynamische Host-Felder
    final List<Widget> tiles = [
      HostInfoTile(label: 'Host Name', value: host.hostName ?? '-'),
      HostInfoTile(label: 'Beschreibung', value: host.description ?? '-'),
      HostInfoTile(
          label: 'CollectionId', value: host.collectionId?.toString() ?? '-'),
      // ...weitere Standardfelder...
    ];
    if (isAdmin) {
      // für Admin
      tiles.addAll([
        // für Admin
        HostInfoTile(label: 'RSS-Feed', value: host.content?.rss ?? '-'),
        // für Admin
        HostInfoTile(
            label: 'PortfolioTab',
            value: (host.features?.showPortfolioTab ?? false).toString()),
        // für Admin
        HostInfoTile(
            label: 'Branding Primary',
            value: host.branding?.primaryColorHex ?? '-'),
        // für Admin
        HostInfoTile(
            label: 'Branding Secondary',
            value: host.branding?.secondaryColorHex ?? '-'),
        // für Admin
        HostInfoTile(
            label: 'Branding Logo', value: host.branding?.logoUrl ?? '-'),
        // für Admin
        HostInfoTile(
            label: 'Theme Mode', value: host.branding?.themeMode ?? '-'),
        // für Admin
        HostInfoTile(
            label: 'Debug Only', value: host.debugOnly?.toString() ?? '-'),
        // PERFEKT: als 'host.lastUpdated'
        HostInfoTile(
            label: 'Last Updated',
            value: host.lastUpdated?.toIso8601String() ?? '-'),
      ]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tiles,
    );
    // für Admin
    // InfoTile(label: 'RSS-Feed', value: host.content.rss ?? '-'),
    // InfoTile(
    //     label: 'PortfolioTab',
    //     value: (host.features.showPortfolioTab ?? false).toString()),
    // InfoTile(
    //     label: 'Branding Primary',
    //     value: host.branding.primaryColorHex ?? '-'),
    // InfoTile(
    //     label: 'Branding Secondary',
    //     value: host.branding.secondaryColorHex ?? '-'),
    // InfoTile(
    //     label: 'Branding Logo',
    //     value: host.branding.logoUrl ?? '-'),
    // InfoTile(label: 'Theme Mode', value: host.branding.themeMode ?? '-'),
    // InfoTile(
    // label: 'Debug Only', value: host.debugOnly?.toString() ?? '-'),
    // PERFEKT: als 'host.lastUpdated'
    // InfoTile(
    //     label: 'Last Updated',
    //     value: host.lastUpdated?.toIso8601String() ?? '-'),
    // const Divider(height: 32),
    // Text('Podcast-/RSS-Informationen',
    //     style: Theme.of(context).textTheme.bodyMedium),
  }
}
