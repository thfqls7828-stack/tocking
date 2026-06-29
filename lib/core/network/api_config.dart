abstract final class ApiConfig {
  static const String baseUrl = 'http://devscv.cafe24.com:8080';

  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration sendTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
