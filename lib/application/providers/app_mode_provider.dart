// lib/application/providers/app_mode_providers.dart
// zum Steuern der gesamten App-Logik beim Start
//   für RouterGuard: wohin soll initial navigiert werden?
//   für Feature-Flags: z. B. Splash, Tabs, Debug etc.
//   für die Auswahl: API, Mock, Offline etc.
//   für bessere Logs, Traces, QA und Dev-Flows
//
// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu AppMode, Feature-Flags und Betriebsarten.
// Lessons Learned: appModeProvider steuert die Betriebsart der App (z. B. Demo, Dev, Staging) und ermöglicht flexible Feature-Flag-Logik. Besonderheiten: Einfache Umschaltung, testbare Betriebsarten, zentrale Steuerung für QA/Dev. Siehe zugehörige Provider und Tests.
// Weitere Hinweise: Die Architektur erlaubt einfache Erweiterung um weitere Modi und unterstützt Clean-Architektur-Prinzipien. Siehe ADR-003 für Teststrategie und Lessons Learned.

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum zur Beschreibung der aktuellen Betriebsart der App
enum AppMode {
  production,
  demo, // später placeholder zu demo ändern
  development,
  onboarding,
  placeholder,
  staging,
}

/// StateProvider für die aktuelle AppMode-Konfiguration
final appModeProvider = StateProvider<AppMode>((ref) {
  // Initial kann über `env.dart` oder collectionId gesetzt werden
  return AppMode.development;
});

/// Helper – ist Demo-Modus aktiv?
final isDemoModeProvider = Provider<bool>((ref) {
  return ref.watch(appModeProvider) == AppMode.demo;
});

/// Helper – ist App im Onboarding?
final isInOnboardingProvider = Provider<bool>((ref) {
  return ref.watch(appModeProvider) == AppMode.onboarding;
});

/*

// Beispielnutzung

final appMode = ref.watch(appModeProvider);
if (appMode == AppMode.maintenance) {
  return const MaintenancePage();
}

if (appMode == AppMode.onboarding) {
  return const OnboardingPage();
}

// Oder in deiner Splash/Launch-Logik:

switch (ref.watch(appModeProvider)) {
  case AppMode.production:
  case AppMode.demo:
    return const HomePage();
  case AppMode.onboarding:
    return const OnboardingPage();
  default:
    return const SplashPage();
}

*/
