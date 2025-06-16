import 'package:flutter/material.dart';

/// Zentrale Konstanten für das BottomPlayerWidget
class BottomPlayerWidgetConstants {
  static const List<double> speedOptions = [0.5, 1.0, 1.5, 2.0];
  static const double playerHeight = 80.0;
  static const double buttonSize = 36.0;
  static const double progressBarHeight = 4.0;
  static const EdgeInsetsGeometry playerPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const EdgeInsets safeAreaMin =
      EdgeInsets.symmetric(horizontal: 12, vertical: 30);
  static const double containerBorderRadius = 16.0;
  static const double overlayBorderRadius = 12.0;
  static const double overlayElevation = 8.0;
  static const double overlayWidth = 72.0;
  static const double overlayHeight = 240.0;
  static const double overlayThumbRadius = buttonSize / 2;
  static const double overlayTrackHeight = progressBarHeight;
  static const double boxShadowBlur = 4.0;
  static const int boxShadowAlpha = 65;
  // Farben und weitere Styles können bei Bedarf ergänzt werden
}
