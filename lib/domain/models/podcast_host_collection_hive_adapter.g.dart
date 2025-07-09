// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_host_collection_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePodcastHostCollectionAdapter
    extends TypeAdapter<HivePodcastHostCollection> {
  @override
  final int typeId = 10;

  @override
  HivePodcastHostCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePodcastHostCollection(
      collectionId: fields[0] as int,
      podcast: fields[1] as HivePodcast,
      episodes: (fields[2] as List).cast<HivePodcastEpisode>(),
      host: fields[3] as HiveHost?,
      downloadedAt: fields[4] as DateTime?,
      meta: fields[5] as HiveCollectionMeta,
    );
  }

  @override
  void write(BinaryWriter writer, HivePodcastHostCollection obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.collectionId)
      ..writeByte(1)
      ..write(obj.podcast)
      ..writeByte(2)
      ..write(obj.episodes)
      ..writeByte(3)
      ..write(obj.host)
      ..writeByte(4)
      ..write(obj.downloadedAt)
      ..writeByte(5)
      ..write(obj.meta);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePodcastHostCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
