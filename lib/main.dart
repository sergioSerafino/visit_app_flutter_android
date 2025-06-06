// main.dart
// Einstiegspunkt für die Flutter-App nach Clean Architecture.
// Siehe .documents/architecture_clean_architecture.md und ADR-002 für Prinzipien.
//
// - ProviderScope für Riverpod-State-Management
// - AppRoot als zentrale Widget-Struktur (Theme, Routing, Snackbar)
// - Siehe app.dart für Details zur App-Initialisierung
//
// PROBIEREN SIE FOLGENDES: Starten Sie Ihre Anwendung mit "flutter run". Sie sehen,
// dass die Anwendung mit der zentralen Architekturstruktur startet. Ändern Sie z. B. das Theme
// in app.dart oder die Routing-Konfiguration in config/app_routes.dart und führen Sie dann ein "Hot Reload"
// durch (speichern Sie Ihre Änderungen oder drücken Sie den "Hot Reload"-Button in einer
// Flutter-unterstützten IDE oder drücken Sie "r", wenn Sie die App über die Kommandozeile
// gestartet haben).
//
// Beachten Sie, dass der Anwendungszustand beim Hot Reload erhalten bleibt. Um den Zustand zurückzusetzen,
// verwenden Sie stattdessen einen Hot Restart.
//
// Das funktioniert auch für Code, nicht nur für Werte: Die meisten Codeänderungen können
// einfach mit Hot Reload getestet werden.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio_service/audio_service.dart';

import 'app.dart';
import 'core/services/my_audio_handler.dart';

late final AudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔐 Hive initialisieren und Box öffnen
  await Hive.initFlutter();
  await Hive.openBox('podcastBox');

  // AudioService + Handler initialisieren
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'dein.channel.id',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      child: PodcastApp(),
    ),
  );
}

// Beispiel Observer
class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '🔄 Provider ${provider.name ?? provider.runtimeType} updated: $newValue',
    );
  }
}
