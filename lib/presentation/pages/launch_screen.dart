// lib/presentation/pages/launch_screen.dart

import 'package:flutter/material.dart';
import '/../../presentation/pages/splash_page.dart';
import '../widgets/splash_cover_image.dart';
import '../../core/utils/launch_screen_constants.dart';
import '../../core/utils/launch_screen_text_constants.dart';

// import '../widgets/loading_dots.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with SingleTickerProviderStateMixin {
  // Hinweis (04.06.2025):
  // Das dynamische Branding wird bewusst erst ab SplashPage geladen und angewendet.
  // Die LaunchScreen bleibt neutral (weiß, Platzhalter-Logo), um Ladeflackern zu vermeiden.
  static const fallbackLogo = LaunchScreenConstants.fallbackLogo;

  // steuert die Animation
  late AnimationController _controller;
  // entählt einzelne Buchstaben-Animationen
  late List<Animation<double>> _animations;
  // Text der animiert wird und Durchlaufzyklen
  final String loadingText = LaunchScreenConstants.loadingText;
  final int animationCycles = LaunchScreenConstants.animationCycles;

  // Zähler abgeshlossener Durchlaufzyklen
  int currentCycle = 0;
  // Sichtbarkeit des Bildschirm
  double _opacity = 1.0;
  bool _showLoadingText = false;

  // AnimationController, Textanimation, Listener
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: LaunchScreenConstants.animationDuration,
      vsync: this,
      // Startet sofort beim Öffnen:
    )..forward();

    // Textanimation vorbereiten
    _animations = List.generate(loadingText.length, (index) {
      double start = index / loadingText.length;
      double end = (start + 0.5).clamp(0.0, 1.0);
      return TweenSequence([
        // nach unten
        TweenSequenceItem(tween: Tween<double>(begin: 0, end: 6), weight: 10),
        // nach oben
        TweenSequenceItem(tween: Tween<double>(begin: 6, end: -6), weight: 10),
        // zurück
        TweenSequenceItem(tween: Tween<double>(begin: -6, end: 0), weight: 10),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    // sobald eine eine Animation abgeschlossen ist:
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        currentCycle++;
        if (currentCycle >= animationCycles) {
          // wenn genug Wiederholungen -> weiter
          _fadeOutAndNavigate();
        } else {
          _controller.reset();
          _controller.forward();
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _showLoadingText = true);
    });
  }

  // Fade-Out einleiten und zur SplashPage navigieren
  void _fadeOutAndNavigate() {
    setState(() => _opacity = 0.0); // Startet die Fade-Out Animation

    Future.delayed(LaunchScreenConstants.fadeOutDuration, () {
      // Wartezeit für den Fade-Out
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: LaunchScreenConstants.transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
                opacity: animation, child: const SplashPage());
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Berechnung der Größen auf Basis der Bildschirmgröße
    // final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;

    // Fester neutraler Hintergrund, unabhängig vom Branding
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'splashImage',
                child: SizedBox(
                  width: LaunchScreenConstants.imageSize,
                  height: LaunchScreenConstants.imageSize,
                  child: SplashCoverImage(
                    showLabel: true,
                    assetPath: fallbackLogo,
                    scaleFactor: 1.0,
                    forceAssetPath: true,
                  ),
                ),
              ),
              const SizedBox(height: LaunchScreenTextConstants.textTopOffset),
              AnimatedOpacity(
                opacity: _showLoadingText ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(loadingText.length, (index) {
                    return AnimatedBuilder(
                      animation: _animations[index],
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _animations[index].value),
                          child: Text(
                            loadingText[index],
                            style: const TextStyle(
                              fontSize: LaunchScreenTextConstants.fontSize,
                              fontWeight: LaunchScreenTextConstants.fontWeight,
                              color: LaunchScreenTextConstants.textColor,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Spacer(),
//             SplashCoverImage(assetPath: fallbackLogo, scaleFactor: 0.3),
//             SizedBox(height: 32),
//             // LoadingDots(color: Colors.white),
//             Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }

/*
SplashCoverImage(
  imageUrl: host.branding.logoUrl,
  assetPath: "assets/placeholder/logo.png",
),
*/
