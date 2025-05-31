// lib/core/utils/validation.dart

T require<T>(T? value, String message) {
  if (value == null) {
    throw Exception("Required value missing: $message");
  }
  return value;
}
