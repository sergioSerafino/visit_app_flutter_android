// scripts/fix_branding_colors.dart
// Dart-Skript: Prüft alle host_model.json in lib/tenants/ und setzt fehlende/ungültige secondaryColorHex auf #EEEEEE

import 'dart:convert';
import 'dart:io';

const placeholderSecondary = '#EEEEEE';

void main() async {
  final dir = Directory('lib/tenants');
  final files = await dir
      .list(recursive: true)
      .where((f) => f is File && f.path.endsWith('host_model.json'))
      .cast<File>()
      .toList();

  int fixed = 0;
  for (final file in files) {
    final content = await file.readAsString();
    final json = jsonDecode(content);
    final branding = json['branding'] as Map<String, dynamic>?;
    if (branding == null) continue;
    final sec = branding['secondaryColorHex'];
    if (sec == null ||
        sec is! String ||
        sec.trim().isEmpty ||
        !_isValidHex(sec)) {
      branding['secondaryColorHex'] = placeholderSecondary;
      json['branding'] = branding;
      await file
          .writeAsString(const JsonEncoder.withIndent('  ').convert(json));
      print(
          '✔️  secondaryColorHex in ${file.path} gesetzt auf $placeholderSecondary');
      fixed++;
    }
  }
  if (fixed == 0) {
    print('Alle Brandings sind korrekt!');
  } else {
    print('Fertig. $fixed Branding(s) korrigiert.');
  }
}

bool _isValidHex(String hex) {
  final h = hex.replaceAll('#', '');
  return h.length == 6 && int.tryParse(h, radix: 16) != null;
}
