import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../lib/core/utils/retry_on_connection_change_interceptor.dart';
import '../../../lib/core/messaging/feedback_notifier.dart';

class MockDio extends Mock implements Dio {}

class MockFeedbackNotifier extends Mock implements FeedbackNotifier {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/fallback'));
    registerFallbackValue(Options());
  });

  group('RetryOnConnectionChangeInterceptor', () {
    late MockDio dio;
    late FeedbackNotifier feedbackNotifier;
    late RetryOnConnectionChangeInterceptor interceptor;
    late FakeConnectivity connectivity;

    setUp(() {
      dio = MockDio();
      feedbackNotifier = MockFeedbackNotifier();
      connectivity = FakeConnectivity([
        [ConnectivityResult.wifi],
      ]);
      interceptor = RetryOnConnectionChangeInterceptor(
        dio: dio,
        connectivity: connectivity,
        feedbackNotifier: feedbackNotifier,
      );
    });

    test('should retry request when connectivity is restored', () async {
      final fakeRequestOptions = RequestOptions(path: '/api/test');
      final dioError = DioException(
        requestOptions: fakeRequestOptions,
        type: DioExceptionType.connectionTimeout,
      );
      when(() => dio.request(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenAnswer((invocation) async {
        print(
            'Mock wurde aufgerufen mit path: [32m${invocation.positionalArguments[0]}[0m');
        return Response(requestOptions: fakeRequestOptions, data: 'ok');
      });
      connectivity = FakeConnectivity([
        [ConnectivityResult.none],
        [ConnectivityResult.wifi],
      ]);
      interceptor = RetryOnConnectionChangeInterceptor(
        dio: dio,
        connectivity: connectivity,
        feedbackNotifier: feedbackNotifier,
      );
      bool resolved = false;
      final handler =
          TestErrorInterceptorHandler(onResolve: (_) => resolved = true);
      await interceptor.onError(dioError, handler);
      expect(resolved, isTrue);
    });

    test('should notify user when no connection', () async {
      final fakeRequestOptions = RequestOptions(path: '/api/test');
      final dioError = DioException(
        requestOptions: fakeRequestOptions,
        type: DioExceptionType.connectionTimeout,
      );
      connectivity = FakeConnectivity([
        [ConnectivityResult.none],
        [ConnectivityResult.none],
      ]);
      final events = <FeedbackEvent>[];
      feedbackNotifier = MockFeedbackNotifierWithCapture((event) {
        events.add(event);
      });
      interceptor = RetryOnConnectionChangeInterceptor(
        dio: dio,
        connectivity: connectivity,
        feedbackNotifier: feedbackNotifier,
      );
      // Fallback-Mock für alle Aufrufe von dio.request, damit niemals null zurückgegeben wird
      when(() => dio.request(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenAnswer((invocation) async {
        print(
            '[MOCKTAIL] dio.request fallback-mock path: [32m${invocation.positionalArguments[0]}[0m');
        return Response(
            requestOptions: RequestOptions(
                path: invocation.positionalArguments[0] as String),
            data: 'fallback');
      });
      final handler = TestErrorInterceptorHandler(onResolve: (_) {});
      await interceptor.onError(dioError, handler);
      expect(
        events.any((e) =>
            e.message.contains('Keine Verbindung') &&
            e.type == FeedbackEventType.snackbar),
        isTrue,
      );
      expect(
        events.any((e) =>
            e.message.contains('Mehrere Fehlversuche') &&
            e.type == FeedbackEventType.dialog),
        isTrue,
      );
    });

    test('should notify user after max retries', () async {
      final fakeRequestOptions = RequestOptions(path: '/api/test');
      final dioError = DioException(
        requestOptions: fakeRequestOptions,
        type: DioExceptionType.connectionTimeout,
      );
      connectivity = FakeConnectivity([
        [ConnectivityResult.none],
        [ConnectivityResult.none],
        [ConnectivityResult.none],
      ]);
      final events = <FeedbackEvent>[];
      feedbackNotifier = MockFeedbackNotifierWithCapture((event) {
        events.add(event);
      });
      interceptor = RetryOnConnectionChangeInterceptor(
        dio: dio,
        connectivity: connectivity,
        feedbackNotifier: feedbackNotifier,
        maxRetries: 2,
        retryDelay: Duration(milliseconds: 10),
      );
      // Fallback-Mock für alle Aufrufe von dio.request, damit niemals null zurückgegeben wird
      when(() => dio.request(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            onSendProgress: any(named: 'onSendProgress'),
          )).thenAnswer((invocation) async {
        print(
            '[MOCKTAIL] dio.request fallback-mock path: [32m${invocation.positionalArguments[0]}[0m');
        return Response(
            requestOptions: RequestOptions(
                path: invocation.positionalArguments[0] as String),
            data: 'fallback');
      });
      final handler = TestErrorInterceptorHandler(onResolve: (_) {});
      await interceptor.onError(dioError, handler);
      expect(
        events.any((e) =>
            e.message.contains('Mehrere Fehlversuche') &&
            e.type == FeedbackEventType.dialog),
        isTrue,
      );
    });
  });
}

class TestErrorInterceptorHandler extends ErrorInterceptorHandler {
  final void Function(Response<dynamic>) onResolve;
  TestErrorInterceptorHandler({required this.onResolve});
  @override
  void resolve(Response response) => onResolve(response);
}

class MockFeedbackNotifierWithCapture extends Mock implements FeedbackNotifier {
  final void Function(FeedbackEvent) onNotify;
  MockFeedbackNotifierWithCapture(this.onNotify);
  @override
  void notify(FeedbackEvent event) => onNotify(event);
}

class FakeConnectivity implements Connectivity {
  List<List<ConnectivityResult>> results;
  int callCount = 0;
  FakeConnectivity(this.results);
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    if (callCount < results.length) {
      return results[callCount++];
    }
    return results.last;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
