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
    // WebsiteTile
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
