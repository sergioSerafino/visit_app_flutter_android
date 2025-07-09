// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveContactInfoAdapter extends TypeAdapter<HiveContactInfo> {
  @override
  final int typeId = 20;

  @override
  HiveContactInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveContactInfo(
      email: fields[0] as String?,
      websiteUrl: fields[1] as String?,
      impressumUrl: fields[2] as String?,
      socialLinks: (fields[3] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveContactInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.websiteUrl)
      ..writeByte(2)
      ..write(obj.impressumUrl)
      ..writeByte(3)
      ..write(obj.socialLinks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveContactInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
