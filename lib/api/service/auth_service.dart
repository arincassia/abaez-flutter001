import 'dart:async';
import 'package:abaez/domain/login_request.dart';
import 'package:abaez/domain/login_response.dart';
import 'package:abaez/api/service/base_service.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'dart:convert';

class AuthService extends BaseService {
  AuthService() : super();
  
 Future<LoginResponse> login(LoginRequest request) async {
  try {
    final data = await post(
      '/login',
      data: request.toJson(),   
    );
    
    if (data != null) {
      // Convertir String a Map si es necesario
      if (data is String) {
        try {
          final Map<String, dynamic> parsedData = jsonDecode(data);
          return LoginResponseMapper.fromMap(parsedData);
        } catch (e) {
          throw ApiException('Error de autenticación: formato inválido');
        }
      } else if (data is Map<String, dynamic>) {
        return LoginResponseMapper.fromMap(data);
      } else {
        throw ApiException('Error de autenticación: formato de respuesta inesperado');
      }
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
