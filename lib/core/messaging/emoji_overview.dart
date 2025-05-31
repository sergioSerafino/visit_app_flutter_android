// Übersicht aller Emojis aus dem Paket 'emojis'
// Siehe https://pub.dev/packages/emojis
//
// Beispiel: Alle Smileys und Symbole als Liste ausgeben
import '../../core/logging/logger_config.dart';

// Das Paket 'emojis' bietet KEINE Emojis.all().
// Beispiel: Liste typischer Unicode-Emojis, die immer funktionieren
void printSomeEmojis() {
  final emojiList = [
    "😀", // grinning face
    "👋", // waving hand
    "🎉", // party popper
    "❤️", // red heart
    "⭐", // star
    "⚠️", // warning
    "✅", // check mark
    "❌", // cross mark
    "🏆", // trophy
    "🔥", // fire
    "🧹", // broom
    "🗑️", // trash can
    "ℹ️", // info
    "⏰", // hourglass/clock
    "☁️", // cloud
    "📴", // no mobile phones
    "🧑‍💼", // person
    "🔄", // refresh
    "🌟", // glowing star
    // ...weitere nach Bedarf
  ];
  for (final emoji in emojiList) {
    logDebug(emoji);
  }
}

// Hinweis: Für die YAML-Konfiguration kannst du einfach das Unicode-Emoji (z. B. "🚀") als icon angeben.
// Die meisten Emojis funktionieren in Flutter überall als Text.

// Beispiel für die Nutzung in einer Flutter-Widget-Liste:
// ListTile(title: Text(Emojis.smile)),
// ListTile(title: Text(Emojis.rocket)),
// ...
