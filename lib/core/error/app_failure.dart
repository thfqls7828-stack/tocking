import 'package:dio/dio.dart';

enum AppFailureType { network, timeout, server, cancelled, parsing, unknown }

class AppFailure {
  const AppFailure({
    required this.type,
    required this.message,
    this.statusCode,
  });

  final AppFailureType type;
  final String message;
  final int? statusCode;

  factory AppFailure.fromException(Object error) {
    if (error is DioException) {
      return AppFailure.fromDioException(error);
    }

    if (error is FormatException || error is TypeError) {
      return const AppFailure(
        type: AppFailureType.parsing,
        message: '서버 응답 형식이 올바르지 않습니다.',
      );
    }

    return const AppFailure(
      type: AppFailureType.unknown,
      message: '알 수 없는 오류가 발생했습니다.',
    );
  }

  factory AppFailure.fromDioException(DioException error) {
    return switch (error.type) {
      DioExceptionType.cancel => const AppFailure(
        type: AppFailureType.cancelled,
        message: '요청이 취소되었습니다.',
      ),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const AppFailure(
        type: AppFailureType.timeout,
        message: '서버 응답 시간이 초과되었습니다.',
      ),
      DioExceptionType.badResponse => AppFailure(
        type: AppFailureType.server,
        message: '서버 요청을 처리하지 못했습니다.',
        statusCode: error.response?.statusCode,
      ),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => const AppFailure(
        type: AppFailureType.network,
        message: '네트워크 연결을 확인해주세요.',
      ),
      DioExceptionType.unknown => const AppFailure(
        type: AppFailureType.unknown,
        message: '알 수 없는 오류가 발생했습니다.',
      ),
    };
  }
}
