import 'package:flutter/material.dart';
import '../widgets/tenant_logo_widget.dart';

/// Zeigt das Host-Logo oben auf der HostsPage an.
///
/// Das Padding, die Einbindung und die Übergabe der Parameter bleiben wie im Original.
class HostLogoSection extends StatelessWidget {
  final int collectionId;
  final String? assetLogo;
  final double scaleFactor;
  const HostLogoSection({
    super.key,
    required this.collectionId,
    required this.assetLogo,
    this.scaleFactor = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    // assetLogo ganz oben
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: TenantLogoWidget(
        collectionId: collectionId,
        assetLogo: assetLogo,
        scaleFactor: scaleFactor,
      ),
    );
  }
}
