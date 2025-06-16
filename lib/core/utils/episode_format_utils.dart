import 'package:intl/intl.dart';

class EpisodeFormatUtils {
  static String formatTitle(String input) {
    if (input.length > 10 && input.contains('- ')) {
      final delimiters = [':', '-', '|', '/'];
      for (var d in delimiters) {
        if (input.contains(d)) {
          final parts = input.split(d);
          if (parts.length > 1) {
            return '${parts[0]}$d\n${parts.sublist(1).join(d).trim()}';
          }
        }
      }
      return input.replaceFirst(': ', ':');
    }
    return input;
  }

  static String formatDuration(int millis) {
    final totalSeconds = (millis / 1000).round();
    final hours = (totalSeconds ~/ 3600);
    final minutes = ((totalSeconds % 3600) ~/ 60);
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours}h '
          '${minutes.toString().padLeft(2, '0')}m '
          '${seconds.toString().padLeft(2, '0')}s';
    } else {
      return '${minutes}m '
          '${seconds.toString().padLeft(2, '0')}s';
    }
  }

  static String formatReleaseDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String formatAndAbbreviateTitle(String input, {int maxLength = 32}) {
    final formatted = formatTitle(input);
    final lines = formatted.split('\n');
    if (lines.length == 1) {
      return abbreviateStartAndEnd(lines[0], maxLength: maxLength);
    } else {
      final first = abbreviateStartAndEnd(lines[0], maxLength: maxLength);
      return '$first\n${lines.sublist(1).join('\n')}';
    }
  }

  static String abbreviateStartAndEnd(String input, {int maxLength = 48}) {
    if (input.length <= maxLength) return input;
    final minKeep = 6;
    final keep = ((maxLength - 3) ~/ 2).clamp(minKeep, maxLength);
    final start = input.substring(0, keep).trim();
    final end = input.substring(input.length - keep).trim();
    return '$start...$end';
  }

  static String abbreviateTitle(String input, {int maxLength = 32}) {
    if (input.length <= maxLength) return input;
    final delimiters = [':', '-', '|', '/'];
    String lastSegment = input;
    for (var d in delimiters) {
      if (input.contains(d)) {
        lastSegment = input.split(d).last.trim();
        break;
      }
    }
    if (lastSegment.length > maxLength - 4) {
      return input.substring(0, maxLength - 1) + '…';
    }
    return '… $lastSegment';
  }
}
