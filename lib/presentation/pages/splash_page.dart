// /presentation/pages/splash_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/onboarding_status_provider.dart';
import '../../presentation/widgets/splash_cover_image.dart';
import '../../presentation/pages/onboarding_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../application/providers/theme_provider.dart' as theme_prov;
import '../../core/utils/tenant_asset_loader.dart';
import '../../application/providers/collection_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  // Start-Deckkraft
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _checkOnboardingRestartedSnackbar();
    Future.delayed(const Duration(milliseconds: 4000), () async {
      setState(() => _opacity = 0.0);
      await Future.delayed(const Duration(milliseconds: 500));

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
        target = const LandingPage();
      } else {
        debugPrint('✅ Direkt zur HomePage');
        target = const HomePage(showMeWelcome: true);
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1500),
          pageBuilder: (context, animation, _) {
            // if (onboardingAsync) {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {});
            // }
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
//  final theme = ref.watch(theme_prov.appThemeProvider);

    // Größe des Splash-Bildes
    const double imageSize = 300;
    // Dynamischer Fallback-Asset-Pfad
    final loader = TenantAssetLoader(collectionId);
    final fallbackLogo = loader.imagePath();

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        // animiert von 1.0 → 0.0
        opacity: _opacity,
        // lange Fadeout-Dauer (5s)
        duration: const Duration(milliseconds: 5000),
        child: Stack(
          children: [
            // Bild zentriert
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: imageSize,
                height: imageSize,
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
