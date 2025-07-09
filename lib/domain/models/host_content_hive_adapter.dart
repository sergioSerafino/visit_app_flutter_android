import 'package:hive/hive.dart';
import 'link_hive_adapter.dart';

part 'host_content_hive_adapter.g.dart';

@HiveType(typeId: 24)
class HiveHostContent extends HiveObject {
  @HiveField(0)
  String? bio;
  @HiveField(1)
  String? mission;
  @HiveField(2)
  String? rss;
  @HiveField(3)
  List<HiveLink>? links;

  HiveHostContent({
    this.bio,
    this.mission,
    this.rss,
    this.links,
  });
}
