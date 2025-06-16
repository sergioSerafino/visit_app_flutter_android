import 'package:flutter/material.dart';

/// Zentrale Konstanten für das EpisodeDescriptionWidget
class EpisodeDescriptionWidgetConstants {
  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.only(top: 18);
  static const double fontSize = 22;
  // Die Farbe wird weiterhin dynamisch aus dem Theme bezogen
  static const TextStyle defaultStyle = TextStyle(
    fontSize: fontSize,
    // color: ... wird im Widget dynamisch gesetzt
  );
}
