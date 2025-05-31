// filepath: g:/ProjekteFlutter/empty_flutter_template/_migration_src/storage_hold/lib/presentation/widgets/async/async_ui_helper.dart
// /presentation/widgets/async_ui_helper.dart

import 'package:flutter/material.dart';
// import '/../../core/logging/logger_config.dart'; // Im Original importiert, aber nicht genutzt. Belassen als auskommentierte Option für spätere Fehler-Logging-Erweiterung.

class AsyncUIHelper {
  static Widget loading({double size = 30.0}) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(color: Colors.black12),
      ),
    );
  }

  static Widget error(Object error, {StackTrace? stackTrace}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ein Fehler ist aufgetreten:",
                textAlign: TextAlign.center),
            Text(
              "\n$error",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
