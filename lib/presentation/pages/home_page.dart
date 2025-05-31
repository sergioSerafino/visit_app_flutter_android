//
// /presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/providers/collection_provider.dart';
import '../../application/providers/podcast_provider.dart';
import '../../presentation/widgets/home_header.dart';
import '../../../presentation/pages/podcast_page.dart';
import '../../../presentation/pages/hosts_page.dart';
import '../../../presentation/pages/preferences_page.dart';
import '../../../config/app_routes.dart';
// import '../../../application/providers/data_mode_provider.dart';
// import '../../domain/enums/repository_source_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/messaging/snackbar_manager.dart';

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
        child: AppBar(
          title: Consumer(
            builder: (context, ref, _) {
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
                  error: (_) {},
                  loading: () {},
                );
              });

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: homeHeader(hostName)),
                  const SizedBox(width: 12),
                  // const CollectionInputWrapper(),
                ],
              );
            },
          ),
          actions: [
            // Dark Mode Umschalter
            // IconButton(
            //   icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            //   onPressed:
            //       widget.toggleDarkMode, // Verwendet die übergebene Funktion
            // ),
            // Dropdown-Menü
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              onSelected: (value) {
                if (value == "Einstellungen") {
                  // Wenn "Einstellungen" ausgewählt wurde, zeige das Modal Bottom Sheet
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const PreferencesBottomSheet();
                      // Deine benutzerdefinierte Widget für das Bottom Sheet
                    },
                  );
                } else if (value == "Über") {
                  // Hier kannst du eine andere Logik für "Über" implementieren, z.B. eine Dialogbox
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
                      Text("Über diese App"),
                      Spacer(),
                      Icon(Icons.arrow_back),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: "Einstellungen",
                  child: Row(
                    children: [
                      Text("Einstellungen"),
                      Spacer(),
                      Icon(Icons.menu),
                    ],
                  ),
                ),
              ],
            ),
          ],
          toolbarHeight: 90,
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.podcasts),
            label: "CastList",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "HostsView",
          ),
        ],
      ),
    );
  }
}
