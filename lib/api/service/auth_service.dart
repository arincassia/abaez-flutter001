import 'dart:async';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/login_response.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));
  
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${ApiConstantes.newsurl}/auth/login',
        data: {
          'username': email, 
          'password': password,
        },   
      );
      if (response.statusCode == 200 && response.data != null) {
        // Utilizar el mapper para convertir la respuesta JSON en un objeto LoginResponse
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
