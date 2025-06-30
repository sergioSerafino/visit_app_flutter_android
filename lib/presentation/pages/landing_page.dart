// \lib\presentation\pages\home_page.dart
// LandingPage mit Placeholder-Daten

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/collection_provider.dart';
import '../../application/providers/onboarding_status_provider.dart';
import '../../application/providers/podcast_provider.dart';
import '../../config/app_routes.dart';
import 'preferences_page.dart';
import '../widgets/button_icon_navigation.dart';
import '../widgets/cover_image_widget.dart';
import '../widgets/welcome_header.dart';
import '../../core/messaging/snackbar_manager.dart';
import '../../domain/common/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/title_format_utils.dart';
import '../../core/utils/landing_page_constants.dart';
import '../../domain/models/podcast_collection_model.dart';
import '../../core/placeholders/placeholder_content.dart';

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

    // Prüfe auf Placeholder-Modus
    final isPlaceholder = collectionAsync.maybeWhen(
      data: (apiResponse) => apiResponse.maybeWhen(
        success: (collection) => collection.isPlaceholder,
        orElse: () => false,
      ),
      orElse: () => false,
    );

    // Zeige die Seite immer, sobald irgendein Modell (auch Placeholder) geliefert wird
    if (collectionAsync is! AsyncData || collectionAsync.value == null) {
      // Noch keine Daten: Zeige leeres Scaffold (keine UI, kein Flackern)
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Begrüßung
                collectionAsync.when(
                  data: (apiResponse) => apiResponse.when(
                    success: (collection) {
                      final podcast = collection.podcasts.firstOrNull;
                      if (collection.isPlaceholder) {
                        debugPrint('[LandingPage] Placeholder artistName: '
                            '${collection.podcasts.first.artistName}');
                      }
                      final dynamicHostName = collection.isPlaceholder
                          ? PlaceholderContent
                              .podcastCollection.podcasts.first.artistName
                          : (podcast?.collectionName ?? "Gastgeber-Format");
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: LandingPageConstants.welcomeHeaderTop,
                            left: LandingPageConstants.welcomeHeaderLeft,
                            right: LandingPageConstants.welcomeHeaderRight,
                            bottom: LandingPageConstants.welcomeHeaderBottom),
                        child: welcomeHeader(dynamicHostName, context: context),
                      );
                    },
                    error: (_) => Padding(
                      padding: const EdgeInsets.only(
                          top: LandingPageConstants.welcomeHeaderTop,
                          left: LandingPageConstants.welcomeHeaderLeft,
                          right: LandingPageConstants.welcomeHeaderRight,
                          bottom: LandingPageConstants.welcomeHeaderBottom),
                      child: welcomeHeader(
                        PlaceholderContent
                            .podcastCollection.podcasts.first.artistName,
                        context: context,
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.only(
                        top: LandingPageConstants.welcomeHeaderTop,
                        left: LandingPageConstants.welcomeHeaderLeft,
                        right: LandingPageConstants.welcomeHeaderRight,
                        bottom: LandingPageConstants.welcomeHeaderBottom),
                    child: welcomeHeader(
                      PlaceholderContent
                          .podcastCollection.podcasts.first.artistName,
                      context: context,
                    ),
                  ),
                ),
                // Cover
                const SizedBox(height: LandingPageConstants.coverSpacing),
                collectionAsync.when(
                  data: (apiResponse) => apiResponse.when(
                    success: (collection) {
                      final podcast = collection.podcasts.firstOrNull;
                      return Center(
                        child: CoverImageWidget(
                          imageUrl: podcast?.artworkUrl600 ?? "",
                        ),
                      );
                    },
                    error: (_) =>
                        const Center(child: CoverImageWidget(showLabel: true)),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) =>
                      const Center(child: CoverImageWidget(showLabel: true)),
                ),
                const SizedBox(height: LandingPageConstants.buttonSpacing),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: LandingPageConstants.buttonHorizontal),
                  child: ButtonIconNavigation(
                    iconPosition: IconPosition.right,
                    sizeOfFont: LandingPageConstants.startButtonFontSize,
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
                const SizedBox(height: LandingPageConstants.titleSpacing),
                Padding(
                  padding: const EdgeInsets.only(
                      left: LandingPageConstants.textLeft,
                      top: LandingPageConstants.textTop),
                  child: Text("einer", style: theme.textTheme.bodySmall),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: LandingPageConstants.textLeft,
                      top: LandingPageConstants.textTopSmall),
                  child: Text(
                    "Universell Podcasten -App",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: LandingPageConstants.endSpacing),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: LandingPageConstants.buttonHorizontal),
                  child: ButtonIconNavigation(
                    iconPosition: IconPosition.none,
                    sizeOfFont: LandingPageConstants.settingsButtonFontSize,
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
                const SizedBox(height: LandingPageConstants.buttonSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTitleByDelimiter(String title, String delimiter) {
    // Delegiert an Utility-Klasse
    return TitleFormatUtils.formatTitleByDelimiter(title, delimiter);
  }
}
