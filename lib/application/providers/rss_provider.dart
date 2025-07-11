import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/logger_config.dart';
import '../../core/utils/rss_parser_service.dart';
import '../../core/utils/rss_data_mapper.dart';
import '../../domain/models/merge_models.dart';

final rssProvider = FutureProvider.family<RssData?, String>((ref, feedUrl) async {
  if (feedUrl.isEmpty) {
    logDebug('RSS-Provider: feedUrl ist leer!', tag: LogTag.data);
    return null;
  }
  final parser = RssParserService();
  final meta = await parser.parse(feedUrl);
  if (meta == null) {
    logDebug('RSS-Provider: Keine Metadaten für $feedUrl erhalten!', tag: LogTag.data);
    return null;
  } else {
    logDebug('RSS-Provider: Metadaten erfolgreich geladen für $feedUrl', tag: LogTag.data);
    return rssMetadataToRssData(meta);
  }
});
