// lib/domain/models/collection_meta.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'data_origin_model.dart';

part 'collection_meta_model.freezed.dart';
part 'collection_meta_model.g.dart';

@freezed
class CollectionMeta with _$CollectionMeta {
  const factory CollectionMeta({
    required DataOrigin podcastOrigin,
    required DataOrigin episodeOrigin,
    DataOrigin? hostOrigin,
  }) = _CollectionMeta;

  factory CollectionMeta.fromJson(Map<String, dynamic> json) =>
      _$CollectionMetaFromJson(json);
}
