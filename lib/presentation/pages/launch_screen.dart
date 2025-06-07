// lib/presentation/pages/launch_screen.dart

import 'package:flutter/material.dart';
import '/../../presentation/pages/splash_page.dart';
import '../widgets/splash_cover_image.dart';

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
  // Das frühere TODO ist damit obsolet und wurde entfernt.
  static final fallbackLogo = "lib/tenants/common/assets/visit22.png";
  // static final primaryColor = const Color(0x99FFFFFF); // z. B. aus theme.dart (nicht genutzt)

  // steuert die Animation
  late AnimationController _controller;
  // entählt einzelne Buchstaben-Animationen
  late List<Animation<double>> _animations;
  // Text der animiert wird und Durchlaufzyklen
  final String loadingText = "   Wird gestartet . . .";
  final int animationCycles = 2;

  // Zähler abgeshlossener Durchlaufzyklen
  int currentCycle = 0;
  // Sichtbarkeit des Bildschirm
  double _opacity = 1.0;

  // AnimationController, Textanimation, Listener
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
  }

  // Fade-Out einleiten und zur SplashPage navigieren
  void _fadeOutAndNavigate() {
    setState(() => _opacity = 0.0); // Startet die Fade-Out Animation

    Future.delayed(const Duration(milliseconds: 500), () {
      // Wartezeit für den Fade-Out
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration:
              const Duration(milliseconds: 500), // Sanfte Transition
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    const double imageSize = 275;
    final double imageTop = screenHeight / 2 - imageSize / 2;
    final double textTop = imageTop + imageSize + 40;
    final double textLeft = screenWidth * 0.25;

    // Fester neutraler Hintergrund, unabhängig vom Branding
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 0),
        child: Stack(
          children: [
            // Hero-Splashbild zentriert
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: 'splashImage',
                child: SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: SplashCoverImage(
                    showLabel: true,
                    assetPath: fallbackLogo,
                    scaleFactor: 1.0,
                    forceAssetPath: true,
                  ),
                ),
              ),
            ),

            // Bounce-Loading-Text
            Positioned(
              top: textTop,
              left: textLeft,
              child: Row(
                children: List.generate(loadingText.length, (index) {
                  return AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _animations[index].value),
                        child: Text(
                          loadingText[index],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.grey, // Dezentes Grau für bessere Optik
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
