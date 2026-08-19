import '../../core/utils/app_logger.dart';

class BaseResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  BaseResponse({required this.success, this.data, this.message});

  factory BaseResponse.fromJson(
    dynamic json,
    T? Function(Object? json) fromJsonT,
  ) {
    if (json == null) {
      return BaseResponse(
        success: false,
        message: 'Server returned empty response',
      );
    }

    if (json is! Map<String, dynamic>) {
      AppLogger.e(
        'BaseResponse: Invalid JSON structure. Expected Map, got ${json.runtimeType}',
      );
      return BaseResponse(
        success: false,
        message: 'Server error. Please try again.',
      );
    }

    try {
      final success = json['success'] == true;
      final message = json['message']?.toString();
      T? data;

      try {
        if (json.containsKey('data') && json['data'] != null) {
          data = fromJsonT(json['data']);
        } else {
          // Fallback: try parsing the whole JSON as T if data is missing but success is true
          // This handles cases where the model is the top-level object
          data = fromJsonT(json);
        }
      } catch (parseError) {
        AppLogger.e('BaseResponse: Model parsing failed', parseError);
        return BaseResponse(
          success: false,
          message:
              'Data processing error. Please try again or contact support.',
        );
      }

      return BaseResponse(success: success, data: data, message: message);
    } catch (e) {
      AppLogger.e('BaseResponse: Factory error', e);
      return BaseResponse(success: false, message: 'Something went wrong.');
    }
  }
}
