// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_config_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLocalizationConfigAdapter
    extends TypeAdapter<HiveLocalizationConfig> {
  @override
  final int typeId = 23;

  @override
  HiveLocalizationConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLocalizationConfig(
      defaultLanguageCode: fields[0] as String?,
      localizedTexts: (fields[1] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveLocalizationConfig obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.defaultLanguageCode)
      ..writeByte(1)
      ..write(obj.localizedTexts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLocalizationConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
