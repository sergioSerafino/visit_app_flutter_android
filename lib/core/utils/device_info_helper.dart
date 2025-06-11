// lib/core/utils/device_info_helper.dart
import 'package:flutter/material.dart';

/// Hilfsklasse für responsive Layouts und Geräteinfos
class DeviceInfoHelper {
  final BuildContext context;
  DeviceInfoHelper(this.context);

  Size get size => MediaQuery.of(context).size;
  double get width => size.width;
  double get height => size.height;
  double get pixelRatio => MediaQuery.of(context).devicePixelRatio;
  Orientation get orientation => MediaQuery.of(context).orientation;
  EdgeInsets get safePadding => MediaQuery.of(context).padding;

  /// Beispiel-Breakpoints
  bool get isTablet => width >= 600;
  bool get isPhone => width < 600;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;

  /// Responsive Wert (z. B. für Padding, FontSize)
  double scale(double value) =>
      value * width / 375.0; // 375 = Referenzbreite iPhone 11
}
