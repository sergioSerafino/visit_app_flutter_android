import 'package:hive/hive.dart';

part 'link_hive_adapter.g.dart';

@HiveType(typeId: 25)
class HiveLink extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? url;

  HiveLink({
    this.title,
    this.url,
  });
}
