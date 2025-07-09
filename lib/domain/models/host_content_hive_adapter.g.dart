// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_content_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveHostContentAdapter extends TypeAdapter<HiveHostContent> {
  @override
  final int typeId = 24;

  @override
  HiveHostContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveHostContent(
      bio: fields[0] as String?,
      mission: fields[1] as String?,
      rss: fields[2] as String?,
      links: (fields[3] as List?)?.cast<HiveLink>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveHostContent obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.bio)
      ..writeByte(1)
      ..write(obj.mission)
      ..writeByte(2)
      ..write(obj.rss)
      ..writeByte(3)
      ..write(obj.links);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveHostContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
