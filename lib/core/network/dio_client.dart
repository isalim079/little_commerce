
import 'package:dio/dio.dart';
import 'package:little_commerce/core/constants/api_constants.dart';

class DioClient {
  DioClient._(); // private constructor

  static Dio? _dio; // single instance

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(_buildInterceptor());

    return dio;
  }

  static Interceptor _buildInterceptor() {
    return InterceptorsWrapper(
      // Fires before every request
      onRequest: (options, handler) {
        print('REQUEST [${options.method}] => ${options.uri}');
        return handler.next(options);
      },

      // Fires when response comes back
      onResponse: (response, handler) {
        print('RESPONSE [${response.statusCode}] => ${response.requestOptions.uri}');
        return handler.next(response);
      },

      // Fires when any error happens
      onError: (DioException error, handler) {
        print('ERROR [${error.response?.statusCode}] => ${error.message}');
        return handler.next(error);
      },
    );
  }
}
