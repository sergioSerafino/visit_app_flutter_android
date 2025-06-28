// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart'
//     show any, anyNamed, verify, when, Mock, argThat, anyThat;
// import 'package:dio/dio.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import '../../../lib/core/utils/retry_on_connection_change_interceptor.dart';
// import '../../../lib/core/messaging/feedback_notifier.dart';

// class MockDio extends Mock implements Dio {}

// class MockConnectivity extends Mock implements Connectivity {}

// class MockFeedbackNotifier extends Mock implements FeedbackNotifier {}

// void main() {
//   group('RetryOnConnectionChangeInterceptor', () {
//     late MockDio dio;
//     late MockConnectivity connectivity;
//     late MockFeedbackNotifier feedbackNotifier;
//     late RetryOnConnectionChangeInterceptor interceptor;
//     late ErrorInterceptorHandler handler;

//     setUp(() {
//       dio = MockDio();
//       connectivity = MockConnectivity();
//       feedbackNotifier = MockFeedbackNotifier();
//       interceptor = RetryOnConnectionChangeInterceptor(
//         dio: dio,
//         connectivity: connectivity,
//         feedbackNotifier: feedbackNotifier,
//       );
//       handler = ErrorInterceptorHandler();
//     });

//     test('should retry request when connectivity is restored', () async {
//       final fakeRequestOptions = RequestOptions(path: '/test');
//       final dioError = DioException(
//         requestOptions: fakeRequestOptions,
//         type: DioExceptionType.connectionTimeout,
//       );
//       // Simuliere: Erst keine Verbindung, dann Verbindung (List<ConnectivityResult>!)
//       var connectivityCallCount = 0;
//       when(connectivity.checkConnectivity()).thenAnswer((_) async {
//         connectivityCallCount++;
//         return connectivityCallCount == 1
//             ? [ConnectivityResult.none]
//             : [ConnectivityResult.wifi];
//       });
//       // Simuliere erfolgreichen Retry
//       final fakeResponse =
//           Response(requestOptions: fakeRequestOptions, data: 'ok');
//       when(dio.request(
//         '/test',
//         data: anyNamed('data'),
//         queryParameters: anyNamed('queryParameters'),
//         options: anyNamed('options'),
//         cancelToken: anyNamed('cancelToken'),
//         onReceiveProgress: anyNamed('onReceiveProgress'),
//         onSendProgress: anyNamed('onSendProgress'),
//       )).thenAnswer((_) async => fakeResponse);
//       bool resolved = false;
//       final handler =
//           TestErrorInterceptorHandler(onResolve: (_) => resolved = true);
//       await interceptor.onError(dioError, handler);
//       expect(resolved, isTrue);
//       verify(dio.request(
//         '/test',
//         data: anyNamed('data'),
//         queryParameters: anyNamed('queryParameters'),
//         options: anyNamed('options'),
//         cancelToken: anyNamed('cancelToken'),
//         onReceiveProgress: anyNamed('onReceiveProgress'),
//         onSendProgress: anyNamed('onSendProgress'),
//       )).called(1);
//     });

//     test('should notify user when no connection', () async {
//       final fakeRequestOptions = RequestOptions(path: '/test');
//       final dioError = DioException(
//         requestOptions: fakeRequestOptions,
//         type: DioExceptionType.connectionTimeout,
//       );
//       // Simuliere: Immer keine Verbindung (List<ConnectivityResult>!)
//       when(connectivity.checkConnectivity())
//           .thenAnswer((_) async => [ConnectivityResult.none]);
//       final handler = TestErrorInterceptorHandler(onResolve: (_) {});
//       await interceptor.onError(dioError, handler);
//       verify(feedbackNotifier.notify(anyThat(
//         isA<FeedbackEvent>()
//             .having((e) => e.message, 'message', contains('Keine Verbindung'))
//             .having((e) => e.type, 'type', FeedbackEventType.snackbar),
//       ))).called(1);
//     });

//     test('should notify user after max retries', () async {
//       // TODO: Implement test logic for feedback after max retries
//     });
//   });
// }

// // Hilfsklasse für Test-Handler
// class TestErrorInterceptorHandler extends ErrorInterceptorHandler {
//   final void Function(Response<dynamic>) onResolve;
//   TestErrorInterceptorHandler({required this.onResolve});
//   @override
//   void resolve(Response response) => onResolve(response);
// }
