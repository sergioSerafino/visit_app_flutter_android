// \lib\presentation\pages\home_page.dart
// LandingPage mit Placeholder-Daten

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empty_flutter_template/application/providers/collection_provider.dart';
import 'package:empty_flutter_template/application/providers/onboarding_status_provider.dart';
import 'package:empty_flutter_template/application/providers/podcast_provider.dart';
import 'package:empty_flutter_template/config/app_routes.dart';
import 'package:empty_flutter_template/presentation/pages/preferences_page.dart';
import 'package:empty_flutter_template/presentation/widgets/button_icon_navigation.dart';
import 'package:empty_flutter_template/presentation/widgets/cover_image_widget.dart';
import 'package:empty_flutter_template/presentation/widgets/welcome_header.dart';
import 'package:empty_flutter_template/core/messaging/snackbar_manager.dart';
import 'package:empty_flutter_template/domain/common/api_response.dart';
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
    final theme = Theme.of(context);

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

    // Zeige die Seite nur, wenn die Daten wirklich da sind
    final isReady = collectionAsync is AsyncData &&
        collectionAsync.value != null &&
        collectionAsync.value!.isSuccess;
    if (!isReady) {
      // Noch keine Daten: Zeige leeres Scaffold (keine UI, kein Flackern)
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                        padding: const EdgeInsets.only(
                            top: 24, left: 24, right: 24, bottom: 8),
                        child: welcomeHeader(dynamicHostName, context: context),
                      );
                    },
                    error: (_) => Padding(
                      padding: const EdgeInsets.only(
                          top: 24, left: 24, right: 24, bottom: 8),
                      child: welcomeHeader("dynamicHostName", context: context),
                    ),
                    loading: () => const SizedBox.shrink(), // Kein Loading mehr
                  ),
                  loading: () => const SizedBox.shrink(), // Kein Loading mehr
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.only(
                        top: 24, left: 24, right: 24, bottom: 8),
                    child: welcomeHeader("Fehler beim Laden", context: context),
                  ),
                ),
                // Cover
                const SizedBox(height: 8),
                collectionAsync.when(
                  data: (apiResponse) => apiResponse.when(
                    success: (collection) {
                      final podcast = collection.podcasts.firstOrNull;
                      return Center(
                        child: CoverImageWidget(
                          scaleFactor: 0.95,
                          showLabel: false,
                          imageUrl: podcast?.artworkUrl600 ?? "",
                        ),
                      );
                    },
                    error: (_) =>
                        const Center(child: CoverImageWidget(showLabel: true)),
                    loading: () => const SizedBox.shrink(), // Kein Loading mehr
                  ),
                  loading: () => const SizedBox.shrink(), // Kein Loading mehr
                  error: (_, __) =>
                      const Center(child: CoverImageWidget(showLabel: true)),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                    color: theme.colorScheme.primary, // Hauptfarbe für Button
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, top: 8),
                  child: Text("einer", style: theme.textTheme.bodySmall),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, top: 2),
                  child: Text(
                    "Universell Podcasten -App",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ButtonIconNavigation(
                    iconPosition: IconPosition.none,
                    sizeOfFont: 18,
                    label: "Einstellungen",
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const PreferencesBottomSheet(),
                      );
                    },
                    color: theme.colorScheme.primary, // Hauptfarbe für Button
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
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
