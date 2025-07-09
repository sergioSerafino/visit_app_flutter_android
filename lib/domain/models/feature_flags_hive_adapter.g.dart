// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flags_hive_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveFeatureFlagsAdapter extends TypeAdapter<HiveFeatureFlags> {
  @override
  final int typeId = 22;

  @override
  HiveFeatureFlags read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveFeatureFlags(
      showPortfolioTab: fields[0] as bool?,
      enableContactForm: fields[1] as bool?,
      showPodcastGenre: fields[2] as bool?,
      customStartTab: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveFeatureFlags obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.showPortfolioTab)
      ..writeByte(1)
      ..write(obj.enableContactForm)
      ..writeByte(2)
      ..write(obj.showPodcastGenre)
      ..writeByte(3)
      ..write(obj.customStartTab);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveFeatureFlagsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
