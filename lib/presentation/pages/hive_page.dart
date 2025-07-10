// WIP: Noch nicht in die App eingebunden. Experimentelle Hive—Demo.

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import '../../domain/models/podcast_host_collection_hive_adapter.dart';
// import '../../domain/models/podcast_host_collection_mapper.dart';
// import '../../domain/models/podcast_model.dart';
// import '../../domain/models/podcast_host_collection_model.dart';
// import '../../domain/models/collection_meta_model.dart';
// import '../../domain/models/data_origin_model.dart';
// import '../../domain/enums/data_source_type.dart';

class HivePage extends StatefulWidget {
  const HivePage({Key? key}) : super(key: key);

  @override
  State<HivePage> createState() => _HivePageState();
}

class _HivePageState extends State<HivePage> {
  // Ursprüngliche Box und TTL auskommentiert
  // late final Box<HivePodcastHostCollection> box;

  // Ursprüngliche Box und TTL auskommentiert
  // late final Box<HivePodcastHostCollection> box;
  // final Duration ttl = const Duration(hours: 12);
  late final Box box;

  @override
  void initState() {
    super.initState();
    // Ursprüngliche Box auskommentiert
    // box = Hive.box<HivePodcastHostCollection>('podcastHostCollections');
    box = Hive.box('podcastBox');
  }

  // Ursprüngliche Ablaufprüfung auskommentiert
  // bool isExpired(DateTime? downloadedAt) {
  //   if (downloadedAt == null) return true;
  //   return DateTime.now().difference(downloadedAt) > ttl;
  // }

  // Ursprünglicher Edit-Dialog auskommentiert
  /*
  void _showEditDialog([HivePodcastHostCollection? entry]) {
    ...existing code...
  }
  */
  // Vorläufiger Edit-Dialog für podcastBox (flache Objekte)
  void _showEditDialog([dynamic entry]) {
    final key = entry != null ? entry.key : null;
    final value = entry != null ? entry.value : '';
    final keyController = TextEditingController(text: key?.toString() ?? '');
    final valueController =
        TextEditingController(text: value?.toString() ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            entry == null ? 'Neuen Eintrag anlegen' : 'Eintrag bearbeiten'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(labelText: 'Key'),
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'Value (String)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final k = keyController.text;
              final v = valueController.text;
              if (entry == null) {
                box.put(k, v);
              } else {
                box.put(k, v);
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

  // Ursprüngliche Refresh-Logik auskommentiert
  // void _refreshEntry(HivePodcastHostCollection entry) async {
//   final model = PodcastHostCollectionMapper.fromHive(entry);
// final updatedModel = model.copyWith(downloadedAt: DateTime.now());
// final updatedHive = PodcastHostCollectionMapper.toHive(updatedModel);
// box.putAt(box.values.toList().indexOf(entry), updatedHive);
// setState(() {});
  // }

  // --- Ursprüngliche Logik für podcastHostCollections (auskommentiert, für spätere Nutzung) ---
  /*
  void _showEditDialog([HivePodcastHostCollection? entry]) {
  // final model:
  final model = entry != null ? PodcastHostCollectionMapper.fromHive(entry) : null;
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
              final updatedHive = PodcastHostCollectionMapper.toHive(updatedModel);
              box.putAt(box.values.toList().indexOf(entry), updatedHive);
              // final updatedHive
              // PodcastHostCollectionMapper.toHive(updatedModel);
              // box.putAt(box.values.toList().indexOf(entry), updatedHive);
              // box.put(k, v);
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
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive podcastBox (flach)')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Keine Einträge vorhanden'));
          }
          final entries = box.toMap().entries.toList();
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (_, index) {
              final entry = entries[index];
              return ListTile(
                title: Text(entry.key.toString()),
                subtitle: Text(entry.value.toString()),
                onTap: () => _showEditDialog(entry),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Löschen',
                  onPressed: () {
                    box.delete(entry.key);
                    setState(() {});
                  },
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
