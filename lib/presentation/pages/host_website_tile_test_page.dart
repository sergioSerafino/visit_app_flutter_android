import 'package:flutter/material.dart';
import '../widgets/host_website_tile.dart';

class HostWebsiteTileTestPage extends StatelessWidget {
  const HostWebsiteTileTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HostWebsiteTile Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            HostWebsiteTile(
              label: 'Website',
              url:
                  'https://www.sehr-lange-url-mit-vielen-zeichen-und-ohne-umbruch.de/pfad/zu/irgendwas/nochmehrtext',
            ),
            SizedBox(height: 24),
            HostWebsiteTile(
              label: 'Kurz',
              url: 'https://kurz.de',
            ),
            SizedBox(height: 24),
            HostWebsiteTile(
              label: '',
              url: 'https://www.ein-link-ohne-label.de/nochlaengerertext',
            ),
          ],
        ),
      ),
    );
  }
}
