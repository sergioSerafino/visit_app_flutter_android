import 'package:flutter/material.dart';
import '../../core/utils/device_info_helper.dart';

/// Beispiel für die Nutzung von DeviceInfoHelper in einem Widget
class ResponsiveDemo extends StatelessWidget {
  const ResponsiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final info = DeviceInfoHelper(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Breite: ${info.width.toStringAsFixed(0)} px'),
            Text('Höhe: ${info.height.toStringAsFixed(0)} px'),
            Text('Pixeldichte: ${info.pixelRatio}'),
            Text('Orientation: ${info.orientation}'),
            Text('isTablet: ${info.isTablet}'),
            Text('isPhone: ${info.isPhone}'),
            Text('SafeArea oben: ${info.safePadding.top}'),
            const SizedBox(height: 24),
            Container(
              width: info.isTablet ? 400 : 200,
              height: 80,
              color: Colors.blue,
              child: Center(
                child: Text(
                  info.isTablet ? 'Tablet-Layout' : 'Phone-Layout',
                  style: TextStyle(fontSize: info.scale(18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
