import 'package:abaez/api/service/auth_service.dart';
import 'package:abaez/helpers/secure_storage_service.dart';
import 'package:abaez/domain/login_response.dart';
import 'package:abaez/domain/login_request.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Login user and store JWT token
  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ArgumentError('Error: Email and password cannot be empty.');
      }
      
      final loginRequest = LoginRequest(
        username: email,
        password: password,
      );
      
      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  // Logout user
  Future<void> logout() async {
    await _secureStorage.clearJwt();
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getJwt();
    return token != null && token.isNotEmpty;
  }
  
  // Get current auth token
  Future<String?> getAuthToken() async {
    return await _secureStorage.getJwt();
  }
}