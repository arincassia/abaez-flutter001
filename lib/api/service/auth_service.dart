import 'dart:async';
import 'package:abaez/domain/login_request.dart';
import 'package:abaez/domain/login_response.dart';
import 'package:abaez/api/service/base_service.dart';
import 'package:abaez/exceptions/api_exception.dart';

class AuthService extends BaseService {
  AuthService() : super();
  
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final data = await postUnauthorized(
        '/login',
        data: request.toJson(),   
      );
      
      if (data != null) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException('Error de autenticación: respuesta vacía');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException('Error de conexión: ${e.toString()}');
      }
    }
  }
}
