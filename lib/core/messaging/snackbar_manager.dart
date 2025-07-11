import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'snackbar_event.dart';
import 'snackbar_event_factory.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'dart:developer';

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
      log('[SnackbarManager] YAML geladen', name: 'SnackbarManager');
      final yamlMap = loadYaml(configString) as YamlMap;
      final config = json.decode(json.encode(yamlMap));
      _factory = SnackbarEventFactory(config['snackbar_events'] ?? {});
      _initialized = true;
      log('[SnackbarManager] Factory initialisiert', name: 'SnackbarManager');
    } catch (e, st) {
      log(
        '[SnackbarManager] Fehler beim Laden der YAML: $e',
        name: 'SnackbarManager',
        error: e,
        stackTrace: st,
      );
    }
  }

  void showByKey(String key, {Map<String, String>? args}) async {
    log(
      '[SnackbarManager] showByKey aufgerufen: $key',
      name: 'SnackbarManager',
    );
    if (!_initialized) {
      await _init();
      if (!_initialized) {
        log(
          '[SnackbarManager] Factory konnte nicht initialisiert werden!',
          name: 'SnackbarManager',
        );
        state = SnackbarEvent(
          message: 'Snackbar-System nicht bereit',
          type: SnackbarType.error,
        );
        Future.delayed(const Duration(seconds: 2), () => state = null);
        return;
      }
    }
    try {
      log(
        '[SnackbarManager] _factory.create wird aufgerufen mit: $key',
        name: 'SnackbarManager',
      );
      final event = _factory.create(key, args: args);
      log(
        '[SnackbarManager] Event erzeugt: \\${event.message}',
        name: 'SnackbarManager',
      );
      if (event.delayMs != null && event.delayMs! > 0) {
        await Future.delayed(Duration(milliseconds: event.delayMs!));
      }
      state = event;
      // Nach kurzer Zeit zurücksetzen, damit wiederholte Events angezeigt werden
      Future.delayed(event.duration, () => state = null);
    } catch (e, st) {
      log(
        '[SnackbarManager] Fehler bei showByKey( 24key): $e',
        name: 'SnackbarManager',
        error: e,
        stackTrace: st,
      );
      // Fallback: Zeige generische Info
      state = SnackbarEvent(
        message: 'Unbekannte Snackbar: $key',
        type: SnackbarType.info,
      );
      Future.delayed(const Duration(seconds: 2), () => state = null);
    }
  }
}
