// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveHostAdapter extends TypeAdapter<HiveHost> {
  @override
  final int typeId = 13;

  @override
  HiveHost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveHost(
      collectionId: fields[0] as int,
      hostName: fields[1] as String,
      description: fields[2] as String,
      contact: fields[3] as HiveContactInfo,
      branding: fields[4] as HiveBranding,
      features: fields[5] as HiveFeatureFlags,
      localization: fields[6] as HiveLocalizationConfig,
      content: fields[7] as HiveHostContent,
      primaryGenreName: fields[8] as String?,
      authTokenRequired: fields[9] as bool,
      debugOnly: fields[10] as bool?,
      lastUpdated: fields[11] as DateTime?,
      hostImage: fields[12] as String?,
      sectionTitles: (fields[13] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveHost obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.collectionId)
      ..writeByte(1)
      ..write(obj.hostName)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.contact)
      ..writeByte(4)
      ..write(obj.branding)
      ..writeByte(5)
      ..write(obj.features)
      ..writeByte(6)
      ..write(obj.localization)
      ..writeByte(7)
      ..write(obj.content)
      ..writeByte(8)
      ..write(obj.primaryGenreName)
      ..writeByte(9)
      ..write(obj.authTokenRequired)
      ..writeByte(10)
      ..write(obj.debugOnly)
      ..writeByte(11)
      ..write(obj.lastUpdated)
      ..writeByte(12)
      ..write(obj.hostImage)
      ..writeByte(13)
      ..write(obj.sectionTitles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveHostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
