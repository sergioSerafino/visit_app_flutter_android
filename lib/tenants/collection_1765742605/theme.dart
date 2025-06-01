/// Theme- und Branding-Referenz für collection_1765742605
///
/// Die Werte werden dynamisch aus host_model.json geladen und im UI über den Branding-Provider verwendet.
///
/// Für manuelle Pflege oder als Doku:
///
/*
Branding:             FeatureFlags:         LocalizationConfig:     HostContent:
primaryColorHex       showPortfolioTab      defaultLanguageCode     authTokenRequired
secondaryColorHex     enableContactForm                             debugOnly
themeMode             showPodcastGenre                              lastUpdated
headerImageUrl        customStartTab
logoUrl
*/

// Beispiel für dynamische Verwendung im UI:
//
// final branding = ref.watch(brandingProvider);
// final theme = ref.watch(appThemeProvider);
//
// Container(
//   color: theme.colorScheme.primary,
//   child: Text(
//     'Primärfarbe: ' + (branding.primaryColorHex ?? 'Default'),
//     style: TextStyle(color: theme.colorScheme.onPrimary),
//   ),
// )
