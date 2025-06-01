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

## Test-Szenarien
- Wechsel der CollectionId im Admin-Panel → UI passt Branding sofort an
- Ungültige CollectionId → Fallback-Branding wird angezeigt, Snackbar informiert
- App-Start ohne Netzwerk → Platzhalter-Branding sichtbar

## Siehe auch
- `lib/tenants/HOWTO_BRANDING_TENANTS.md` (Pflege der Branding-Daten)
- `lib/config/tenant_loader_service.dart` (Ladelogik)
- `lib/application/providers/collection_provider.dart` (Provider-Logik)
- `.instructions/architecture_clean_architecture.md` (Architektur)
