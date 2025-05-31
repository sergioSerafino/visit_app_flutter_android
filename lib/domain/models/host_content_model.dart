// \lib\domain\models\host_content_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/link_model.dart';

part 'host_content_model.freezed.dart';
part 'host_content_model.g.dart';

@freezed
class HostContent with _$HostContent {
  const factory HostContent({
    String? bio,
    String? mission,
    String? rss, // feedUrl aus RSS
    List<Link>? links, // manuelle Links z. B. "Spenden", "Website"
  }) = _HostContent;

  factory HostContent.fromJson(Map<String, dynamic> json) =>
      _$HostContentFromJson(json);

  static HostContent empty() {
    return const HostContent(bio: null, mission: null, rss: null, links: []);
  }
}
