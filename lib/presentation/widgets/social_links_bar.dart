import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinksBar extends StatelessWidget {
  final Map<String, String> socialLinks;
  const SocialLinksBar({super.key, required this.socialLinks});

  IconData _iconForPlatform(String platform) {
    final p = platform.toLowerCase();
    if (p.startsWith('facebook')) return FontAwesomeIcons.facebook;
    if (p.startsWith('instagram')) return FontAwesomeIcons.instagram;
    if (p.startsWith('linkedin')) return FontAwesomeIcons.linkedin;
    if (p.startsWith('twitter')) return FontAwesomeIcons.twitter;
    if (p.startsWith('youtube')) return FontAwesomeIcons.youtube;
    if (p.startsWith('tiktok')) return FontAwesomeIcons.tiktok;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    if (socialLinks.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: socialLinks.entries.map((entry) {
            final icon = _iconForPlatform(entry.key);
            return IconButton(
              icon: Icon(icon, size: 48), // doppelte Standardgröße
              tooltip: entry.key,
              onPressed: () => launchUrl(Uri.parse(entry.value),
                  mode: LaunchMode.externalApplication),
            );
          }).toList(),
        ),
      ),
    );
  }
}
