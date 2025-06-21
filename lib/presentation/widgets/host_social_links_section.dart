import 'package:flutter/material.dart';
import '../widgets/social_links_bar.dart';

/// Zeigt die Social Links Bar auf der HostsPage an.
///
/// Wird nur angezeigt, wenn Social Links vorhanden sind.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostSocialLinksSection extends StatelessWidget {
  final Map<String, String> socialLinks;
  final Color? iconColor;
  const HostSocialLinksSection(
      {super.key, required this.socialLinks, this.iconColor});

  @override
  Widget build(BuildContext context) {
    // Social Links Bar
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SocialLinksBar(socialLinks: socialLinks, iconColor: iconColor),
    );
  }
}
