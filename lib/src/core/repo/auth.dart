import '../api/api_client.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiClient _client;

  AuthRepository(this._client);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _client.dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _client.dio.post(
      '/auth/register',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<User> getCurrentUser() async {
    final response = await _client.dio.get('/auth/me');
    return User.fromJson(response.data['user']);
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    await _client.dio.post(
      '/auth/change-password',
      data: request.toJson(),
    );
  }

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    final response = await _client.dio.post(
      '/auth/request-reset',
      data: {'email': email},
    );
    return response.data;
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _client.dio.post(
      '/auth/reset-password',
      data: request.toJson(),
    );
  }

  Future<User> updateProfile({String? name, String? email}) async {
    final response = await _client.dio.patch(
      '/auth/profile',
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      },
    );
    return User.fromJson(response.data['user']);
  }
}
