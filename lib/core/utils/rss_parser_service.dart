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

    // Überprüfen, ob die Ressource veraltet ist
    if (!await cacheManager.isResourceExpired(
        feedUrl, const Duration(hours: 24))) {
      logDebug('RSS-Feed ist aktuell, kein Abruf erforderlich.');
      return null;
    }

    try {
      final response = await _dio.get<String>(feedUrl);
      if (response.statusCode != 200 || response.data == null) return null;

      final document = XmlDocument.parse(response.data!);
      final channel = document.findAllElements('channel').firstOrNull;
      if (channel == null) return null;
      // Aktualisiere den TimeStamp nach erfolgreichem Abruf
      await cacheManager.updateTimeStamp(feedUrl);

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
      return current != null
          ? current.text.trim()
          : null; // Nullprüfung hinzugefügt
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
    final category = channel.findElements('itunes:category').firstOrNull;
    return category?.getAttribute('text');
  }
}
