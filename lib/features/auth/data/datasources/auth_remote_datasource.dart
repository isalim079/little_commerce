import 'package:dio/dio.dart';
import 'package:little_commerce/core/constants/api_constants.dart';
import 'package:little_commerce/core/network/api_response.dart';
import 'package:little_commerce/core/network/dio_client.dart';
import 'package:little_commerce/features/auth/data/models/auth_model.dart';

class AuthRemoteDatasource {
  final Dio _dio = DioClient.instance;

  Future<ApiResponse<AuthModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      final auth = AuthModel.fromJson(response.data);
      return ApiResponse.success(auth);

    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('Something went wrong: $e');
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return 'Invalid username or password.';
        return 'Server error: $statusCode';
      default:
        return 'Something went wrong.';
    }
  }
}
