// lib/core/storage/shared_prefs_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _onboardingDoneKey = 'onboardingDone';

  static Future<void> setOnboardingDone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingDoneKey, value);
  }

  static Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingDoneKey) ?? false;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
