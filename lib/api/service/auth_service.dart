import 'dart:async';
import 'package:abaez/domain/login_request.dart';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/login_response.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstantes.loginUrl,
        data: request.toJson(),   
      );
      if (response.statusCode == 200 && response.data != null) {
        return LoginResponseMapper.fromMap(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Authentication error',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data['message'] ?? 'Authentication error'}');
      } else {
        throw Exception('Connection error: ${e.message}');
      }
    }
  }
}
