// lib/domain/models/data_origin.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/data_source_type.dart'; // Aktualisierte Enum verwenden

part 'data_origin_model.freezed.dart';
part 'data_origin_model.g.dart';

@freezed
class DataOrigin with _$DataOrigin {
  const factory DataOrigin({
    required DataSourceType source, // Geänderte Enum verwenden
    required String updatedAt, // ISO8601
    required bool isFallback,
  }) = _DataOrigin;

  factory DataOrigin.fromJson(Map<String, dynamic> json) =>
      _$DataOriginFromJson(json);
}
