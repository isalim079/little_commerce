
import 'package:dio/dio.dart';
import 'package:little_commerce/core/constants/api_constants.dart';
import 'package:little_commerce/core/services/storage_service.dart';

class DioClient {
  DioClient._();

  static Dio? _dio;

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

    dio.interceptors.add(_buildInterceptor());
    return dio;
  }

  static Interceptor _buildInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('REQUEST [${options.method}] => ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
          'RESPONSE [${response.statusCode}] => '
          '${response.requestOptions.uri}',
        );
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        print('ERROR [${error.response?.statusCode}] => ${error.message}');
        return handler.next(error);
      },
    );
  }
}
