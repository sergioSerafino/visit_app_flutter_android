// Doku-Querverweis: Siehe .instructions/doku_matrix.md, ADR-003-Teststrategie.md und HowTos für Cast/AirPlay-Architektur, Service-Pattern und Teststrategie.
// Lessons Learned: Service-Interface und Mock für Cast/AirPlay-Integration, testbare Discovery- und Verbindungslogik. Siehe zugehörige Provider und Widget-Tests.
// Hinweise: Für produktive Nutzung echten Service implementieren, für Tests Mock verwenden.

import 'package:flutter/foundation.dart';

/// Enum für Cast/AirPlay-Gerätetypen
enum CastDeviceType { chromecast, airplay, dlna, unknown }

/// Status eines Cast/AirPlay-Geräts
class CastDevice {
  final String id;
  final String name;
  final CastDeviceType type;
  final bool isConnected;

  CastDevice({
    required this.id,
    required this.name,
    required this.type,
    this.isConnected = false,
  });
}

/// Service-Interface für Discovery und Status von Cast/AirPlay-Geräten
abstract class ICastAirPlayService {
  /// Stream mit allen gefundenen Geräten
  ValueListenable<List<CastDevice>> get devices;

  /// Aktuell verbundenes Gerät (oder null)
  ValueListenable<CastDevice?> get connectedDevice;

  /// Suche nach Geräten starten
  Future<void> discoverDevices();

  /// Verbindung zu Gerät herstellen
  Future<void> connectToDevice(CastDevice device);

  /// Verbindung trennen
  Future<void> disconnect();
}

/// Platzhalter-Implementierung (Mock/Fake)
class CastAirPlayServiceMock implements ICastAirPlayService {
  final ValueNotifier<List<CastDevice>> _devices = ValueNotifier([]);
  final ValueNotifier<CastDevice?> _connectedDevice = ValueNotifier(null);

  @override
  ValueListenable<List<CastDevice>> get devices => _devices;

  @override
  ValueListenable<CastDevice?> get connectedDevice => _connectedDevice;

  @override
  Future<void> discoverDevices() async {
    // Simuliere Discovery
    await Future.delayed(const Duration(milliseconds: 300));
    _devices.value = [
      CastDevice(
        id: '1',
        name: 'Chromecast Wohnzimmer',
        type: CastDeviceType.chromecast,
      ),
      CastDevice(id: '2', name: 'Apple TV', type: CastDeviceType.airplay),
    ];
  }

  @override
  Future<void> connectToDevice(CastDevice device) async {
    _connectedDevice.value = device;
  }

  @override
  Future<void> disconnect() async {
    _connectedDevice.value = null;
  }
}
