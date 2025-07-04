import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:visit_app_flutter_android/core/utils/rss_parser_service.dart';

void main() {
  group('RssParserService', () {
    test('parst RSS-Feed aus String korrekt', () async {
      // Arrange: Minimaler, aber realistischer RSS-Feed-Ausschnitt
      const rssString = '''
      <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
        <channel>
          <title>Opalia Talk</title>
          <description>Der Zuhörer erhält nicht nur einen hohen und lebendigen Unterhaltungswert...</description>
          <itunes:summary>&lt;p&gt;„Krieg Kinder!“, haben sie gesagt; „Es wird schön!“, haben sie gesagt.&lt;/p&gt;</itunes:summary>
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
      final metadata = parser.parseFromChannel(channel);

      // Assert: Die wichtigsten Felder sind nicht leer und plausibel
      expect(metadata.description, isNotNull);
      expect(metadata.description!.isNotEmpty, true);
      expect(metadata.contactEmail, 'kontakt@opalia.group');
      expect(metadata.logoUrl, 'https://example.com/logo_opalia.png');
      // itunes:summary ist im aktuellen Modell nicht direkt enthalten, kann aber bei Bedarf ergänzt werden
    });
  });
}
