//  \lib\domain\models\link_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_model.freezed.dart';
part 'link_model.g.dart';

@freezed
class Link with _$Link {
  const factory Link({required String title, required String url}) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}
