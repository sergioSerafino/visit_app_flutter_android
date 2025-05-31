// lib/presentation/widgets/rss_debug_viewer.dart
/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/rss_feed_url_provider.dart';

class RssDebugViewer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rssUrl = ref.watch(rssFeedUrlProvider);
    return Text(rssUrl ?? 'Keine RSS-URL verfügbar');
  }
}

void main() async {
  final rssService = RssParserService();
  final metadata = await rssService.parse('https://anchor.fm/s/xyz1234/podcast/rss');
  rssService.debugPrintMetadata(metadata);
}
*/
