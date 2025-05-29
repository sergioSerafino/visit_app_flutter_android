# MergeService: Entscheidungsdokumentation & Feldherkunft

## Feldquellen und Merge-Strategie
- collectionId: iTunes API (Hauptquelle), Schlüssel für alle Podcast-Daten
- feedUrl: iTunes API, essenziell für RSS-Abruf
- about.json & host_model.json: werden zu LocalJsonData zusammengeführt, kapseln Zusatzinfos wie FeatureFlags, Branding, Localization

## Feldherkunft im MergeService (Beispiele)
| Feld                   | Quelle (Priorität)         | Bemerkung |
|------------------------|----------------------------|-----------|
| collectionId           | iTunes                     |           |
| collectionName         | iTunes                     |           |
| artistName             | iTunes                     |           |
| primaryGenreName       | iTunes                     |           |
| artworkUrl600          | iTunes                     |           |
| feedUrl                | iTunes                     |           |
| episodes               | iTunes                     |           |
| hostName               | iTunes (artistName)        |           |
| description            | RSS > LocalJson > ''       |           |
| contact.email          | RSS > LocalJson            |           |
| contact.websiteUrl     | RSS > LocalJson            |           |
| branding.logoUrl       | RSS (Cover) > iTunes (artworkUrl600) > LocalJson | logoUrl aus RSS ist meist sehr groß, artworkUrl600 ist Standard |
| branding.primaryColor  | LocalJson                  | Für dynamisches Theming |
| branding.secondaryColor| LocalJson                  | Für dynamisches Theming |
| headerImageUrl         | LocalJson                  | Optional, für Layout |
| themeMode              | LocalJson                  | Kundenpräferenz für App-Design |
| features               | LocalJson                  | Feature-Flags für UI |
| localization           | LocalJson                  | defaultLanguageCode ggf. aus iTunes |
| localizedTexts         | LocalJson                  | |
| content                | LocalJson                  | |
