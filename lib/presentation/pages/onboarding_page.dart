// /presentation/pages/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/onboarding_status_provider.dart';
import '../../../config/app_routes.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildOnboardingPage(
                  'Tipp 1',
                  'Willkommen in deiner',
                  'Visit App!',
                ),
                _buildOnboardingPage(
                  'Tipp 2',
                  'Hier hast du einen Überblick und',
                  'dort kannst du gleich Inhalte abrufen.',
                ),
                _buildOnboardingPage("Los geht es ...", 'Viel Spaß!', ''),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Skip-Button direkt vor den Indikatoren, nicht als Positioned im Stack
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.landingRoute,
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Überspringen',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              // Die Indikatoren bleiben immer mittig
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index ? Colors.blue : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // Die Buttons erscheinen oben auf den Indikatoren, wenn sie sichtbar sind
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: _currentPage < 2
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    // Links der Row, den "Next"-Button anzeigen, wenn wir nicht auf der letzten Seite sind
                    if (_currentPage < 2)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                          left: 20.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                          child: const Text('Next'),
                        ),
                      ),
                    // Rechts der Row, den "Start"-Button anzeigen, wenn auf der letzten Seite
                    if (_currentPage == 2)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                          right: 20.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(onboardingStatusProvider.notifier)
                                .completeOnboarding();
                            debugPrint('🎉 onboardingDone gesetzt!');
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              //homeRoute,
                              AppRoutes.landingRoute,
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text('Start'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(String title, String description, String des2) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
          Text(description, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(des2, style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
