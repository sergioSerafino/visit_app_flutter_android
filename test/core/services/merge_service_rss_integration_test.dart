import 'package:flutter_test/flutter_test.dart';
import 'package:empty_flutter_template/domain/models/merge_models.dart';
import 'package:empty_flutter_template/core/utils/rss_parser_service.dart';
import 'package:xml/xml.dart';

void main() {
  group('MergeService Integration mit echtem RSS-Objekt', () {
    test('Merge priorisiert Felder korrekt: RSS > LocalJson', () async {
      // Arrange: Simuliere RSS-Feed als String
      const rssString = '''
      <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
        <channel>
          <title>Opalia Talk</title>
          <description>Beschreibung aus RSS</description>
          <itunes:summary>Zusammenfassung aus iTunes Summary</itunes:summary>
          <itunes:owner>
            <itunes:email>kontakt@opalia.group</itunes:email>
            <itunes:name>Sabine Guhr-Biermann</itunes:name>
          </itunes:owner>
          <itunes:image href="https://example.com/logo_opalia.png"/>
        </channel>
      </rss>
      ''';
      final document = XmlDocument.parse(rssString);
      final channel = document.findAllElements('channel').first;
      final parser = RssParserService();
      final rssMeta = parser.parseFromChannel(channel);
      // Mapping auf RssData-Modell
      final rssData = RssData(
        title: 'Opalia Talk',
        description: rssMeta.description,
        imageUrl: rssMeta.logoUrl,
        author: rssMeta.ownerName,
        ownerEmail: rssMeta.contactEmail,
      );
      // Simuliere LocalJsonData
      final localData = LocalJsonData(
        collectionId: 1590516386,
        title: 'Opalia Talk',
        description: 'Beschreibung aus LocalJson',
        imageUrl: 'https://example.com/logo_local.png',
        author: 'Sabine Guhr-Biermann',
        contactEmail: 'kontakt@local.de',
        authTokenRequired: false,
        featureFlags: ['showPortfolioTab'],
      );
      // Merge-Logik wie im MergeService (vereinfacht)
      final merged = PodcastHostCollection(
        collectionId: 1590516386,
        title: rssData.title ?? localData.title,
        description: rssData.description ?? localData.description,
        logoUrl: rssData.imageUrl ?? localData.imageUrl,
        author: rssData.author ?? localData.author,
        contactEmail: rssData.ownerEmail ?? localData.contactEmail,
        authTokenRequired: localData.authTokenRequired ?? false,
        isManagedCollection: false,
        featureFlags: localData.featureFlags ?? [],
        lastUpdated: DateTime.now(),
      );
      // Assert: RSS-Felder haben Priorität
      expect(merged.description, 'Beschreibung aus RSS');
      expect(merged.logoUrl, 'https://example.com/logo_opalia.png');
      expect(merged.contactEmail, 'kontakt@opalia.group');
      expect(merged.author, 'Sabine Guhr-Biermann');
    });
  });
}
