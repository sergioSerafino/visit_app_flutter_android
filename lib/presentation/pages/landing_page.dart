// \lib\presentation\pages\home_page.dart
// LandingPage mit Placeholder-Daten

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/collection_provider.dart';
import '../../application/providers/onboarding_status_provider.dart';
import '../../application/providers/podcast_provider.dart';
import '../../config/app_routes.dart';
import '../../presentation/pages/preferences_page.dart';
import '../../presentation/widgets/button_icon_navigation.dart';
import '../../presentation/widgets/cover_image_widget.dart';
import '../../presentation/widgets/welcome_header.dart';
import '../../core/messaging/snackbar_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  bool _snackbarShown = false;

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
        }
        // Snackbar mit aktueller Collection-ID anzeigen
        final collectionId = ref.read(collectionIdProvider);
        ref.read(snackbarManagerProvider.notifier).showByKey(
          'collection_id_info',
          args: {'id': collectionId.toString()},
        );
      });
    }

    final collectionId = ref.watch(collectionIdProvider);
    final collectionAsync = ref.watch(podcastCollectionProvider(collectionId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Begrüßung
            collectionAsync.when(
              data: (apiResponse) => apiResponse.when(
                success: (collection) {
                  final podcast = collection.podcasts.firstOrNull;
                  final dynamicHostName =
                      podcast?.collectionName ?? "Gastgeber-Format";

                  return Padding(
                    padding: const EdgeInsets.only(top: 0, left: 16.0),
                    child: welcomeHeader(dynamicHostName, context: context),
                  );
                },
                error: (_) => Padding(
                  padding: const EdgeInsets.only(top: 0, left: 16.0),
                  child: welcomeHeader("dynamicHostName", context: context),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 0, left: 16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 0, left: 16.0),
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => Padding(
                padding: const EdgeInsets.only(top: 0, left: 16.0),
                child: welcomeHeader("Fehler beim Laden", context: context),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 0, left: 16.0),
            //   child: welcomeHeader(host.hostName),
            // ),
            const SizedBox(height: 20),

            /// 🟦 Cover Platzhalter
            // CoverImageWidget(
            //   scaleFactor: 0.95,
            //   showLabel: false,
            //   imageUrl: host.branding.logoUrl,
            // ),
            // const SizedBox(height: 30),
            collectionAsync.when(
              data: (apiResponse) => apiResponse.when(
                success: (collection) {
                  final podcast = collection.podcasts.firstOrNull;
                  return CoverImageWidget(
                    scaleFactor: 0.95,
                    showLabel: false,
                    imageUrl: podcast?.artworkUrl600 ?? "",
                  );
                },
                error: (_) => const CoverImageWidget(showLabel: true),
                loading: () => const CircularProgressIndicator(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const CoverImageWidget(showLabel: true),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ButtonIconNavigation(
                iconPosition: IconPosition.right,
                sizeOfFont: 28,
                label: "Starten",
                icon: Icons.play_arrow,
                onPressed: () {
                  ref
                      .read(hasCompletedStartProvider.notifier)
                      .markStartComplete();
                  debugPrint('🚀 hasCompletedStart gesetzt!');
                  Navigator.of(context).pushAndRemoveUntil(
                    AppRoutes.generateRoute(
                      const RouteSettings(name: AppRoutes.homeRoute),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.only(top: 12, left: 12.0),
              child: Text("einer", style: TextStyle(fontSize: 14)),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                "Universell Podcasten -App",
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ButtonIconNavigation(
                iconPosition: IconPosition.none,
                sizeOfFont: 18,
                label: "Einstellungen",
                // color: const Color(0xFFCCDD),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // optional
                    builder: (context) => const PreferencesBottomSheet(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTitleByDelimiter(String title, String delimiter) {
    final parts = title.split(delimiter);
    if (parts.length > 1) {
      return '${parts[0]}$delimiter\n${parts.sublist(1).join(delimiter).trim()}';
    }
    return title;
  }
}
