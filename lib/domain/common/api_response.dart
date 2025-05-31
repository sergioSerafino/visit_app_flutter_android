// lib/domain/common/api_response.dart
// API-Wrapper (Fehlerbehandlung)

/*
Bonus: Später könnten dort weitere Utilities landen 
wie Result<T>, Failure, ValidationResult, AppStatus, etc.
 */
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';

@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.loading() = Loading<T>;
  const factory ApiResponse.success(T data) = Success<T>;
  const factory ApiResponse.error(String message) = Error<T>;

  // ✅ Methode zur Umwandlung der alten API-Response-Typen in die neue Struktur
  static ApiResponse<T> fromLegacy<T>(dynamic legacyResponse) {
    if (legacyResponse is ApiResponseSuccess<T>) {
      return ApiResponse.success(legacyResponse.data);
    } else if (legacyResponse is ApiResponseError<T>) {
      return ApiResponse.error(legacyResponse.message);
    }
    return const ApiResponse.error("Unbekannter Legacy-Typ");
  }
}

// ✅ Zusätzliche Klassen zur Abwärtskompatibilität
class ApiResponseSuccess<T> {
  final T data;
  const ApiResponseSuccess(this.data);
}

class ApiResponseError<T> {
  final String message;
  const ApiResponseError(this.message);
}

extension ApiResponseX<T> on ApiResponse<T> {
  // 🔹 Kompatible Getter für ältere Code-Stellen
  bool get isSuccess => this is Success<T>;

  T? get data => maybeWhen(success: (data) => data, orElse: () => null);

  String? get errorMessage =>
      maybeWhen(error: (message) => message, orElse: () => null);

  // 🔹 JSON-Support für ältere API-Calls
  Map<String, dynamic> toJson() {
    return maybeWhen(
      success: (data) => {
        "status": "success",
        "data": data is Map<String, dynamic> || data is List
            ? data
            : data?.toString(),
      },
      error: (message) => {"status": "error", "message": message},
      loading: () => {"status": "loading"},
      orElse: () => {"status": "unknown"},
    );
  }
}

/*
      Du willst	                          Du schreibst

      Nur auf Daten zugreifen	            response.data
      Prüfen ob erfolgreich	              response.isSuccess
      Fehlertext holen	                  response.errorMessage
      Direkt Branching machen	            response.when(...)
*/
