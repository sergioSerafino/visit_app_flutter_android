import 'package:flutter/material.dart';

/// Zentrale Konstanten für das EpisodeItemTile-Widget
class EpisodeItemTileConstants {
  static const EdgeInsetsGeometry padding = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 14.0,
  );
  static const double coverSize = 85;
  static const double iconSize = 32;
  static const double placeholderIconSize = 50;
  static const TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 14,
  );
  static const TextStyle durationStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
}
