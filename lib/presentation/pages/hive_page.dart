// WIP: Noch nicht in die App eingebunden. Experimentelle Hive—Demo.

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/podcast_host_collection_hive_adapter.dart';
import '../../domain/models/podcast_host_collection_mapper.dart';
import '../../domain/models/podcast_model.dart';
import '../../domain/models/podcast_host_collection_model.dart';
import '../../domain/models/collection_meta_model.dart';
import '../../domain/models/data_origin_model.dart';
import '../../domain/enums/data_source_type.dart';

class HivePage extends StatefulWidget {
  const HivePage({Key? key}) : super(key: key);

  @override
  State<HivePage> createState() => _HivePageState();
}

class _HivePageState extends State<HivePage> {
  late final Box<HivePodcastHostCollection> box;
  final Duration ttl = const Duration(hours: 12);

  @override
  void initState() {
    super.initState();
    box = Hive.box<HivePodcastHostCollection>('podcastHostCollections');
  }

  bool isExpired(DateTime? downloadedAt) {
    if (downloadedAt == null) return true;
    return DateTime.now().difference(downloadedAt) > ttl;
  }

  void _showEditDialog([HivePodcastHostCollection? entry]) {
    final model =
        entry != null ? PodcastHostCollectionMapper.fromHive(entry) : null;
    final titleController =
        TextEditingController(text: model?.podcast.collectionName ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            entry == null ? 'Neuen Podcast anlegen' : 'Podcast bearbeiten'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Podcast-Titel'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final title = titleController.text;
              if (entry == null) {
                // Minimaler Demo-Eintrag
                final now = DateTime.now();
                final newModel = PodcastHostCollectionMapper.toHive(
                  PodcastHostCollection(
                    collectionId: now.millisecondsSinceEpoch,
                    podcast: Podcast(
                      wrapperType: 'podcast',
                      collectionId: now.millisecondsSinceEpoch,
                      collectionName: title,
                      artistName: '',
                      primaryGenreName: '',
                      artworkUrl600: '',
                      episodes: [],
                    ),
                    episodes: [],
                    host: null,
                    downloadedAt: now,
                    meta: model?.meta ??
                        CollectionMeta(
                          podcastOrigin: DataOrigin(
                            source: DataSourceType.local,
                            updatedAt: now.toIso8601String(),
                            isFallback: false,
                          ),
                          episodeOrigin: DataOrigin(
                            source: DataSourceType.local,
                            updatedAt: now.toIso8601String(),
                            isFallback: false,
                          ),
                        ),
                  ),
                );
                box.add(newModel);
              } else {
                // Update: Freezed-Modell erzeugen, Feld ändern, zurückmappen
                final updatedModel = model!.copyWith(
                  podcast: model.podcast.copyWith(collectionName: title),
                  downloadedAt: DateTime.now(),
                );
                final updatedHive =
                    PodcastHostCollectionMapper.toHive(updatedModel);
                box.putAt(box.values.toList().indexOf(entry), updatedHive);
              }
              Navigator.pop(context);
            },
            child: Text(entry == null ? 'Anlegen' : 'Speichern'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  void _refreshEntry(HivePodcastHostCollection entry) async {
    // TODO: MergeService().fetchAndMergeCollection(entry.collectionId)
    final model = PodcastHostCollectionMapper.fromHive(entry);
    final updatedModel = model.copyWith(downloadedAt: DateTime.now());
    final updatedHive = PodcastHostCollectionMapper.toHive(updatedModel);
    box.putAt(box.values.toList().indexOf(entry), updatedHive);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive PodcastHostCollections')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<HivePodcastHostCollection> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Keine Einträge vorhanden'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (_, index) {
              final entry = box.getAt(index)!;
              final model = PodcastHostCollectionMapper.fromHive(entry);
              final expired = isExpired(model.downloadedAt);
              return ListTile(
                title: Text(model.podcast.collectionName),
                subtitle: Text('Stand: ${model.downloadedAt ?? 'n.v.'}'),
                leading: Icon(
                  expired ? Icons.error : Icons.check_circle,
                  color: expired ? Colors.red : Colors.green,
                ),
                onTap: () => _showEditDialog(entry),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Aktualisieren',
                      onPressed: () => _refreshEntry(entry),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Löschen',
                      onPressed: () {
                        box.deleteAt(index);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
