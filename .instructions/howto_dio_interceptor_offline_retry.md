# HowTo: Dio Interceptor für Offline/Retry & Nutzer-Feedback (nach Reso Coder)

## Ziel
Ein zentraler Dio-Interceptor soll alle Netzwerkrequests abfangen, bei fehlender Verbindung automatisch Retry-Logik ausführen und den Nutzer über Snackbars informieren. Nach mehreren Fehlversuchen kann gezielt die Nutzung von "Mobilen Daten" angeboten werden.

---

## SOLID-Konformität & Clean Architecture
- **Single Responsibility Principle (SRP):**
  - Der Interceptor ist ausschließlich für die Behandlung von Netzwerkfehlern, Retry und Connectivity zuständig.
  - Die Snackbar-Logik bleibt im Snackbar-Manager/Provider gekapselt.
- **Open/Closed Principle (OCP):**
  - Die Retry-Logik ist erweiterbar (z. B. für weitere Fehlerarten, Logging, Nutzerentscheidungen), ohne bestehende Klassen zu verändern.
- **Liskov Substitution Principle (LSP):**
  - Der Interceptor kann überall dort eingesetzt werden, wo ein Dio-Interceptor erwartet wird.
- **Interface Segregation Principle (ISP):**
  - Die Schnittstellen (z. B. Callback für Status, Connectivity) sind klar getrennt und können unabhängig genutzt werden.
- **Dependency Inversion Principle (DIP):**
  - Der Interceptor erhält seine Abhängigkeiten (Dio, Connectivity, Callback) per Konstruktor-Injektion.

---

## Architekturüberblick
- **Dio-Interceptor**: Fängt alle Requests/Fehler ab, prüft Connectivity, führt ggf. Retry durch.
- **Connectivity**: Prüft, ob eine Verbindung (WLAN/Mobile Daten) besteht.
- **Snackbar-System**: Zeigt Status und Fehler global an (z. B. "Keine Verbindung", "Mehrere Fehlversuche", "Mobile Daten verwenden?").
- **Provider/State**: Speichert Nutzerentscheidung (z. B. Mobile Daten erlauben).

---

## Umsetzungsschritte
1. **Interceptor-Klasse anlegen** (z. B. `RetryOnConnectionChangeInterceptor`)
   - Erbt von `Interceptor` (Dio)
   - Nimmt `Dio`, `Connectivity`, Retry-Parameter und Callback für Status entgegen
2. **onError überschreiben**
   - Prüft, ob ein Retry sinnvoll ist (`_shouldRetry`)
   - Prüft Connectivity (WLAN/Mobile Daten)
   - Führt bis zu `maxRetries` Wiederholungen mit Delay durch
   - Bei Erfolg: Request erneut senden
   - Bei Misserfolg: Snackbar-Event auslösen (z. B. "Mehrere Fehlversuche – Verbindung prüfen!")
   - Optional: Nach X Fehlversuchen Nutzer fragen, ob Mobile Daten verwendet werden dürfen
3. **Integration in API-Client**
   - Interceptor beim Erstellen des Dio-Clients registrieren (z. B. in `api_client.dart`)
   - Callback für Statusmeldungen an Snackbar-Manager weiterleiten
4. **Snackbar-Integration**
   - Status- und Fehlertexte über zentralen Snackbar-Provider anzeigen
   - Übersetzungen in `intl_de.arb`/`app_en.arb` pflegen
5. **Nutzerentscheidung speichern**
   - Nach mehreren Fehlversuchen Option anbieten: "Mobile Daten verwenden?"
   - Entscheidung im Provider speichern und beim nächsten Versuch berücksichtigen

---

## Beispiel-Code (angepasst nach Reso Coder)
```dart
class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;
  final Connectivity connectivity;
  final int maxRetries;
  final Duration retryDelay;
  final void Function(String message)? onStatus;

  RetryOnConnectionChangeInterceptor({
    required this.dio,
    required this.connectivity,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.onStatus,
  });

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      int retryCount = 0;
      while (retryCount < maxRetries) {
        final result = await connectivity.checkConnectivity();
        if (result != ConnectivityResult.none) {
          try {
            await Future.delayed(retryDelay);
            return await dio.request(
              err.requestOptions.path,
              options: err.requestOptions,
            );
          } catch (_) {
            retryCount++;
          }
        } else {
          onStatus?.call('Keine Verbindung – bitte WLAN oder Mobile Daten aktivieren');
          break;
        }
      }
      onStatus?.call('Mehrere Fehlversuche – Verbindung prüfen!');
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other || err.type == DioErrorType.connectTimeout;
  }
}
```

---

