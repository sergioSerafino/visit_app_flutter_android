// app.dart
// Einstiegspunkt für die App-Logik, Theme, Routing und globale Snackbar.
// Siehe Doku-Matrix, ADR-003 und HowTos für Architektur- und Teststrategie.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/widgets/global_snackbar.dart';
import '../../application/providers/provides_a_snackbar_event.dart';
import '../../config/app_routes.dart';
import '../../application/providers/theme_provider.dart';
import '../../core/placeholders/placeholder_loader_service.dart';
import '../../presentation/pages/launch_screen.dart';
// import '/../../presentation/pages/landing_page.dart';

// PodcastApp (Stateless -> vereinfacht mit Consumer):
class PodcastApp extends ConsumerStatefulWidget {
  const PodcastApp({super.key});

  @override
  ConsumerState<PodcastApp> createState() => _PodcastAppState();
}

class _PodcastAppState extends ConsumerState<PodcastApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  // PLACEHOLDER-SERVICE
  /* To Dos: Entferne synchrone Zugriffe auf PlaceholderLoaderService.podcastCollection
             Verwende stattdessen ref.watch(podcastCollectionProvider(...))
             für sichere UI-Logik benutze .when(...)
  */
  Future<void> _initApp() async {
    // 1.  ⏳ Placeholder-Fallback laden (z. B. collectionId = null)
    await PlaceholderLoaderService.init();

    // 2.  collectionId lesen: collectionIdProvider - Welche ist die aktive Collection

    // 3.  🎨 stimmt die collection überein Branding ins Theme übertragen
    final host = PlaceholderLoaderService.hostModel;
    ref.read(brandingProvider.notifier).setBranding(host.branding);

    // 4.  Podcastdaten für collectionId laden

    /*
    // 5.  feedUrl extrahieren
    final feedUrl = podcastResponse.when(
      loading: () => null,
      error: (_) => null,
      success: (collection) => collection.podcasts.firstOrNull?.feedUrl,
    );

    // 6. Wenn feedUrl vorhanden → RSS Parser verwenden
    if (feedUrl != null) {
      final metadata = await _rssParser.parse(feedUrl);
      _rssParser.debugPrintMetadata(metadata);
    } else {
      debugPrint('❗️Keine gültige feedUrl gefunden – App startet trotzdem.');
    }
*/

    // 7.  ✅ App als bereit markieren
    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    // PROVIDER
    final theme = ref.watch(appThemeProvider);
    final mode = ref.watch(themeModeProvider);

    return GlobalSnackbarListener(
      child: MaterialApp(
        scaffoldMessengerKey: GlobalSnackbarListener.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'PodcastApp',
        theme: theme,
        darkTheme: ThemeData.dark(),
        themeMode: mode,

        // 🔁 Routing-Logik über AppRoutes
        initialRoute: _initialized ? AppRoutes.launchRoute : null,
        onGenerateRoute: AppRoutes.generateRoute,

        // Optional: Rückfallseite beim Laden
        home:
            _initialized
                ? const LaunchScreen() //null // ← Routing übernimmt!
                : const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
      ),
    );
  }
}
