<!-- Siehe auch: doku_matrix.md für die zentrale Übersicht aller Doku- und HowTo-Dateien. -->
<!-- Verwandte Themen: howto_merge_caching.md, howto_merge_decisions_and_field_sources.md, adr-001-merge-strategy.md -->

# Erkenntnisse & Empfehlungen zur robusten RSS-Feed-Verfolgung (Redirects)

## 1. Redirects bei RSS-Feeds (anchor.fm, podigee, etc.)
- Viele Podcast-Hoster (z.B. anchor.fm, podigee, buzzsprout, libsyn, etc.) nutzen HTTP-Redirects, um RSS-Feeds auf CDN- oder Tracking-URLs weiterzuleiten.
- Die Feed-URL aus iTunes oder JSON ist oft nicht die endgültige XML-Quelle.
- Die Dio-Optionen `followRedirects: true` und `maxRedirects: 5` sorgen dafür, dass alle Weiterleitungen automatisch verfolgt werden.
- Die Option `validateStatus: (status) => status != null && status < 500` akzeptiert auch 3xx-Statuscodes, sodass keine Exception bei Redirects geworfen wird.
- Die Merge- und Parsing-Logik ist damit robust für alle gängigen Hoster.

## 2. MergeService-Tests: Erkenntnisse
- Die Feldpriorität für logoUrl ist jetzt: RSS > iTunes > LocalJson.
- contact.email: RSS > LocalJson > Default ('').
- Die Tests decken alle Edge Cases ab (nur iTunes, nur RSS, nur LocalJson, Kombinationen).
- Die Integration mit echten RSS-XML-Strings funktioniert und ist unabhängig von Netzwerkproblemen testbar.
- Die Teststrategie ist dokumentiert und entspricht Clean Architecture.

## 3. Empfehlungen für weitere Hoster
- Die aktuelle Lösung funktioniert für anchor.fm, podigee und alle anderen, die Standard-HTTP-Redirects nutzen.
- Bei exotischen Anbietern ggf. maxRedirects erhöhen oder spezielle Header setzen.
- Für Debugging: Im Fehlerfall die endgültige URL und alle Redirects loggen.

## 4. Weiteres Vorgehen
- Bei neuen Feldern oder Hostern: Testfall ergänzen und MergeService ggf. anpassen.
- Die Architektur ist flexibel und testbar für alle Podcast-Feed-Szenarien.

---

## Legacy-/Migrationshinweise (aus storage_hold)

Diese Datei wurde im Rahmen der Migration aus dem Altprojekt `storage_hold` übernommen und weiterentwickelt.

- Ursprünglicher Hinweis: Erkenntnisse & Empfehlungen zur robusten RSS-Feed-Verfolgung (Redirects) und MergeService-Tests.
- Siehe auch: `doku_matrix.md` für die zentrale Übersicht aller Doku- und HowTo-Dateien (wie im Altprojekt empfohlen).
- Verwandte Themen: `howto_merge_caching.md`, `howto_merge_decisions_and_field_sources.md`, `adr-001-merge-strategy.md` (siehe Altprojekt).

---
Letzter Stand: 27.05.2025
