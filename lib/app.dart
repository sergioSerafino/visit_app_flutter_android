// app.dart
// Einstiegspunkt für die App-Logik, Theme, Routing und globale Snackbar.
// Siehe Doku-Matrix, ADR-003 und HowTos für Architektur- und Teststrategie.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/widgets/global_snackbar.dart';
import '../../application/providers/provides_a_snackbar_event.dart';
import '../../config/app_routes.dart';
import 'application/providers/collection_provider.dart' hide brandingProvider;
import 'application/providers/theme_provider.dart' as theme_prov;
import '../../config/tenant_loader_service.dart';
import '../../core/placeholders/placeholder_content.dart';
import '../../core/placeholders/placeholder_loader_service.dart';
import '../../presentation/pages/launch_screen.dart';
import 'core/logging/logger_config.dart';

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

  Future<void> _initApp() async {
    // 1.  ⏳ Placeholder-Fallback laden (z. B. collectionId = null)
    await PlaceholderLoaderService.init();
    // 2.  collectionId lesen: collectionIdProvider - Welche ist die aktive Collection
    // 3.  🎨 stimmt die collection überein Branding ins Theme übertragen
    final host = PlaceholderLoaderService.hostModel;
    ref.read(theme_prov.brandingProvider.notifier).setBranding(host.branding);
    // 4.  Podcastdaten für collectionId laden
    // ... ggf. weitere Initialisierung ...
    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    // Branding-Listener robust im Build-Kontext
    return _BrandingListener(
      child: _buildApp(context),
    );
  }

  Widget _buildApp(BuildContext context) {
    final theme = ref.watch(theme_prov.appThemeProvider);
    final mode = ref.watch(theme_prov.themeModeProvider);
    return GlobalSnackbarListener(
      child: MaterialApp(
        scaffoldMessengerKey: GlobalSnackbarListener.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'PodcastApp',
        theme: theme,
        darkTheme: ThemeData.dark(),
        themeMode: mode,
        initialRoute: _initialized ? AppRoutes.launchRoute : null,
        onGenerateRoute: AppRoutes.generateRoute,
        home: _initialized
            ? const LaunchScreen()
            : const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}

/// Widget, das robust auf CollectionId-Wechsel hört und Branding aktualisiert
class _BrandingListener extends ConsumerStatefulWidget {
  final Widget child;
  const _BrandingListener({required this.child});
  @override
  ConsumerState<_BrandingListener> createState() => _BrandingListenerState();
}

class _BrandingListenerState extends ConsumerState<_BrandingListener> {
  int? _lastCollectionId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listen();
  }

  @override
  void didUpdateWidget(covariant _BrandingListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    _listen();
  }

  void _listen() {
    final collectionId = ref.watch(collectionIdProvider);
    if (_lastCollectionId != collectionId) {
      _lastCollectionId = collectionId;
      _updateBranding(collectionId);
    }
  }

  Future<void> _updateBranding(int collectionId) async {
    try {
      logDebug('Versuche HostModel für collectionId $collectionId zu laden',
          tag: LogTag.ui);
      final host =
          await TenantLoaderService.loadHostModel(collectionId.toString());
      logDebug(
          'HostModel geladen: \nHostName: "+host.hostName+"\nBranding: ' +
              host.branding.toString(),
          tag: LogTag.ui);
      ref.read(theme_prov.brandingProvider.notifier).setBranding(host.branding);
      ref.read(hostModelProvider.notifier).state = host;
    } catch (e, st) {
      logDebug(
          'Fehler beim Laden des HostModels für collectionId $collectionId: $e\n$st',
          tag: LogTag.error);
      ref
          .read(theme_prov.brandingProvider.notifier)
          .setBranding(PlaceholderContent.hostModel.branding);
      ref.read(hostModelProvider.notifier).state = PlaceholderContent.hostModel;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
