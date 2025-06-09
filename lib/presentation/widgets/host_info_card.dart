import 'package:flutter/material.dart';
import '../../core/utils/tenant_asset_loader.dart';
import '../../domain/models/host_model.dart';
import '../widgets/splash_cover_image.dart';

/// Widget für die übersichtliche Darstellung eines Hosts mit allen relevanten Infos
class HostInfoCard extends StatelessWidget {
  final Host host;
  const HostInfoCard({Key? key, required this.host}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final branding = host.branding;
    return Card(
      color: theme.colorScheme.primary.withAlpha(25),
      elevation: 4,
      margin: const EdgeInsets.all(32),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SplashCoverImage als Artwork oben in der Card
            SplashCoverImage(
              assetPath: TenantAssetLoader(host.collectionId).imagePath(),
              imageUrl: branding.logoUrl,
              scaleFactor: 0.25,
              duration: const Duration(milliseconds: 800),
            ),

            const SizedBox(height: 16),
            Text(
              host.hostName,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              host.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Kontakt:  ${host.contact.email}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Primärfarbe: ${branding.primaryColorHex ?? "-"}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sekundärfarbe: ${branding.secondaryColorHex ?? "-"}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 16),
            if (host.features.showPortfolioTab ?? false)
              Chip(
                label: Text('PortfolioTab aktiviert',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSecondary)),
                backgroundColor: theme.colorScheme.secondary.withAlpha(51),
              ),
            if (!(host.features.showPortfolioTab ?? true))
              Chip(
                label: Text('PortfolioTab deaktiviert',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onError)),
                backgroundColor: theme.colorScheme.error.withAlpha(51),
              ),
            const SizedBox(height: 16),
            // Erweiterbar: Weitere Felder wie Mission, Bio, Links etc.
            if (host.content.bio != null && host.content.bio!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Bio: ${host.content.bio}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (host.content.mission != null &&
                host.content.mission!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Mission: ${host.content.mission}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // Links, Genre, weitere Felder ...
          ],
        ),
      ),
    );
  }
}
