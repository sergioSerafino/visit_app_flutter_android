//
// /presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/providers/collection_provider.dart';
import '../../application/providers/podcast_provider.dart';
import '../../application/providers/theme_provider.dart';
import '../../application/providers/overlay_header_provider.dart';
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
  bool _snackbarShown = false;

  @override
  void initState() {
    super.initState();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Overlay-Status beim Tabwechsel zurücksetzen, wenn Tab keinen Overlay benötigt
    if (index == 0 /* PodcastPage */) {
      ref.read(overlayHeaderProvider.notifier).setOverlay(false);
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String hostName,
      Color? backgroundColor, Color? foregroundColor, bool overlayActive) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: AppBar(
        backgroundColor: overlayActive
            ? (Theme.of(context).brightness == Brightness.dark
                ? ElevationOverlay.applyOverlay(context, backgroundColor!, 4)
                : Color.alphaBlend(
                    const Color.fromARGB(46, 0, 0, 0), backgroundColor!))
            : backgroundColor,
        foregroundColor: foregroundColor,
        title: homeHeader(
          hostName,
          textColor: Colors.white,
          backgroundColor: overlayActive
              ? (Theme.of(context).brightness == Brightness.dark
                  ? ElevationOverlay.applyOverlay(context, backgroundColor!, 4)
                  : Color.alphaBlend(
                      const Color.fromARGB(46, 0, 0, 0), backgroundColor!))
              : backgroundColor,
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: Theme.of(context).popupMenuTheme.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
              iconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overlayActive = ref.watch(overlayHeaderProvider);
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

    final host = ref.watch(hostModelProvider);
    final backgroundColor = host.branding.primaryColorHex != null
        ? Color(
            int.parse(host.branding.primaryColorHex!.replaceFirst('#', '0xff')))
        : Theme.of(context).colorScheme.primary;
    final foregroundColor = host.branding.secondaryColorHex != null
        ? Color(int.parse(
            host.branding.secondaryColorHex!.replaceFirst('#', '0xff')))
        : Theme.of(context).colorScheme.onPrimary;
    return Scaffold(
      appBar: _buildAppBar(
          context, hostName, backgroundColor, foregroundColor, overlayActive),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const PodcastPage(),
          const HostsPage(),
        ],
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final theme = ref.watch(appThemeProvider);
          final Color baseColor = theme.colorScheme.primary;
          // Flutter-konform: BottomBar immer Basisfarbe, kein Overlay beim Scrollen
          final Color barColor = baseColor;
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTabSelected,
            backgroundColor: barColor,
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
