// lib/application/providers/theme_provider.dart
// Riverpod/Provider zur Laufzeitumschaltung
// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Theme- und Branding-Strategie.
// Lessons Learned: Dynamisches Branding, Theme-Provider und StateNotifier-Pattern für flexible UI-Anpassung.
// Hinweise: Siehe auch app_theme_mapper.dart und branding_model.dart für Mapping und Datenstruktur.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_theme_mapper.dart';
import '../../domain/models/branding_model.dart';
import '../../config/tenant_branding_service.dart';
import 'collection_provider.dart';

// final brandingProvider = StateProvider<Branding?>((ref) => null);

/// Notifier zur Verwaltung des aktuellen Brandings
class BrandingNotifier extends StateNotifier<Branding> {
  BrandingNotifier(Ref ref)
      : super(
          TenantBrandingService(ref.read(collectionIdProvider))
              .defaultBranding(),
        );

  /// Optionale Methode, um Branding manuell zu ändern
  void setBranding(Branding newBranding) {
    debugPrint('[DEBUG] BrandingNotifier.setBranding: $newBranding');
    state = newBranding;
  }

  /// Optional: Branding zurücksetzen
  void reset(Ref ref) {
    final defaultBranding =
        TenantBrandingService(ref.read(collectionIdProvider)).defaultBranding();
    state = defaultBranding;
  }
}

/// Provider für Branding als StateNotifier
final brandingProvider = StateNotifierProvider<BrandingNotifier, Branding>(
  (
    ref,
  ) {
    return BrandingNotifier(ref);
  },
);

/// ThemeData basierend auf dem aktuellen Branding
final appThemeProvider = Provider<ThemeData>((ref) {
  final branding = ref.watch(brandingProvider);
  return AppThemeMapper.fromBranding(branding);
});

/// ThemeMode basierend auf dem aktuellen Branding
final themeModeProvider = Provider<ThemeMode>((ref) {
  final branding = ref.watch(brandingProvider);
  return AppThemeMapper.toThemeMode(branding.themeMode);
});
