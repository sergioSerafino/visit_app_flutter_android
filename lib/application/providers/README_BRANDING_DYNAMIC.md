# Dynamisches Branding & Theming pro Host (collectionId)

## Überblick
Dieses Projekt unterstützt dynamisches Branding (Farben, Logo, Theme) pro Host/Mandant, gesteuert über die `collectionId`. Das Branding wird automatisch aus der passenden `host_model.json` geladen und bei Wechsel der `collectionId` live aktualisiert. Ein Fallback auf Platzhalter-Branding ist immer gewährleistet.

## Workflow
1. **App-Start:**
   - Es wird ein Platzhalter-Branding geladen (`tenants/common/host_model.json`).
   - Die zuletzt genutzte `collectionId` wird aus Hive geladen.
2. **Dynamischer Wechsel:**
   - Bei Änderung der `collectionId` (z. B. über das Admin-Panel oder Preferences) wird automatisch das Branding aus der jeweiligen `host_model.json` geladen.
   - Das Branding wird in den `brandingProvider` geschrieben und steht der gesamten App zur Verfügung.
   - Falls das Laden fehlschlägt, greift der Fallback auf das Platzhalter-Branding.
3. **UI-Integration:**
   - Alle UI-Elemente, die Branding oder Theme nutzen, reagieren automatisch auf Änderungen.
   - Beispiel: Die Hosts-Tab zeigt sofort die neuen Farben und das neue Logo.

## Technische Details
- **Provider:**
  - `collectionIdProvider`: Hält die aktuelle CollectionId (persistiert in Hive).
  - `brandingProvider`: Hält das aktuelle Branding (StateNotifier, global verfügbar).
  - `listenToCollectionIdChanges(ref)`: Listener, der bei Änderung der CollectionId das Branding asynchron lädt und aktualisiert.
- **Service:**
  - `TenantLoaderService.loadHostModel(collectionId)`: Lädt das HostModel aus der passenden JSON (mit Fallback auf common).
- **Fallback:**
  - Bei Fehlern oder fehlender Datei wird immer ein generisches Branding angezeigt (lila/hellgrau).

## Beispiel: Integration in die App
```dart
@override
void initState() {
  super.initState();
  _initApp();
  // Starte Listener für dynamisches Branding
  listenToCollectionIdChanges(ref);
}
```

## Verhalten beim Laden und Platzhalter-Branding

- Beim App-Start wird zunächst das Platzhalter-Branding geladen (grau), solange das eigentliche Branding noch nicht geladen ist.
- Sobald das Branding für die aktuelle `collectionId` erfolgreich geladen wurde, wird das Theme dynamisch aktualisiert und das korrekte Branding angezeigt.
- Wird `_initialized = false` gelassen oder `_loaded()` nicht aufgerufen, bleibt die App im Platzhalterzustand und zeigt dauerhaft das neutrale Branding.
- Erst wenn `_initialized = true` gesetzt ist (z. B. nach erfolgreichem Laden in `_initApp()`), wird das Branding für die gesetzte `collectionId` übernommen.
- Dieses Verhalten ist nützlich für Splash-Screens, Ladeanzeigen oder gezieltes Testen des Platzhalter-Brandings.
- Für ein konsistentes Nutzererlebnis sollte nach erfolgreichem Laden immer `_initialized = true` gesetzt werden, damit das Branding korrekt angezeigt wird.

**Debug-Tipp:**
- Im Debug-Modus siehst du im Log, ob das Platzhalter-Branding oder das echte Branding geladen wurde (siehe `[DEBUG] TenantLoaderService`-Ausgaben).

## Test-Szenarien
- Wechsel der CollectionId im Admin-Panel → UI passt Branding sofort an
- Ungültige CollectionId → Fallback-Branding wird angezeigt, Snackbar informiert
- App-Start ohne Netzwerk → Platzhalter-Branding sichtbar

## Farb- und Kontrastregeln für dynamisches Branding

### Farbwahl für Texte und Icons

- **onPrimary**: Nur verwenden, wenn das UI-Element direkt auf `primary`-Hintergrund liegt (z.B. AppBar, Buttons mit `primary`-Farbe).
- **onSecondary**: Nur verwenden, wenn das UI-Element direkt auf `secondary`-Hintergrund liegt.
- **onSurface**: Standard für Texte und Icons auf neutralem oder hellem Hintergrund (z.B. Scaffold, Cards, Listen, WelcomeHeader ohne expliziten Hintergrund). Sorgt für optimalen Kontrast und Barrierefreiheit.
- **onBackground**: Für Texte auf dem globalen App-Hintergrund (meist identisch mit onSurface, aber je nach Theme unterschiedlich).

