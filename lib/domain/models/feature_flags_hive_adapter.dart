import 'package:hive/hive.dart';

part 'feature_flags_hive_adapter.g.dart';

@HiveType(typeId: 22)
class HiveFeatureFlags extends HiveObject {
  @HiveField(0)
  bool? showPortfolioTab;
  @HiveField(1)
  bool? enableContactForm;
  @HiveField(2)
  bool? showPodcastGenre;
  @HiveField(3)
  String? customStartTab;

  HiveFeatureFlags({
    this.showPortfolioTab,
    this.enableContactForm,
    this.showPodcastGenre,
    this.customStartTab,
  });
}
