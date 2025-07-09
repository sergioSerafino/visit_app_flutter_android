// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_episode_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePodcastEpisodeAdapter extends TypeAdapter<HivePodcastEpisode> {
  @override
  final int typeId = 12;

  @override
  HivePodcastEpisode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePodcastEpisode(
      wrapperType: fields[0] as String,
      trackId: fields[1] as int,
      trackName: fields[2] as String,
      artworkUrl600: fields[3] as String,
      description: fields[4] as String?,
      episodeUrl: fields[5] as String,
      trackTimeMillis: fields[6] as int,
      episodeFileExtension: fields[7] as String,
      releaseDate: fields[8] as DateTime,
      downloadedAt: fields[9] as DateTime?,
      localId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HivePodcastEpisode obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.wrapperType)
      ..writeByte(1)
      ..write(obj.trackId)
      ..writeByte(2)
      ..write(obj.trackName)
      ..writeByte(3)
      ..write(obj.artworkUrl600)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.episodeUrl)
      ..writeByte(6)
      ..write(obj.trackTimeMillis)
      ..writeByte(7)
      ..write(obj.episodeFileExtension)
      ..writeByte(8)
      ..write(obj.releaseDate)
      ..writeByte(9)
      ..write(obj.downloadedAt)
      ..writeByte(10)
      ..write(obj.localId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePodcastEpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
