// Migration aus storage_hold, Stand 30.05.2025
// Logging-Tools
// import 'dart:developer' as developer;
import 'package:flutter/material.dart'
    show debugPrint, Color, Colors, ColorScheme;
import 'package:intl/intl.dart';

const bool enableDebugLogging = bool.fromEnvironment(
  "enableLogDebug",
  defaultValue: true,
);

// Weitere Logging-Utilities, LogTag, LogColor, logDebug etc. folgen hier, vollständiger Inhalt aus storage_hold übernehmen

/*
Schritt für Schritt debuggen:
-> konkret  State, Mode, Provider und UI

So nutzt du es jetzt in deiner App (Symbole für CRUD 💾✍️🗑️,↔️🔚🔜🛣️)


📡 API-Client Logging
logDebug("➡️ Starte API-Request: getPodcastCollection()",
    tag: LogTag.api, color: LogColor.cyan);

  Nach der Antwort
logDebug("✅ API-Response erhalten: ${response.podcasts.length} Podcasts",
    tag: LogTag.api, color: LogColor.green);

  Bei Fehler
logDebug("❌ API-Fehler: $error",
    tag: LogTag.api, color: LogColor.red);



🗃️ Repository Logging
logDebug("📥 fetchPodcastCollection() im Repository gestartet",
    tag: LogTag.data, color: LogColor.yellow);

  Beim Cache-Zugriff
logDebug("🧠 Versuche PodcastCollection aus Cache zu laden...",
    tag: LogTag.data, color: LogColor.white);

  Bei erfolgreicher Speicherung
logDebug("💾 PodcastCollection erfolgreich im Cache gespeichert",
    tag: LogTag.data, color: LogColor.green);



🧠 Cache/Storage Logging
logDebug("🔎 Suche nach Cache-Einträgen für collectionId: $id",
    tag: LogTag.data, color: LogColor.cyan);

  Wenn gefunden:
logDebug("📦 Episoden aus Cache geladen (count: ${episodes.length})",
    tag: LogTag.data, color: LogColor.green);

  Wenn leer:
logDebug("🚫 Kein Cache-Eintrag gefunden!",
    tag: LogTag.data, color: LogColor.red);



🧩 UI Logging
logDebug("🖼️ HandlingPage aufgebaut – aktiver Modus: ${_isApiMode ? "API" : "Mock"}",
    tag: LogTag.ui, color: LogColor.blue);

logDebug("🧾 Collection geladen mit ${_podcastResponse?.data?.podcasts.length ?? 0} Podcasts",
    tag: LogTag.ui, color: LogColor.green);

logDebug("📃 Episodenanzeige gestartet (count: ${_episodeResponse?.data?.length ?? 0})",
    tag: LogTag.ui, color: LogColor.white);



⚠️ Fehlerhandling
logDebug("🚨 Fehler im Prozess XYZ: $error",
    tag: LogTag.error, color: LogColor.red);




🧪 Temporäre Marker für Debugging
logDebug("🔥 CHECKPOINT A erreicht", tag: LogTag.debug, color: LogColor.magenta);
logDebug("🧵 Datenstand: $_episodeResponse", tag: LogTag.debug, color: LogColor.cyan);

*/

// Farb-Enum für logDebug
enum LogColor {
  red, // Fehler oder Warnungen
  green, // Erfolgreiche Aktionen
  yellow, // Wichtige Hinweise
  blue, // Navigation
  magenta, // Benutzeraktionen
  cyan, // Debug-Informationen
  white, // Standardausgabe
}

// Tag-Enum für logDebug (passend zur Projektstruktur
enum LogTag {
  navigation, // Navigation & Routen
  api, // API-Calls & Services
  auth, // Authentifizierung
  ui, // UI-Interaktionen & Widgets
  data, // Datenverarbeitung (z. B. Provider, Repositories)
  error, // Fehlerhandling
  debug, // Generelles Debugging
  general, // Allgemeines Logging
}

// Globale Logging-Funktion für Debug-Zwecke
void logDebug(
  String message, {
  LogColor color = LogColor.white,
  LogTag tag = LogTag.general,
}) {
  if (!enableDebugLogging) return; // 💡 Logs deaktiviert

  final datestamp = getFormattedDate();
  final timestamp = getFormattedTime();
  final ansiColor = _getAnsiColor(color);
  final logMessage =
      '\n        $ansiColor[${tag.name.toUpperCase()}]...        $message\x1B[0m        ...$ansiColor[$datestamp  um $timestamp]\n'; // Farbe zurücksetzen

  debugPrint(logMessage); // Für normale Flutter-Debug-Ausgabe
  //logToFile(logMessage);
  /*developer.log(
    message,
    name: tag.name.toUpperCase(),
  ); // Für Flutter DevTools Logging
  */
}

// flutter build apk --dart-define=enableLogDebug=false
// flutter build web --dart-define=enableLogDebug=false

// Gibt den ANSI-Farbcode für eine Log-Ausgabe zurück.
String _getAnsiColor(LogColor color) {
  switch (color) {
    case LogColor.red:
      return '\x1B[31m'; // Rot
    case LogColor.green:
      return '\x1B[32m'; // Grün
    case LogColor.yellow:
      return '\x1B[33m'; // Gelb
    case LogColor.blue:
      return '\x1B[34m'; // Blau
    case LogColor.magenta:
      return '\x1B[35m'; // Magenta
    case LogColor.cyan:
      return '\x1B[36m'; // Cyan
    default:
      return '\x1B[37m'; // Weiß  }
  }
}

String getFormattedTime() {
  //   dependencies: flutter: ... intl: ^0.18.0
  return DateFormat('HH:mm:ss  .SSS').format(DateTime.now());
}

String getFormattedDate() {
  return DateFormat('dd.MM.yyyy').format(DateTime.now());
}

/*
logDebug("Navigating to HomePage", color: LogColor.blue, tag: "NAVIGATION");
logDebug("Fetching API data...", color: LogColor.cyan, tag: "API");
logDebug("Invalid user input!", color: LogColor.red, tag: "ERROR");

bzw.
logDebug("Navigating to HomePage", color: LogColor.blue, tag: LogTag.navigation);
logDebug("Fetching API data...", color: LogColor.cyan, tag: LogTag.api);
logDebug("User login successful!", color: LogColor.green, tag: LogTag.auth);
logDebug("Invalid user input!", color: LogColor.red, tag: LogTag.error);
logDebug("Button clicked!", color: LogColor.magenta, tag: LogTag.ui);
logDebug("Loading data from local storage...", color: LogColor.yellow, tag: LogTag.data);

*/

/// Gibt eine Flutter-Color für einen LogColor zurück (zukunftssicher, kein Color.red etc.)
Color logColorToMaterialColor(LogColor color, {ColorScheme? colorScheme}) {
  switch (color) {
    case LogColor.red:
      return colorScheme?.error ?? Colors.red;
    case LogColor.green:
      return colorScheme?.secondary ?? Colors.green;
    case LogColor.yellow:
      return colorScheme?.tertiary ?? Colors.amber;
    case LogColor.blue:
      return colorScheme?.primary ?? Colors.blue;
    case LogColor.magenta:
      return Colors.purple;
    case LogColor.cyan:
      return Colors.cyan;
    case LogColor.white:
      return Colors.white;
  }
}
