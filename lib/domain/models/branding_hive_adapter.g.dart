// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveBrandingAdapter extends TypeAdapter<HiveBranding> {
  @override
  final int typeId = 21;

  @override
  HiveBranding read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveBranding(
      primaryColorHex: fields[0] as String?,
      secondaryColorHex: fields[1] as String?,
      headerImageUrl: fields[2] as String?,
      themeMode: fields[3] as String?,
      logoUrl: fields[4] as String?,
      assetLogo: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveBranding obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.primaryColorHex)
      ..writeByte(1)
      ..write(obj.secondaryColorHex)
      ..writeByte(2)
      ..write(obj.headerImageUrl)
      ..writeByte(3)
      ..write(obj.themeMode)
      ..writeByte(4)
      ..write(obj.logoUrl)
      ..writeByte(5)
      ..write(obj.assetLogo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveBrandingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
