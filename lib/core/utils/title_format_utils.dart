/// Utility für Titel-Formatierung (z.B. Zeilenumbruch an Trennzeichen)
class TitleFormatUtils {
  /// Bricht einen Titel an einem bestimmten Trennzeichen um (z.B. für UI-Darstellung)
  static String formatTitleByDelimiter(String title, String delimiter) {
    final parts = title.split(delimiter);
    if (parts.length > 1) {
      return '${parts[0]}$delimiter\n${parts.sublist(1).join(delimiter).trim()}';
    }
    return title;
  }
}
