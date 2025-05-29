import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'snackbar_event.dart';
import 'snackbar_event_factory.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

final snackbarManagerProvider =
    StateNotifierProvider<SnackbarManager, SnackbarEvent?>((ref) {
  return SnackbarManager(ref);
});

class SnackbarManager extends StateNotifier<SnackbarEvent?> {
  final Ref ref;
  late SnackbarEventFactory _factory;
  bool _initialized = false;

  SnackbarManager(this.ref) : super(null) {
    _init();
  }

  Future<void> _init() async {
    try {
      final configString = await rootBundle.loadString(
        'lib/core/messaging/snackbar_config.yaml',
      );
      final yamlMap = loadYaml(configString) as YamlMap;
      final config = json.decode(json.encode(yamlMap));
      _factory = SnackbarEventFactory(config['snackbar_events'] ?? {});
      _initialized = true;
    } catch (e) {
      // Fehler-Logging oder weitere Fehlerbehandlung hier ergänzen
      // Stacktrace kann bei Bedarf ergänzt werden
      state = SnackbarEvent(
        message: 'Snackbar-System nicht bereit',
        type: SnackbarType.error,
      );
      Future.delayed(const Duration(seconds: 2), () => state = null);
    }
  }

  void showByKey(String key, {Map<String, String>? args}) async {
    if (!_initialized) {
      await _init();
      if (!_initialized) {
        state = SnackbarEvent(
          message: 'Snackbar-System nicht bereit',
          type: SnackbarType.error,
        );
        Future.delayed(const Duration(seconds: 2), () => state = null);
        return;
      }
    }
    try {
      final event = _factory.create(key, args: args);
      if (event.delayMs != null && event.delayMs! > 0) {
        await Future.delayed(Duration(milliseconds: event.delayMs!));
      }
      state = event;
      Future.delayed(event.duration, () => state = null);
    } catch (e, st) {
      state = SnackbarEvent(
        message: 'Unbekannte Snackbar: $key',
        type: SnackbarType.info,
      );
      Future.delayed(const Duration(seconds: 2), () => state = null);
    }
  }
}