### Best Practices

- Setze keinen expliziten Hintergrund im Widget, wenn der Text auf dem Standard-Hintergrund liegen soll. Nutze dann `onSurface` für Text und Icons.
- Wenn ein Hintergrund gesetzt wird (z.B. primary), dann immer die passende on*-Farbe für Text/Icon verwenden.
- Die automatische Kontrastberechnung (`_getContrastColor`) in `app_theme_mapper.dart` sorgt dafür, dass onPrimary/onSecondary immer schwarz oder weiß ist – je nach Helligkeit der Branding-Farbe.
- Für dynamische Branding-Elemente (z.B. WelcomeHeader, HomeHeader) gilt: 
  - Ohne Hintergrund: `onSurface` verwenden.
  - Mit Hintergrund: passende on*-Farbe verwenden.

### Beispiel WelcomeHeader

```dart
// Ohne Hintergrund, daher onSurface:
Text(
  'Willkommen bei ...',
  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
)
```

## Wie kann man für einzelne Komponenten (z. B. homeHeader) gezielt einen bestimmten Kontrast erzwingen?

- Die zentrale Kontrastberechnung (onPrimary/onSecondary) erfolgt in `app_theme_mapper.dart` und sorgt für Lesbarkeit auf Branding-Farben.
- Wenn du für ein bestimmtes Widget (z. B. homeHeader) immer einen bestimmten Kontrast (z. B. immer schwarz als Text) möchtest, kannst du das direkt im Widget überschreiben:

```dart
homeHeader(
  hostName,
  textColor: Colors.black, // Immer schwarz, unabhängig vom Theme-Kontrast
  backgroundColor: theme.colorScheme.primary,
)
```

- Das ist in Flutter üblich und entspricht Best Practice: Für Spezialfälle wird die Theme-Farbe gezielt überschrieben.
- Ein globaler Mechanismus für "immer hellen Kontrast für bestimmte Widgets" existiert nicht, da das Theme für die gesamte App gilt.
- Dokumentiere solche Abweichungen im Code, damit die Intention klar ist.

**Fazit:**
- Standard: Theme-Kontrast nutzen (onPrimary/onSurface)
- Spezialfall: explizit textColor setzen

### Fehlerquellen
- Unlesbarkeit entsteht, wenn z.B. `onPrimary` auf hellem Hintergrund verwendet wird. Immer prüfen, ob der Hintergrund zur on*-Farbe passt!
- Bei neuen Brandings immer mit hellen und dunklen Farbkombinationen testen.

## Best Practice: Kein UI-Flackern beim Laden von Seiten

- **LandingPage und andere Seiten, die asynchrone Daten benötigen, sollten erst dann gerendert werden, wenn die benötigten Daten (z. B. Collection, Branding) vollständig geladen sind.**
- Zeige während des Ladens keine eigenen Loading-Indikatoren oder leere Layouts auf der Zielseite, sondern halte den Nutzer auf SplashScreen/LaunchScreen oder einer dedizierten Ladeansicht.
- Erst wenn die Daten erfolgreich geladen sind, wird die eigentliche Seite (z. B. LandingPage) angezeigt. Das verhindert Flackern, Layout-Sprünge und gestapelte Widgets.
- Beispiel-Implementierung siehe `presentation/pages/landing_page.dart` und die Navigation/Logik in `presentation/pages/splash_page.dart`.
- **Vorteil:** Die Nutzer sehen immer einen ruhigen, konsistenten Übergang und keine unruhigen UI-Artefakte.

**Tipp:**
- Nutze für die Navigation nach dem Laden ein `await` auf den Provider-Future und prüfe in der Zielseite, ob die Daten wirklich da sind (z. B. mit `isSuccess`).

## Siehe auch
- `lib/config/app_theme_mapper.dart` für die Kontrastlogik
- `lib/presentation/widgets/welcome_header.dart` für ein Beispiel
- `lib/tenants/HOWTO_BRANDING_TENANTS.md` für allgemeine Branding-Infos
- `lib/config/tenant_loader_service.dart` (Ladelogik)
- `lib/application/providers/collection_provider.dart` (Provider-Logik)
- `.instructions/architecture_clean_architecture.md` (Architektur)
