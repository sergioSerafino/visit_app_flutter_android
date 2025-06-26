# Reso Coder: Dio Connectivity Retry Interceptor – Original-Tutorial (Schritt-für-Schritt, Edge Cases, Code)

**Hinweis:** Dieses Dokument ergänzt das bestehende HowTo um alle granularen Details, Codebeispiele und Erklärungen aus dem Reso Coder-Tutorial. Es dient als vollständige Referenz und Mapping-Guide für die Integration im Projekt.

---

## 1. Ziel & Überblick

- Automatisches Wiederholen (Retry) von fehlgeschlagenen HTTP-Requests bei fehlender Internetverbindung.
- Nutzer-Feedback über Snackbars.
- SOLID-konforme, testbare Architektur.

---

## 2. Schritt-für-Schritt-Anleitung (Original-Tutorial)

### 2.1. Abhängigkeiten
- `dio`
- `connectivity_plus`

### 2.2. Interceptor-Klasse anlegen

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

#### **Wichtige Details & Edge Cases:**
- **RequestOptions klonen:** Sonst schlägt der erneute Request fehl.
- **CancelToken:** Wird übernommen, damit User-Interaktionen (z. B. Abbruch) korrekt funktionieren.
- **onStatus Callback:** Ermöglicht flexible Integration mit Snackbar, Logging oder UI.
- **Fehlerarten:** Retry nur bei echten Netzwerkfehlern, nicht bei 4xx/5xx.

---

### 2.3. Integration in den Dio-Client

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

---

### 2.4. Typische Fehler & Debugging
- **RequestOptions nicht geklont:** Führt zu „Request has already been sent“.
- **CancelToken vergessen:** User kann Request nicht abbrechen.
- **Retry bei falschen Fehlern:** Prüfe Fehler-Typen genau.

---

### 2.5. Erweiterungen & Tests
- **Unit-Tests:** Simuliere Connectivity und Fehlerfälle.
- **Edge Cases:**
  - Flugmodus, WLAN-Wechsel, App im Hintergrund.
  - Mehrere parallele Requests.
- **Mapping auf Projekt:**
  - Interceptor in `lib/data/api/api_client.dart` registrieren.
  - Callback an `global_snackbar.dart` weiterleiten.
  - Provider für Nutzerentscheidung (z. B. mobile Daten erlauben) nutzen.

---

## 3. Mapping: Tutorial → Projekt

| Tutorial-Schritt | Projektdatei/Ort |
|------------------|------------------|
| Interceptor      | `lib/core/utils/retry_on_connection_change_interceptor.dart` (neu anlegen) |
| Integration      | `lib/data/api/api_client.dart` |
| Snackbar         | `lib/presentation/widgets/global_snackbar.dart` |
| Provider         | `lib/application/providers/collection_provider.dart` |
| Caching/Offline  | `lib/core/utils/network_cache_manager.dart` |

---

## 4. Ressourcen
- [Reso Coder: Dio Interceptors Tutorial](https://resocoder.com/2021/02/06/dio-interceptors-flutter-tutorial/)
- [GitHub: dio-connectivity-retry-interceptor-tutorial](https://github.com/ResoCoder/dio-connectivity-retry-interceptor-tutorial)

---

**Dieses Dokument ist ein vollständiges Backup der Original-Tutorial-Details und kann direkt in das Haupt-HowTo integriert oder als Referenz genutzt werden.**
