import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/failures.dart';
import '../utils/app_logger.dart';

class ErrorHandler {
  static Failure handleDioError(DioException error) {
    AppLogger.e('Handling Dio Error: ${error.type} | ${error.message}', error);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          'Connection timed out. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final dynamic data = error.response?.data;
        String? serverMessage;

        if (data is Map<String, dynamic>) {
          serverMessage =
              data['message']?.toString() ?? data['error']?.toString();
        }

        switch (statusCode) {
          case 400:
            return ValidationFailure(
              serverMessage ?? 'Invalid request. Please check your data.',
            );
          case 401:
            return AuthFailure(
              serverMessage ?? 'Session expired. Please login again.',
            );
          case 403:
            return ForbiddenFailure(
              serverMessage ??
                  'You do not have permission to perform this action.',
            );
          case 404:
            return NotFoundFailure(serverMessage ?? 'Resource not found.');
          case 409:
            return ConflictFailure(
              serverMessage ?? 'This operation conflicts with current data.',
            );
          case 422:
            return ValidationFailure(
              serverMessage ?? 'The server was unable to process the data.',
            );
          case 429:
            return ServerFailure(
              'Too many requests. Please slow down and try again later.',
            );
          case 500:
            return ServerFailure(
              'Internal server error. We are working on it.',
            );
          case 502:
          case 503:
          case 504:
            return ServerFailure(
              'Server is currently unavailable. Please try again in a few minutes.',
            );
          default:
            return UnknownFailure(
              serverMessage ?? 'Connection error: $statusCode',
            );
        }

      case DioExceptionType.cancel:
        return CancelledFailure('The request was cancelled.');

      case DioExceptionType.connectionError:
        return NetworkFailure(
          'No internet connection. Please check your network.',
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          'Security certificate validation failed. Please ensure your connection is secure.',
        );

      default:
        if (error.error is SocketException) {
          return NetworkFailure(
            'No internet connection. Please check your network.',
          );
        }
        return UnknownFailure();
    }
  }

  static Failure handleGeneralError(Object error) {
    AppLogger.e('Handling General Error: $error');
    if (error is Failure) return error;
    if (error is DioException) {
      return handleDioError(error);
    }
    if (error is SocketException) {
      return NetworkFailure(
        'No internet connection. Please check your network.',
      );
    }
    if (error is FormatException) {
      return UnknownFailure('Invalid data format received from the server.');
    }
    return UnknownFailure('An unexpected error occurred. Please try again.');
  }
}
