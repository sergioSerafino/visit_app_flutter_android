import 'package:flutter/material.dart';

/// Zentrale Konstanten für das StickyInfoHeader-Widget
class StickyInfoHeaderConstants {
  static const double baseHeight = 20;
  static const double maxExtraHeight = 20;
  static const EdgeInsetsGeometry horizontalPadding = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsetsGeometry rowPadding = EdgeInsets.fromLTRB(0, 4, 0, 0);
  static const TextStyle releaseDateStyle = TextStyle(
    fontSize: 14,
    // Farbe wird dynamisch gesetzt
  );
  static const TextStyle durationStyle = TextStyle(
    fontSize: 22,
    // Farbe wird dynamisch gesetzt
  );
  static const Color dividerColor = Colors.transparent;
  static const double dividerThickness = 2;
  static const double dividerHeight = 4;
}
