// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePodcastAdapter extends TypeAdapter<HivePodcast> {
  @override
  final int typeId = 11;

  @override
  HivePodcast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePodcast(
      wrapperType: fields[0] as String,
      collectionId: fields[1] as int,
      collectionName: fields[2] as String,
      artistName: fields[3] as String,
      primaryGenreName: fields[4] as String,
      artworkUrl600: fields[5] as String,
      feedUrl: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HivePodcast obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.wrapperType)
      ..writeByte(1)
      ..write(obj.collectionId)
      ..writeByte(2)
      ..write(obj.collectionName)
      ..writeByte(3)
      ..write(obj.artistName)
      ..writeByte(4)
      ..write(obj.primaryGenreName)
      ..writeByte(5)
      ..write(obj.artworkUrl600)
      ..writeByte(6)
      ..write(obj.feedUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePodcastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
