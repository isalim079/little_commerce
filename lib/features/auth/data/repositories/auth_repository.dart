import 'package:little_commerce/core/network/api_response.dart';
import 'package:little_commerce/core/services/storage_service.dart';
import 'package:little_commerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:little_commerce/features/auth/data/models/auth_model.dart';

class AuthRepository {
  final AuthRemoteDatasource _datasource = AuthRemoteDatasource();

  Future<ApiResponse<AuthModel>> login({
    required String username,
    required String password,
  }) async {
    final response = await _datasource.login(
      username: username,
      password: password,
    );

    // If login successful, save token immediately
    if (response.isSuccess) {
      await StorageService.saveToken(response.data!.token);
    }

    return response;
  }

  Future<void> logout() async {
    await StorageService.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    return await StorageService.isLoggedIn();
  }
}