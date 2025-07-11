import '../../domain/models/merge_models.dart';
import 'rss_parser_service.dart';

/// Konvertiert RssMetadata zu RssData
RssData rssMetadataToRssData(RssMetadata meta) {
  return RssData(
    title: meta.hostName, // Alternativ: meta.websiteUrl oder ein anderes Feld
    description: meta.description,
    imageUrl: meta.logoUrl,
    author: meta.ownerName,
    ownerEmail: meta.contactEmail,
  );
}
