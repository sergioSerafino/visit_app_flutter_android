# HowTo: Mandanten-/Branding-System für Hosts

Dieses HowTo beschreibt, wie du für verschiedene Hosts/mandanten ("tenants") eigene Branding- und Hostdaten pflegst und wie das Fallback-System funktioniert.

## 1. Struktur & Speicherorte

- **Platzhalterwerte:**
  - `lib/tenants/common/host_model.json` → Standardwerte für alle Hosts ohne spezifische Konfiguration
- **Host-spezifische Werte:**
  - `lib/tenants/collection_<collectionId>/host_model.json` → Werte für einen bestimmten Host (z.B. `collection_0123456789`)
- **Legacy/Entwicklung:**
  - `assets/placeholders/host_model.json` → Ursprüngliche Platzhalter, werden weiterhin als Fallback genutzt

## 2. Vorgehen zum Hinzufügen/Anpassen

1. **Standardwerte pflegen:**
   - Bearbeite `lib/tenants/common/host_model.json` und trage sinnvolle Default-Werte ein.
2. **Host-spezifische Werte anlegen:**
   - Lege für jeden Host einen Ordner `lib/tenants/collection_<collectionId>/` an (falls nicht vorhanden).
   - Lege darin eine Datei `host_model.json` mit den gewünschten Branding- und Hostdaten an.
3. **Fallback:**
   - Wird für eine `collectionId` keine spezifische Datei gefunden, greift das System automatisch auf die Datei im `common`-Ordner zurück.
   - Fehlt auch diese, werden die Werte aus `assets/placeholders/host_model.json` verwendet.

## 3. Technischer Ablauf (Lade-/Merge-Logik)

- Die App lädt beim Start (bzw. Host-Wechsel) die passende `host_model.json`:
  1. **Versuch:** `lib/tenants/collection_<collectionId>/host_model.json`
  2. **Fallback:** `lib/tenants/common/host_model.json`
  3. **Letztes Fallback:** `assets/placeholders/host_model.json`
- Die Merge-Services (`merge_service.dart`, `collection_merge_service.dart`) kombinieren diese Werte ggf. mit iTunes/RSS-Daten.
- Die Priorität für Branding-Felder ist: **Host-spezifisch > Common > Placeholder**

## 4. Beispiel für eine host_model.json

```json
{
  "collectionId": 123456789,
  "hostName": "Test Host 1",
  "description": "Beschreibung für Host 1",
  "contact": { "email": "host1@example.com" },
  "branding": {
    "primaryColorHex": "#FF0000",
    "secondaryColorHex": "#00FF00",
    "headerImageUrl": "https://example.com/host1-header.png",
    "themeMode": "light",
    "logoUrl": "https://example.com/host1-logo.png"
  },
  "features": { "showPortfolioTab": true },
  "localization": { "defaultLanguageCode": "de", "localizedTexts": {} },
  "content": { "bio": "Bio Host 1", "mission": "Mission Host 1", "rss": null, "links": [] },
  "primaryGenreName": "Business",
  "authTokenRequired": false,
  "debugOnly": false,
  "lastUpdated": "2025-06-01T00:00:00.000Z"
}
```

## 5. Hinweise

- Die Merge- und Loader-Services sind bereits so implementiert, dass sie diese Struktur und Fallback-Logik unterstützen.
- Für neue Hosts einfach einen neuen Ordner und eine neue Datei nach obigem Muster anlegen.
- Siehe auch die Doku in `.instructions/` und die Tests für weitere Details.
