import 'package:flutter_test/flutter_test.dart';
import 'package:empty_flutter_template/core/services/cast_airplay_service.dart';

void main() {
  group('CastAirPlayServiceMock', () {
    late CastAirPlayServiceMock service;

    setUp(() {
      service = CastAirPlayServiceMock();
    });

    test('discoverDevices liefert Geräte', () async {
      expect(service.devices.value, isEmpty);
      await service.discoverDevices();
      expect(service.devices.value.length, greaterThanOrEqualTo(2));
      expect(
        service.devices.value.any((d) => d.type == CastDeviceType.chromecast),
        isTrue,
      );
      expect(
        service.devices.value.any((d) => d.type == CastDeviceType.airplay),
        isTrue,
      );
    });

    test('connectToDevice setzt connectedDevice', () async {
      await service.discoverDevices();
      final device = service.devices.value.first;
      expect(service.connectedDevice.value, isNull);
      await service.connectToDevice(device);
      expect(service.connectedDevice.value, equals(device));
    });

    test('disconnect setzt connectedDevice auf null', () async {
      await service.discoverDevices();
      final device = service.devices.value.first;
      await service.connectToDevice(device);
      expect(service.connectedDevice.value, isNotNull);
      await service.disconnect();
      expect(service.connectedDevice.value, isNull);
    });
  });
}
