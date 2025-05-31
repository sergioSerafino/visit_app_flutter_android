// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos zu Onboarding, AsyncNotifier und Persistenz.
// Lessons Learned: onboardingStatusProvider verwaltet den Onboarding-Status persistent mit SharedPreferences. Besonderheiten: AsyncNotifier für asynchrone Logik, testbare Persistenz, klare Trennung von UI und Status. Siehe zugehörige Provider und Tests.
//
// Weitere Hinweise: Die Architektur erlaubt einfache Erweiterung um weitere Onboarding-Flags und unterstützt Clean-Architektur-Prinzipien. Siehe ADR-003 für Teststrategie und Lessons Learned.

// filepath: lib/application/providers/onboarding_status_provider.dart
// lib/application/providers/onboarding_status_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/shared_prefs_service.dart';

// 🔑 Schlüssel für SharedPreferences
const _onboardingDoneKey =
    'onboardingDone'; // Vereinheitlichung mit SharedPrefsService
const _hasCompletedStartKey = 'has_completed_start';

/// ✅ Provider für den Onboarding-Status
final onboardingStatusProvider =
    AsyncNotifierProvider<OnboardingStatusNotifier, bool>(
  OnboardingStatusNotifier.new,
);

class OnboardingStatusNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return await SharedPrefsService.isOnboardingDone();
  }

  Future<void> completeOnboarding() async {
    await SharedPrefsService.setOnboardingDone(true);
    state = const AsyncValue.data(true);
  }

  Future<void> resetOnboarding() async {
    // Optional: explizite Methode im Service ergänzen, hier direkter Zugriff
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingDoneKey);
    state = const AsyncValue.data(false);
  }
}

/// ✅ Provider für den "Start gedrückt"-Status
final hasCompletedStartProvider =
    AsyncNotifierProvider<StartStatusNotifier, bool>(StartStatusNotifier.new);

class StartStatusNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedStartKey) ?? false;
  }

  Future<void> markStartComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedStartKey, true);
    state = const AsyncValue.data(true);
  }

  Future<void> resetStart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasCompletedStartKey);
    state = const AsyncValue.data(false);
  }
}
