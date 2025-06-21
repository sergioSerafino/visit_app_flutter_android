import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Zeigt eine WebsiteTile (Label/URL-Paar) auf der HostsPage an.
///
/// Öffnet die URL beim Antippen im externen Browser.
/// Das Layout, Padding und die Stilistik bleiben wie im Original.
class HostWebsiteTile extends StatelessWidget {
  final String label;
  final String url;
  const HostWebsiteTile({super.key, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    final isValid = url.isNotEmpty && url != '-';
    final isLongUrl = url.length > 28;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.public, color: Colors.blue),
                if (label.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('$label:',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
              ],
            ),
            GestureDetector(
              onTap: isValid
                  ? () async {
                      final uri = Uri.tryParse(url);
                      if (uri != null) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    }
                  : null,
              child: Text(
                url,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isValid ? Colors.blue : null,
                      decoration: isValid ? TextDecoration.underline : null,
                    ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
