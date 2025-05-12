import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt_token';

  Future<void> saveJwt(String jwt) async {
    await _storage.write(key: _jwtKey, value: jwt);
  }

  Future<String?> getJwt() async {
    return await _storage.read(key: _jwtKey);
  }

  Future<void> clearJwt() async {
    await _storage.delete(key: _jwtKey);
  }
}
