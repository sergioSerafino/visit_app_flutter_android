//
// /presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/providers/collection_provider.dart';
import '../../application/providers/podcast_provider.dart';
import '../../application/providers/theme_provider.dart';
import '../widgets/home_header.dart';
import 'podcast_page.dart';
import 'hosts_page.dart';
import 'preferences_page.dart';
import '../../config/app_routes.dart';
import '../../core/messaging/snackbar_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  final bool showMeWelcome;

  const HomePage({super.key, this.showMeWelcome = false});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const PodcastPage(), const HostsPage()];

  bool _snackbarShown = false;
  @override
  void initState() {
    super.initState();
    // _checkOnboardingRestartedSnackbar();
    // if (widget.showMeWelcome) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Future.delayed(const Duration(milliseconds: 1500), () {
    //       ref.read(snackbarManagerProvider.notifier).showByKey('welcome_back');
    //     });
    //   });
    // }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        preferredSize: const Size.fromHeight(90), // <- konstante Höhe!
        child: Consumer(
          builder: (context, ref, _) {
            final theme = ref.watch(appThemeProvider);
            final collectionId = ref.watch(collectionIdProvider);
            final collectionAsync = ref.watch(
              podcastCollectionProvider(collectionId),
            );

            String hostName = "artistName"; //"collectionName";

            collectionAsync.whenData((apiResponse) {
              apiResponse.when(
                success: (collection) {
                  final podcast = collection.podcasts.firstOrNull;
                  if (podcast != null) {
                    hostName = podcast.artistName; //collectionName;
                  }
                },
                error: (_) {
                  hostName = "Fehler beim Laden";
                },
                loading: () {
                  hostName = "Lädt...";
                },
              );
            });

            return AppBar(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: homeHeader(
                    hostName,
                    textColor: Colors.white,
                    backgroundColor: theme.colorScheme.primary,
                  )),
                  const SizedBox(width: 12),
                  // const CollectionInputWrapper(),
                ],
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
                        debugPrint("Über diese App");
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: "Über",
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
                    ],
                  ),
                ),
              ],
              toolbarHeight: 90,
            );
          },
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final theme = ref.watch(appThemeProvider);
          return BottomNavigationBar(
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
                icon: const Icon(
                  Icons.podcasts,
                  //color: Colors.white, // Icon immer weiß
                ),
                label: "CastList",
                backgroundColor: theme.colorScheme.primary,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.person_outline,
                  //color: Colors.white, // Icon immer weiß
                ),
                label: "HostsView",
                backgroundColor: theme.colorScheme.primary,
              ),
            ],
          );
        },
      ),
    );
  }
}