## Checkliste für die Integration
- [ ] Interceptor-Klasse wie oben anlegen
- [ ] Connectivity-Package einbinden (`connectivity_plus`)
- [ ] Interceptor im Dio-Client registrieren (z. B. in `api_client.dart`)
- [ ] Callback für Statusmeldungen an Snackbar-Manager weiterleiten
- [ ] Snackbar-Events und Übersetzungen ergänzen
- [ ] Nach mehreren Fehlversuchen Option für "Mobile Daten verwenden" anbieten
- [ ] Entscheidung des Nutzers speichern und berücksichtigen
- [ ] Tests für Interceptor, Retry und Snackbar-Feedback schreiben

---

## Hinweise
- Die Retry-Logik kann für iTunes, RSS und alle weiteren Netzwerkdatenquellen genutzt werden.
- Die Snackbar-Integration ist bereits im Projekt vorbereitet (siehe relevante Dateien oben).
- Die Nutzerführung (z. B. "Mobile Daten verwenden?") kann flexibel über Snackbar oder Dialog erfolgen.

---

# ANHANG: Original-Details & Schritt-für-Schritt nach Reso Coder

**Siehe auch:** `.instructions/howto_dio_interceptor_offline_retry_resocoder_full.md` für das vollständige, granular dokumentierte Tutorial.

## Schritt-für-Schritt (Original-Tutorial, alle Details)

### 1. Abhängigkeiten
- `dio`
- `connectivity_plus`

### 2. Interceptor-Klasse (vollständig, mit Edge Cases)
```dart
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;
  final Connectivity connectivity;
  final int maxRetries;
  final Duration retryDelay;
  final void Function(String message)? onStatus;

  RetryOnConnectionChangeInterceptor({
    required this.dio,
    required this.connectivity,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.onStatus,
  });

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      int retryCount = 0;
      while (retryCount < maxRetries) {
        final result = await connectivity.checkConnectivity();
        if (result != ConnectivityResult.none) {
          try {
            await Future.delayed(retryDelay);
            // WICHTIG: RequestOptions müssen geklont werden!
            final opts = Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              responseType: err.requestOptions.responseType,
              contentType: err.requestOptions.contentType,
              extra: err.requestOptions.extra,
              followRedirects: err.requestOptions.followRedirects,
              listFormat: err.requestOptions.listFormat,
              maxRedirects: err.requestOptions.maxRedirects,
              receiveDataWhenStatusError: err.requestOptions.receiveDataWhenStatusError,
              receiveTimeout: err.requestOptions.receiveTimeout,
              requestEncoder: err.requestOptions.requestEncoder,
              responseDecoder: err.requestOptions.responseDecoder,
              sendTimeout: err.requestOptions.sendTimeout,
              validateStatus: err.requestOptions.validateStatus,
            );
            return await dio.request(
              err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: opts,
              cancelToken: err.requestOptions.cancelToken,
              onReceiveProgress: err.requestOptions.onReceiveProgress,
              onSendProgress: err.requestOptions.onSendProgress,
            );
          } catch (_) {
            retryCount++;
          }
        } else {
          onStatus?.call('Keine Verbindung – bitte WLAN oder Mobile Daten aktivieren');
          break;
        }
      }
      onStatus?.call('Mehrere Fehlversuche – Verbindung prüfen!');
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioError err) {
    // Retry nur bei Netzwerkfehlern und Timeout
    return err.type == DioErrorType.other || err.type == DioErrorType.connectTimeout;
  }
}
```

**Wichtige Hinweise:**
- RequestOptions müssen geklont werden, sonst schlägt der erneute Request fehl.
- CancelToken übernehmen, damit User-Interaktionen (Abbruch) funktionieren.
- Retry nur bei echten Netzwerkfehlern, nicht bei 4xx/5xx.

### 3. Integration in den Dio-Client
```dart
final dio = Dio();
dio.interceptors.add(
  RetryOnConnectionChangeInterceptor(
    dio: dio,
    connectivity: Connectivity(),
    maxRetries: 3,
    retryDelay: Duration(seconds: 2),
    onStatus: (msg) {
      // Hier z. B. Snackbar-Event triggern
    },
  ),
);
```

### 4. Typische Fehler & Debugging
- RequestOptions nicht geklont → „Request has already been sent“
- CancelToken vergessen → User kann Request nicht abbrechen
- Retry bei falschen Fehlern → Fehler-Typen genau prüfen

### 5. Mapping Tutorial → Projekt
| Tutorial-Schritt | Projektdatei/Ort |
|------------------|------------------|
| Interceptor      | `lib/core/utils/retry_on_connection_change_interceptor.dart` (neu anlegen) |
| Integration      | `lib/data/api/api_client.dart` |
| Snackbar         | `lib/presentation/widgets/global_snackbar.dart` |
| Provider         | `lib/application/providers/collection_provider.dart` |
| Caching/Offline  | `lib/core/utils/network_cache_manager.dart` |

---

**Vollständige, kommentierte Version siehe:** `.instructions/howto_dio_interceptor_offline_retry_resocoder_full.md`
