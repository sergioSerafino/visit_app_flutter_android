// filepath: g:/ProjekteFlutter/empty_flutter_template/_migration_src/storage_hold/lib/core/utils/rss_parser_service.dart
// /core/utils/rss_parser_service.dart

import '../../core/logging/logger_config.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'network_cache_manager.dart';

class RssMetadata {
  final String? websiteUrl;
  final String? description;
  final String? defaultLanguageCode;
  final String? hostName;
  final String? podcastType;
  final String? contactEmail;
  final String? ownerName;
  final String? logoUrl;
  final String? longPrimaryGenreName;

  RssMetadata({
    this.websiteUrl,
    this.description,
    this.defaultLanguageCode,
    this.hostName,
    this.podcastType,
    this.contactEmail,
    this.ownerName,
    this.logoUrl,
    this.longPrimaryGenreName,
  });
}

class RssParserService {
  final Dio _dio = Dio();

  Future<RssMetadata?> parse(String feedUrl) async {
    final cacheManager = NetworkCacheManager(HiveCacheStorage());
    final isExpired = await cacheManager.isResourceExpired(
        feedUrl, const Duration(hours: 24));
    if (!isExpired) {
      // Hier: Prüfe, ob wirklich Metadaten im Cache liegen (z.B. per separater Methode oder speichere Metadaten im Cache)
      // Da aktuell nur der Zeitstempel gecacht wird, lade trotzdem neu, wenn keine Metadaten gefunden werden
      logDebug('RSS-Feed ist laut Cache frisch, versuche trotzdem zu parsen.',
          tag: LogTag.data);
      // Optional: Hier könnte man versuchen, Metadaten aus einem eigenen Cache zu laden
    }
    try {
      final response = await _dio.get<String>(feedUrl);
      logDebug('RSS-HTTP: Status ${response.statusCode} für $feedUrl',
          tag: LogTag.data);
      if (response.statusCode != 200 || response.data == null) {
        logDebug('RSS-HTTP: Fehlerhafte Response oder kein Inhalt für $feedUrl',
            tag: LogTag.data);
        return null;
      }
      logDebug(
          'RSS-HTTP: Erste 200 Zeichen: ${response.data!.substring(0, response.data!.length > 200 ? 200 : response.data!.length)}',
          tag: LogTag.data);
      final document = XmlDocument.parse(response.data!);
      final channel = document.findAllElements('channel').firstOrNull;
      if (channel == null) return null;
      await cacheManager.updateTimeStamp(feedUrl); // TimeStamp aktualisieren
      return RssMetadata(
        websiteUrl: _getElementValue(channel, 'link'),
        description: _getElementValue(channel, 'description'),
        defaultLanguageCode: _getElementValue(channel, 'language'),
        hostName: _getElementValue(channel, 'itunes:author'),
        podcastType: _getElementValue(channel, 'itunes:type'),
        contactEmail: _getElementValue(channel, 'itunes:owner>itunes:email'),
        ownerName: _getElementValue(channel, 'itunes:owner>itunes:name'),
        logoUrl: _getAttribute(channel, 'itunes:image', 'href'),
        longPrimaryGenreName: _getCategoryText(channel),
      );
    } catch (e) {
      logDebug('RSS-Parsing error: $e');
      return null;
    }
  }

  // Öffentliche Methode für Tests: Parsen aus XmlElement
  RssMetadata parseFromChannel(XmlElement channel) {
    return RssMetadata(
      websiteUrl: _getElementValue(channel, 'link'),
      description: _getElementValue(channel, 'description'),
      defaultLanguageCode: _getElementValue(channel, 'language'),
      hostName: _getElementValue(channel, 'itunes:author'),
      podcastType: _getElementValue(channel, 'itunes:type'),
      contactEmail: _getElementValue(channel, 'itunes:owner>itunes:email'),
      ownerName: _getElementValue(channel, 'itunes:owner>itunes:name'),
      logoUrl: _getAttribute(channel, 'itunes:image', 'href'),
      longPrimaryGenreName: _getCategoryText(channel),
    );
  }

  // Neue Hilfsmethode: Parsen direkt aus XML-String (ohne Netzwerk)
  Future<RssMetadata?> parseFromString(String xmlString) async {
    try {
      final document = XmlDocument.parse(xmlString);
      final channel = document.findAllElements('channel').firstOrNull;
      if (channel == null) return null;
      return parseFromChannel(channel);
    } catch (e) {
      logDebug('RSS-Parsing error (parseFromString): $e');
      return null;
    }
  }

  void debugPrintMetadata(RssMetadata? data) {
    if (data == null) {
      logDebug('Keine Daten gefunden oder Fehler beim Parsen.');
      return;
    }

    logDebug('🧩 RSS-Metadaten:');
    logDebug('• Website URL: ${data.websiteUrl}');
    logDebug('• Beschreibung: ${data.description}');
    logDebug('• Sprache: ${data.defaultLanguageCode}');
    logDebug('• Host-Name: ${data.hostName}');
    logDebug('• Podcast-Typ: ${data.podcastType}');
    logDebug('• Kontakt-E-Mail: ${data.contactEmail}');
    logDebug('• Owner-Name: ${data.ownerName}');
    logDebug('• Logo-URL: ${data.logoUrl}');
    logDebug('• Kategorie: ${data.longPrimaryGenreName}');
  }

  String? _getElementValue(XmlElement parent, String path) {
    try {
      final parts = path.split('>');
      XmlElement? current = parent;
      for (final part in parts) {
        current = current?.findElements(part).firstOrNull;
      }
      return current?.text.trim(); // Nullprüfung hinzugefügt
    } catch (_) {
      return null;
    }
  }

  String? _getAttribute(XmlElement parent, String tag, String attribute) {
    try {
      return parent.findElements(tag).first.getAttribute(attribute);
    } catch (_) {
      return null;
    }
  }

  String? _getCategoryText(XmlElement channel) {
    // Hole das äußerste itunes:category-Attribut (text) und ggf. verschachtelte Kategorie
    final mainCategory = channel.findElements('itunes:category').firstOrNull;
    if (mainCategory == null) return null;
    final mainText = mainCategory.getAttribute('text');
    // Falls verschachtelt, hänge Subkategorie(n) mit an
    final subCategory =
        mainCategory.findElements('itunes:category').firstOrNull;
    if (subCategory != null) {
      final subText = subCategory.getAttribute('text');
      if (subText != null && subText.isNotEmpty) {
        return '$mainText > $subText';
      }
    }
    return mainText;
  }
}
