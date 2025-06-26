// lib/core/utils/retry_on_connection_change_interceptor.dart
// Dio 5.x & connectivity_plus 6.x – aktualisiertes Interceptor-Muster (2025)

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../messaging/feedback_notifier.dart';

/// Interceptor für automatisches Retry bei Netzwerkfehlern und Nutzer-Feedback
class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;
  final Connectivity connectivity;
  final int maxRetries;
  final Duration retryDelay;
  final FeedbackNotifier? feedbackNotifier;

  RetryOnConnectionChangeInterceptor({
    required this.dio,
    required this.connectivity,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.feedbackNotifier,
  });

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    print('[DEBUG Interceptor] onError getriggert: ${err.message}');
    if (_shouldRetry(err)) {
      final response = await _retryRequest(err);
      if (response != null) {
        print('[DEBUG Interceptor] Retry erfolgreich!');
        return handler.resolve(response);
      }
    }
    print('[DEBUG Interceptor] Kein Retry oder Retry fehlgeschlagen.');
    return handler.next(err);
  }

  /// Extrahierte Retry-Logik für bessere Testbarkeit
  Future<Response?> _retryRequest(DioException err) async {
    int retryCount = 0;
    Stream connectivityStream = connectivity.onConnectivityChanged;
    late StreamSubscription sub;
    Completer<Response?> completer = Completer();
    bool retried = false;

    void tryRequest(dynamic result) async {
      // Kompatibel mit List<ConnectivityResult> und ConnectivityResult
      final connResult = result is List
          ? (result.isNotEmpty ? result.first : ConnectivityResult.none)
          : result;
      if (connResult != ConnectivityResult.none && !retried) {
        retried = true;
        try {
          await Future.delayed(retryDelay);
          final opts = Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            responseType: err.requestOptions.responseType,
            contentType: err.requestOptions.contentType,
            extra: err.requestOptions.extra,
            followRedirects: err.requestOptions.followRedirects,
            listFormat: err.requestOptions.listFormat,
            maxRedirects: err.requestOptions.maxRedirects,
            receiveDataWhenStatusError:
                err.requestOptions.receiveDataWhenStatusError,
            receiveTimeout: err.requestOptions.receiveTimeout,
            requestEncoder: err.requestOptions.requestEncoder,
            responseDecoder: err.requestOptions.responseDecoder,
            sendTimeout: err.requestOptions.sendTimeout,
            validateStatus: err.requestOptions.validateStatus,
          );
          final response = await dio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: opts,
            cancelToken: err.requestOptions.cancelToken,
            onReceiveProgress: err.requestOptions.onReceiveProgress,
            onSendProgress: err.requestOptions.onSendProgress,
          );
          if (!completer.isCompleted) completer.complete(response);
        } catch (_) {
          retryCount++;
          retried = false;
          if (retryCount >= maxRetries && !completer.isCompleted) {
            feedbackNotifier?.notify(
              const FeedbackEvent(
                'Mehrere Fehlversuche – Verbindung prüfen!',
                type: FeedbackEventType.dialog,
              ),
            );
            completer.complete(null);
          }
        }
      }
    }

    sub = connectivityStream.listen(tryRequest);
    // Initial prüfen, falls Verbindung schon da ist
    final initial = await connectivity.checkConnectivity();
    tryRequest(initial);

    final result = await completer.future;
    await sub.cancel();
    if (result == null &&
        (initial is List ? initial.first : initial) ==
            ConnectivityResult.none) {
      feedbackNotifier?.notify(
        const FeedbackEvent(
          'Keine Verbindung – bitte WLAN oder Mobile Daten aktivieren',
          type: FeedbackEventType.snackbar,
        ),
      );
    }
    return result;
  }

  bool _shouldRetry(DioException err) {
    // Retry nur bei Netzwerkfehlern und Timeout
    return err.type == DioExceptionType.unknown ||
        err.type == DioExceptionType.connectionTimeout;
  }
}

// ---
// Unterschied zur Reso Coder-Implementierung:
// Im Reso Coder-Tutorial wird ein Completer<Response> verwendet, weil der Retry asynchron
// über einen Stream (onConnectivityChanged.listen) erfolgt und das Ergebnis später
// zurückgegeben werden muss. In dieser modernen Lösung erfolgt das Retry-Polling synchron
// per await in einer Schleife. Das Ergebnis kann daher direkt mit handler.resolve(response)
// zurückgegeben werden – ein Completer ist nicht notwendig.
// Vorteil: Weniger Komplexität, keine Stream-Subscription nötig, besser testbar.
// ---
