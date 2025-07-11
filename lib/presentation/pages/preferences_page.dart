//
// /pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/providers/onboarding_status_provider.dart';
import '../../application/providers/collection_provider.dart';
import '../../application/providers/data_mode_provider.dart';
import '../../domain/enums/repository_source_type.dart';
import '../../application/providers/podcast_provider.dart';
import '../../application/providers/episode_controller_provider.dart';
import '../../core/logging/logger_config.dart';
import '../../core/messaging/snackbar_manager.dart';
import '../widgets/custom_text_field.dart';

class PreferencesBottomSheet extends ConsumerWidget {
  const PreferencesBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingStatusProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 32.0,
          left: 16.0,
          right: 16.0,
        ), // 32 oben, 16 seitlich
        child: SingleChildScrollView(
          child: onboardingAsync.when(
            data: (onboardingDone) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.settings),
                      ),
                      Text(
                        '  Einstellungen',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const Divider(),
                  // 🔄 Onboarding Reset
                  ListTile(
                    leading: const Icon(Icons.replay_outlined),
                    title: const Text("Onboarding erneut starten"),
                    subtitle: const Text(
                      "Kann beim nächsten Start erneut durchlaufen werden.",
                    ),
                    onTap: () async {
                      logDebug("Option: Onboarding zurücksetzen");
                      await ref
                          .read(onboardingStatusProvider.notifier)
                          .resetOnboarding();
                      await ref
                          .read(hasCompletedStartProvider.notifier)
                          .resetStart();

                      // Setze Flag für nächste Session
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(
                        'showOnboardingRestartedSnackbar',
                        true,
                      );

                      // Zeige sofort eine Bestätigungs-Snackbar
                      ref
                          .read(snackbarManagerProvider.notifier)
                          .showByKey('onboarding_reset');

                      Navigator.of(context).pop();
                    },
                  ),

                  const SizedBox(height: 18),
                  // --- Apple-Style Trennung ---
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                    margin: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.system_update),
                    title: const Text('App auf Updates prüfen'),
                    subtitle: const Text(
                      'Rufe ab, ob Neuerungen verfügbar sind.',
                    ),
                    onTap: () {
                      logDebug("Updates prüfen gewählt");
                      final snackbarManager2 = ref.read(
                        snackbarManagerProvider,
                      );
                      if (snackbarManager2 != null) {
                        ref
                            .read(snackbarManagerProvider.notifier)
                            .showByKey('not_implemented');
                      }
                    },
                  ),

                  const SizedBox(height: 18),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                    margin: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  const SizedBox(height: 8),
                  const ListTile(
                    leading: Icon(Icons.light_mode),
                    title: Text('Daymode-Funktion'),
                    subtitle:
                        Text('Passe die Farben der App dem Tagesverlauf an.'),
                  ),

                  const SizedBox(height: 18),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                    margin: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Icon(
                      ref.watch(dataSourceProvider) == RepositorySourceType.api
                          ? Icons.public // Weltkugel
                          : Icons.edit, // Stift
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    title: const Text('API-Modus umschalten (Admin-Switch)'),
                    trailing: Switch(
                      value: ref.watch(dataSourceProvider) ==
                          RepositorySourceType.api,
                      onChanged: (value) {
                        toggleDataSource(ref);
                        ref.invalidate(collectionIdProvider);
                        final collectionId = ref.read(collectionIdProvider);
                        final _ = ref.refresh(
                          podcastCollectionProvider(collectionId),
                        );
                        ref.invalidate(episodeLoadControllerProvider);
                        ref.invalidate(collectionLoadControllerProvider);
                      },
                    ),
                    subtitle: const Text(
                      'Wechsle zwischen iTunes API (🌐) und lokalem Modus (✍️).',
                    ),
                  ),

                  const SizedBox(height: 18),
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                    margin: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  const SizedBox(height: 8),

                  ListTile(
                    leading: Icon(Icons.numbers,
                        size: 24, color: Theme.of(context).colorScheme.primary),
                    title: const Text('Eingabe iTunes API (Admin-Input)'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Setze temporär die Collection ID für API-Tests.',
                        ),
                        Builder(
                          builder: (context) {
                            final currentId = ref.watch(collectionIdProvider);
                            final defaultItems = const [
                              DropdownMenuItem(
                                value: 1469653179,
                                child: Text(
                                  'Shayan & Nizar (1469653179)',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1765742605,
                                child: Text(
                                  'Fest und Flauschig (1765742605)',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1481054140,
                                child: Text(
                                  'barbaradio (1481054140)',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1292709842,
                                child: Text(
                                  'Gemischtes Hack (1292709842)',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1590516386,
                                child: Text(
                                  'Opalia Talk (1590516386)',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1191610678,
                                child: Text(
                                  'Curse (1191610678)',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1814331727,
                                child: Text(
                                  'Fullcourt Attitude (1814331727)',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ];
                            final hasCurrent = defaultItems.any(
                              (item) => item.value == currentId,
                            );
                            final items = hasCurrent
                                ? defaultItems
                                : [
                                    DropdownMenuItem(
                                      value: currentId,
                                      child: const Text(
                                        'Aktuelle ID ( 24currentId)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ...defaultItems,
                                  ];

                            return DropdownButton<int>(
                              value: currentId,
                              isExpanded: true,
                              items: items,
                              onChanged: (value) {
                                if (value != null) {
                                  ref
                                      .read(collectionIdProvider.notifier)
                                      .setCollectionId(value);
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          label: "Collection ID",
                          hint: "📡  z.B. 9876543210",
                          keyboardType: TextInputType.number,
                          validator: (text) {
                            if (text.isEmpty) return "Bitte gib eine ID ein";
                            if (int.tryParse(text) == null)
                              return "Nur Zahlen erlaubt";
                            return null;
                          },
                          initialValue:
                              ref.watch(collectionIdProvider).toString(),
                          onChanged: (value) {
                            final id = int.tryParse(value);
                            if (id != null) {
                              ref
                                  .read(collectionIdProvider.notifier)
                                  .setCollectionId(id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (e, _) => Text('Fehler beim Laden: $e'),
          ),
        ),
      ),
    );
  }
}

toggleDataSource(WidgetRef ref) {
  final isApiMode = ref.read(dataSourceProvider) == RepositorySourceType.api;
  ref.read(dataSourceProvider.notifier).state =
      isApiMode ? RepositorySourceType.local : RepositorySourceType.api;
}
