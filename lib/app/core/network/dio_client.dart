import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../storage/secure_storage.dart';
import '../constants/api_constants.dart';
import '../services/auth_service.dart';
import '../utils/app_logger.dart';

class DioClient {
  final Dio _dio;
  static bool _isLoggingOut = false;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: Duration(
            milliseconds: ApiConstants.connectTimeout,
          ),
          receiveTimeout: Duration(
            milliseconds: ApiConstants.receiveTimeout,
          ),
          responseType: ResponseType.json,
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage().getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          final filteredHeaders = AppLogger.filterMap(options.headers);
          final filteredData = options.data is Map<String, dynamic> 
              ? AppLogger.filterMap(options.data) 
              : options.data;

          AppLogger.i('REQUEST[${options.method}] => PATH: ${options.path}');
          AppLogger.d('HEADERS: $filteredHeaders');
          if (filteredData != null) AppLogger.d('DATA: $filteredData');
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.i(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          final filteredData = response.data is Map<String, dynamic>
              ? AppLogger.filterMap(response.data)
              : response.data;
          AppLogger.d('RESPONSE BODY: $filteredData');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          AppLogger.e(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path} | TYPE: ${e.type}',
          );
          
          if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
             AppLogger.e('ERROR BODY => ${AppLogger.filterMap(e.response?.data)}');
          }

          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            final path = e.requestOptions.path;
            final isPurchaseSession = path.contains('/metal-purchase-session/');
            
            if (Get.isRegistered<AuthService>() && !isPurchaseSession) {
              if (!_isLoggingOut) {
                _isLoggingOut = true;
                AppLogger.w('Session expired or unauthorized. Logging out...');
                await Get.find<AuthService>().logout();
                _isLoggingOut = false;
              }
              return handler.reject(e);
            }
          }
          
          // Simple Retry Logic for idempotent GET requests on network/timeout errors
          if (e.requestOptions.method == 'GET' && 
              (e.type == DioExceptionType.connectionError || 
               e.type == DioExceptionType.connectionTimeout ||
               e.type == DioExceptionType.receiveTimeout)) {
            
            final int retryCount = e.requestOptions.extra['retry_count'] as int? ?? 0;
            if (retryCount < 2) {
              AppLogger.i('Retrying GET request... Attempt ${retryCount + 1}');
              e.requestOptions.extra['retry_count'] = retryCount + 1;
              
              // Delay before retry
              await Future.delayed(Duration(seconds: 1 * (retryCount + 1)));
              
              try {
                final response = await _dio.fetch(e.requestOptions);
                return handler.resolve(response);
              } catch (retryError) {
                // If retry fails, continue with original error
              }
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
