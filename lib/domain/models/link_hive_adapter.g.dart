// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLinkAdapter extends TypeAdapter<HiveLink> {
  @override
  final int typeId = 25;

  @override
  HiveLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLink(
      title: fields[0] as String?,
      url: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveLink obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
