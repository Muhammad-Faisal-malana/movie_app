import 'package:demo_app/core/services/api_config.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {
          'Authorization': 'Bearer ${ApiConfig.token}',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isConnected = await InternetConnection().hasInternetAccess;
          if (!isConnected) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }
          return handler.next(options);
        },
      ),
    );

    return dio;
  }
}
