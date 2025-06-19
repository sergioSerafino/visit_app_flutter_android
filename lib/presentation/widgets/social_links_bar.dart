import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinksBar extends StatelessWidget {
  final Map<String, String> socialLinks;
  final Color? iconColor;
  const SocialLinksBar({super.key, required this.socialLinks, this.iconColor});

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

  String _extractProfileLabel(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      if (path.isEmpty || path == '/') return '';
      final segments = path.split('/').where((s) => s.isNotEmpty).toList();
      if (segments.isEmpty) return '';
      return segments.last;
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (socialLinks.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: socialLinks.entries.map((entry) {
          final icon = _iconForPlatform(entry.key);
          final label =
              entry.key.length > 12 ? entry.key.substring(0, 12) : entry.key;
          final profileLabel = _extractProfileLabel(entry.value);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(icon,
                    size: 40,
                    color: iconColor ?? Theme.of(context).colorScheme.primary),
                tooltip: entry.key,
                onPressed: () => launchUrl(Uri.parse(entry.value),
                    mode: LaunchMode.externalApplication),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (profileLabel.isNotEmpty)
                SizedBox(
                  width: 60,
                  child: Text(
                    profileLabel,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
