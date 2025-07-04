//
// /presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/providers/collection_provider.dart';
import '../../application/providers/podcast_provider.dart';
import '../../application/providers/theme_provider.dart';
import '../../core/messaging/snackbar_event.dart';
import '../widgets/home_header_material3.dart';
import 'podcast_page.dart';
import 'hosts_page.dart';
import 'preferences_page.dart';
import '../../config/app_routes.dart';
import '../../core/messaging/snackbar_manager.dart';
import '../../core/utils/scroll_shadow_controller.dart';
import '../../core/services/audio_player_bloc.dart';
import '../../application/providers/audio_player_provider.dart';
import '../../application/providers/current_episode_provider.dart';
import '../widgets/bottom_player_widget.dart';
import '../../core/placeholders/placeholder_content.dart';
import '../../domain/models/podcast_collection_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Eigene Padding-Constants für HomePage
class HomePageConstants {
  static const double headerTop = 20.0;
  static const double headerLeft = 0.0;
  static const double headerRight = 4.0;
  static const double headerBottom = 8.0;
}

class HomePage extends ConsumerStatefulWidget {
  final bool showMeWelcome;

  const HomePage({super.key, this.showMeWelcome = false});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  // Für jeden Tab ein eigener Controller
  late final ScrollShadowController _podcastScrollShadowController;
  late final ScrollShadowController _hostsScrollShadowController;

  bool _snackbarShown = false;

  @override
  void initState() {
    super.initState();
    _podcastScrollShadowController = ScrollShadowController();
    _hostsScrollShadowController = ScrollShadowController();
  }

  @override
  void dispose() {
    _podcastScrollShadowController.dispose();
    _hostsScrollShadowController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showOverlay = _selectedIndex == 0
        ? _podcastScrollShadowController.showShadow
        : _hostsScrollShadowController.showShadow;
    if (!_snackbarShown) {
      _snackbarShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final prefs = await SharedPreferences.getInstance();
        final showSnackbar =
            prefs.getBool('showOnboardingRestartedSnackbar') ?? false;
        if (showSnackbar) {
          ref
              .read(snackbarManagerProvider.notifier)
              .showByKey('onboarding_restarted');
          await prefs.remove('showOnboardingRestartedSnackbar');
        } else if (widget.showMeWelcome) {
          ref.read(snackbarManagerProvider.notifier).showByKey('welcome_back');
        }
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Consumer(
          builder: (context, ref, _) {
            final theme = ref.watch(appThemeProvider);
            final collectionId = ref.watch(collectionIdProvider);
            final collectionAsync = ref.watch(
              podcastCollectionProvider(collectionId),
            );

            String hostName =
                PlaceholderContent.podcastCollection.podcasts.first.artistName;

            // Robust: Kein whenData, sondern direkt when auf collectionAsync
            collectionAsync.when(
              data: (apiResponse) {
                apiResponse.when(
                  success: (collection) {
                    final podcast = collection.podcasts.firstOrNull;
                    if (collection.isPlaceholder) {
                      hostName = PlaceholderContent
                          .podcastCollection.podcasts.first.artistName;
                    } else if (podcast != null) {
                      hostName = podcast.artistName;
                    }
                  },
                  error: (_) {
                    hostName = PlaceholderContent
                        .podcastCollection.podcasts.first.artistName;
                  },
                  loading: () {},
                );
              },
              error: (e, st) {
                hostName = PlaceholderContent
                    .podcastCollection.podcasts.first.artistName;
              },
              loading: () {},
            );

            return AppBar(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              title: Padding(
                padding: const EdgeInsets.only(
                  top: HomePageConstants.headerTop,
                  left: HomePageConstants.headerLeft,
                  right: HomePageConstants.headerRight,
                  bottom: HomePageConstants.headerBottom,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: HomeHeaderMaterial3(
                        hostName: hostName,
                        baseColor: theme.colorScheme.primary,
                        surfaceTint: theme.colorScheme.surfaceTint,
                        overlayActive: showOverlay,
                        textColor: Colors.white,
                        height: kToolbarHeight + 30,
                        actions: null,
                        textStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // const SizedBox(width: 12),
                  ],
                ),
              ),
              actions: [
                Theme(
                  data: theme.copyWith(
                    popupMenuTheme: theme.popupMenuTheme.copyWith(
                      color: theme.colorScheme.primary,
                      textStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                    iconTheme:
                        IconThemeData(color: theme.colorScheme.onPrimary),
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onSelected: (value) {
                      if (value == "Einstellungen") {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const PreferencesBottomSheet();
                          },
                        );
                      } else if (value == "Über") {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.landingRoute,
                          arguments: {"isReturningUser": true},
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: "Light/Dark -Mode",
                        child: Row(
                          children: [
                            Text(
                              "Light/Dark -Mode",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.light_mode,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "Über",
                        child: Row(
                          children: [
                            Text(
                              "Über diese App",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "Einstellungen",
                        child: Row(
                          children: [
                            Text(
                              "Einstellungen",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              toolbarHeight: 90,
            );
          },
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PodcastPage(
              scrollController: _podcastScrollShadowController.controller),
          HostsPage(scrollController: _hostsScrollShadowController.controller),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        backgroundColor: theme.colorScheme.primary,
        selectedItemColor: Colors.white, // Labels und Icons immer weiß
        unselectedItemColor:
            Colors.white.withAlpha(70), // Unselected mit Transparenz
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        items: [
          BottomNavigationBarItem(
            icon: Consumer(
              builder: (context, ref, _) {
                final audioStateAsync = ref.watch(audioPlayerStateProvider);
                final audioState = audioStateAsync.asData?.value;
                final isPlaying = audioState is Playing;
                final isSelected = _selectedIndex == 0;
                Color? iconColor;
                if (isSelected) {
                  iconColor = Colors.white;
                } else {
                  iconColor = null; // Standardfarbe für unselected
                }
                return Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_arrow,
                  color: iconColor,
                );
              },
            ),
            label: "Podcast",
            backgroundColor: theme.colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? const Icon(Icons.person)
                : /*Transform.rotate(
                    angle: 1.5708, // 90 Grad im Bogenmaß, play_arrow
                    child: */
                const Icon(Icons.person),
            // ),
            label: "Visit",
            backgroundColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

// // Custom Widget für BottomNavigationBarLabel
// class VistTabLabel extends StatelessWidget {
//   final bool selected;
//   const VistTabLabel({required this.selected, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Transform.rotate(
//           angle: 1.5708, // 90 Grad im Bogenmaß
//           child: Icon(
//             Icons.play_arrow,
//             size: 18,
//             color: selected ? Colors.white : Colors.white.withAlpha(90),
//           ),
//         ),
//         const SizedBox(width: 2),
//         Text(
//           'isit',
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.white.withAlpha(90),
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
