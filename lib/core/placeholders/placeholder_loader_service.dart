// Lädt Placeholder-Daten aus assets
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../domain/models/host_model.dart';
import '../../domain/models/merge_models.dart';

class PlaceholderLoaderService {
  static late Host hostModel;
  static late PodcastCollection podcastCollection;

  // Instanzmethode für Testbarkeit
  Future<LocalJsonData> loadLocalJsonData(int collectionId) async {
    final jsonStr = await rootBundle.loadString(
      'assets/placeholders/host_model.json',
    );
    final json = jsonDecode(jsonStr);
    return LocalJsonData.fromJson(json);
  }

  static Future<void> init() async {
    final hostJson = await rootBundle.loadString(
      'assets/placeholders/host_model.json',
    );
    final collectionJson = await rootBundle.loadString(
      'assets/placeholders/podcast_collection.json',
    );

    hostModel = Host.fromJson(jsonDecode(hostJson));
    podcastCollection = PodcastCollection.fromJson(jsonDecode(collectionJson));
  }

  // Statische Methode bleibt als Fallback erhalten, ruft aber die Instanzmethode auf
  static Future<LocalJsonData> loadLocalJsonDataStatic(int collectionId) async {
    return await PlaceholderLoaderService().loadLocalJsonData(collectionId);
  }
}
