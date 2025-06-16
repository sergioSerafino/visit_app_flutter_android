// /presentation/pages/splash_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/onboarding_status_provider.dart';
import '../widgets/splash_cover_image.dart';
import 'onboarding_page.dart';
import 'home_page.dart';
import 'landing_page.dart';
import '../../core/utils/tenant_asset_loader.dart';
import '../../application/providers/collection_provider.dart';
import '../../application/providers/podcast_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/splash_constants.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  // Start-Deckkraft
  double _opacity = SplashConstants.initialOpacity;

  @override
  void initState() {
    super.initState();
    _checkOnboardingRestartedSnackbar();
    Future.delayed(SplashConstants.splashDelay, () async {
      setState(() => _opacity = SplashConstants.finalOpacity);
      await Future.delayed(SplashConstants.fadeOutWait);

      final onboardingAsync = await ref.read(onboardingStatusProvider.future);
      final hasCompletedStartAsync = await ref.read(
        hasCompletedStartProvider.future,
      );

      log('🟡 onboardingDone: $onboardingAsync');
      log('🟢 hasCompletedStart: $hasCompletedStartAsync');

      late final Widget target;

      if (!onboardingAsync) {
        debugPrint('➡️ Zeige OnboardingPage');
        target = const OnboardingPage();
      } else if (!hasCompletedStartAsync) {
        debugPrint('➡️ Zeige LandingPage');
        // Warte, bis die PodcastCollection geladen ist, bevor LandingPage angezeigt wird
        final collectionId = ref.read(collectionIdProvider);
        try {
          await ref.read(podcastCollectionProvider(collectionId).future);
        } catch (_) {}
        target = const LandingPage();
      } else {
        debugPrint('✅ Direkt zur HomePage');
        target = const HomePage(showMeWelcome: true);
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: SplashConstants.fadeTransitionDuration,
          pageBuilder: (context, animation, _) {
            return FadeTransition(opacity: animation, child: target);
          },
        ),
      );
    });
  }

  Future<void> _checkOnboardingRestartedSnackbar() async {
    // Flag-Logik bleibt, aber keine Snackbar-Anzeige mehr hier
    final prefs = await SharedPreferences.getInstance();
    final showSnackbar =
        prefs.getBool('showOnboardingRestartedSnackbar') ?? false;
    if (showSnackbar) {
      // Flag bleibt gesetzt für die Zielseite
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionId = ref.watch(collectionIdProvider);
    // Dynamischer Fallback-Asset-Pfad
    final loader = TenantAssetLoader(collectionId);
    final fallbackLogo = loader.imagePath();

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        // animiert von 1.0 → 0.0
        opacity: _opacity,
        // lange Fadeout-Dauer (5s)
        duration: SplashConstants.fadeOutDuration,
        child: Stack(
          children: [
            // Bild zentriert
            Align(
              child: SizedBox(
                width: SplashConstants.imageSize,
                height: SplashConstants.imageSize,
                child: SplashCoverImage(
                  showLabel: true,
                  assetPath: fallbackLogo,
                  // Skalierung des Bildes
                  scaleFactor: 0.7,
                ),
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
