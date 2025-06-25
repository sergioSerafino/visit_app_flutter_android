# To-Do-Liste: Datenpersistenz & Interceptor

## 1. Datenpersistenz/Offline-Fähigkeit
- [ ] Sicherstellen, dass alle relevanten Datenmodelle (Podcasts, Episoden, Branding, Host) lokal gespeichert und geladen werden können
- [ ] Repositories so gestalten, dass sie bei fehlender Internetverbindung automatisch auf lokale Datenquellen zurückgreifen
- [ ] Fallback-Logik in allen relevanten Providern/Repositories prüfen und ggf. ergänzen
- [ ] Initiale Demo-Daten für Offline-Start in den Cache legen
- [ ] UI-Feedback für Offline-Modus einbauen (Snackbar, Banner, Icon)
- [ ] Optional: Expliziten Offline-Modus in den Einstellungen anbieten

## 2. Interceptor für Netzwerkrequests
- [ ] Zentralen Interceptor für den API-Client implementieren (z. B. in api_client.dart)
- [ ] Fehlerfälle (Timeout, keine Verbindung) abfangen und Fallback-Mechanismus triggern
- [ ] Optional: Logging und Monitoring der Requests/Responses für Debugging

## 3. Testen & Optimieren
- [ ] App ohne Internet starten und Verhalten testen
- [ ] Responsiveness und User Experience für verschiedene Devices optimieren

---

Siehe auch: `einschaetzung_naechste_schritte_persistenz_interceptor.md` für ausführliche Analyse und Begründung.