import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/cast_airplay_service.dart';

/// Provider für Cast/AirPlay-Service (Discovery, Status)
final castAirPlayServiceProvider = Provider<ICastAirPlayService>((ref) {
  // In Produktion später echte Implementierung einbinden
  return CastAirPlayServiceMock();
});

/// Provider für Liste der gefundenen Geräte (ValueNotifier als StateProvider)
final castDevicesProvider =
    StateNotifierProvider<_CastDevicesNotifier, List<CastDevice>>((ref) {
  final service = ref.watch(castAirPlayServiceProvider);
  return _CastDevicesNotifier(service);
});

class _CastDevicesNotifier extends StateNotifier<List<CastDevice>> {
  final ICastAirPlayService service;
  late final VoidCallback _listener;
  _CastDevicesNotifier(this.service) : super(service.devices.value) {
    _listener = () => state = service.devices.value;
    service.devices.addListener(_listener);
  }
  @override
  void dispose() {
    service.devices.removeListener(_listener);
    super.dispose();
  }
}

/// Provider für aktuell verbundenes Gerät (ValueNotifier als StateProvider)
final connectedCastDeviceProvider =
    StateNotifierProvider<_ConnectedCastDeviceNotifier, CastDevice?>((ref) {
  final service = ref.watch(castAirPlayServiceProvider);
  return _ConnectedCastDeviceNotifier(service);
});

class _ConnectedCastDeviceNotifier extends StateNotifier<CastDevice?> {
  final ICastAirPlayService service;
  late final VoidCallback _listener;
  _ConnectedCastDeviceNotifier(this.service)
      : super(service.connectedDevice.value) {
    _listener = () => state = service.connectedDevice.value;
    service.connectedDevice.addListener(_listener);
  }
  @override
  void dispose() {
    service.connectedDevice.removeListener(_listener);
    super.dispose();
  }
}

// Diese Datei ist ein Duplikat des zentralen Providers und sollte entfernt werden.
// Die zentrale Implementierung liegt unter lib/application/providers/cast_airplay_provider.dart
