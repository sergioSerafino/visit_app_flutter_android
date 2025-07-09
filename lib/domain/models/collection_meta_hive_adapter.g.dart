// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_meta_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCollectionMetaAdapter extends TypeAdapter<HiveCollectionMeta> {
  @override
  final int typeId = 26;

  @override
  HiveCollectionMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCollectionMeta(
      source: fields[0] as String?,
      version: fields[1] as String?,
      lastSynced: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCollectionMeta obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.source)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.lastSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCollectionMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
