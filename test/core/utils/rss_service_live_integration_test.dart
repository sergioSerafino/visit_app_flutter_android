import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_app_flutter_android/core/utils/rss_service.dart';
import 'package:dio/dio.dart';

void main() {
  group('Live RSS Integration', () {
    test(
      'anchor.fm Feed wird erfolgreich geladen, geparst und ausgegeben',
      () async {
        final rssService = RssService(Dio());
        // Beispiel-Feed aus deinem data.json
        const feedUrl = 'https://anchor.fm/s/6bc06ed8/podcast/rss';
        final rssData = await rssService.fetchRssData(feedUrl);
        expect(rssData, isNotNull, reason: 'RSS-Daten sollten geladen werden');
        // Ausgabe auf der Konsole
        print('--- RSS-Daten ---');
        print('Beschreibung: \\${rssData!.description}');
        print('Logo-URL: \\${rssData.imageUrl}');
        print('Autor: \\${rssData.author}');
        print('Owner-Email: \\${rssData.ownerEmail}');
        // Schreibe die wichtigsten Felder in eine Datei
        final file = File('test_output.txt');
        await file.writeAsString(
          'Beschreibung: \\${rssData.description}\nLogo-URL: \\${rssData.imageUrl}\nAutor: \\${rssData.author}\nOwner-Email: \\${rssData.ownerEmail}\n',
        );
      },
    );
  });
}
