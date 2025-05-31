// config/app_routes.dart
//

import 'package:flutter/material.dart';
import '../../presentation/pages/snackbar_debug_page.dart';
import '../../presentation/pages/episode_detail_page.dart';
import '../../presentation/pages/launch_screen.dart';
import '../core/logging/logger_config.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/onboarding_page.dart';
import '../../presentation/pages/landing_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/preferences_page.dart';

class AppRoutes {
  static const String launchRoute = '/';
  static const String splashRoute = '/splash_page/';
  static const String onboardingRoute = '/onboarding_page/';
  static const String landingRoute = 'landing_page/';
  static const String homeRoute = 'home_page/';
  static const String preferencesRoute = '/preferences_page/';
  static const String detailRoute = '/detail_page/';
  static const String hostsView = '/hosts_page/';
  static const String snackTest = '/snackbar_test';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    logDebug(
      'Navigating to ${settings.name}',
      color: LogColor.blue,
      tag: LogTag.navigation,
    );

    switch (settings.name) {
      case launchRoute:
        return MaterialPageRoute(builder: (_) => const LaunchScreen());
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case landingRoute:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case preferencesRoute:
        return MaterialPageRoute(
            builder: (_) => const PreferencesBottomSheet());
      case detailRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EpisodeDetailPage(
            episode: args?['episode'],
            trackName: args?['trackName'],
          ),
        );
      case hostsView:
        // TODO: Implementiere HostsView
        return MaterialPageRoute(builder: (_) => const HomePage());
      case snackTest:
        return MaterialPageRoute(builder: (_) => const SnackbarDebugPage());
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
