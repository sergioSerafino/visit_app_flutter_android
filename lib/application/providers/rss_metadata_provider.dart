import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/rss_parser_service.dart';
import '../../core/logging/logger_config.dart';

final rssMetadataProvider =
    FutureProvider.family<RssMetadata?, String>((ref, feedUrl) async {
  if (feedUrl.isEmpty) {
    logDebug('RSS-Provider: feedUrl ist leer!', tag: LogTag.data);
    return null;
  }
  final parser = RssParserService();
  final meta = await parser.parse(feedUrl);
  if (meta == null) {
    logDebug('RSS-Provider: Keine Metadaten für $feedUrl erhalten!',
        tag: LogTag.data);
  } else {
    logDebug('RSS-Provider: Metadaten erfolgreich geladen für $feedUrl',
        tag: LogTag.data);
  }
  return meta;
});
