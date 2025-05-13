import 'dart:async';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/core/api_config.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/error_helper.dart';
import 'package:abaez/helpers/secure_storage_service.dart';
import 'package:flutter/foundation.dart';

/// Clase base para todos los servicios de la API.
/// Proporciona configuración común y manejo de errores centralizado.
class BaseService {
  /// Cliente HTTP Dio
  late final Dio _dio;
  
  /// Servicio para almacenamiento seguro
  final SecureStorageService _secureStorage = SecureStorageService();
  
  /// Constructor
  BaseService() {
    _initializeDio();
  }
  
  /// Inicializa el cliente Dio con configuraciones comunes
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.beeceptorBaseUrl,
      connectTimeout: const Duration(seconds: ApiConstantes.timeoutSeconds),
      receiveTimeout: const Duration(seconds: ApiConstantes.timeoutSeconds),
      headers: {
        'Authorization': 'Bearer ${ApiConfig.beeceptorApiKey}',
        'Content-Type': 'application/json',
      },
    ));
    
    // // Interceptor para añadir el token JWT a cada solicitud
    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     await _addAuthToken(options, handler);
    //   },
    // ));
  }
  
  /// Añade el token de autenticación a las solicitudes
  Future<void> _addAuthToken(RequestOptions options, RequestInterceptorHandler handler) async {
    final jwt = await _secureStorage.getJwt();
    if (jwt != null && jwt.isNotEmpty) {
      options.headers['X-Auth-Token'] = jwt;
      handler.next(options);
    } else {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'No se encontró el token de autenticación',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
  
  /// Manejo centralizado de errores para servicios
  void handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(ApiConstantes.errorTimeout);
    }

    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        throw ApiException('Solicitud incorrecta', statusCode: 400);
      case 401:
        throw ApiException(ApiConstantes.errorUnauthorized, statusCode: 401);
      case 404:
        throw ApiException(ApiConstantes.errorNotFound, statusCode: 404);
      case 500:
        throw ApiException(ApiConstantes.errorServer, statusCode: 500);
      default:
        final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
        throw ApiException(
          errorData['message'] ?? 'Error desconocido: ${statusCode ?? 'Sin código'}',
          statusCode: statusCode,
        );
    }
  }
  
  /// Método GET genérico
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      debugPrint('🔍 GET: ${ApiConfig.beeceptorBaseUrl}$path');
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      
      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      debugPrint('❌ DioException en GET $path: ${e.toString()}');
      debugPrint('URL: ${e.requestOptions.uri}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en GET $path: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  
  /// Método POST genérico
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      debugPrint('📤 POST: ${ApiConfig.beeceptorBaseUrl}$path');
      final response = await _dio.post(
        path,
        data: data,
      );
      
      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      debugPrint('❌ DioException en POST $path: ${e.toString()}');
      debugPrint('URL: ${e.requestOptions.uri}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en POST $path: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  
  /// Método PUT genérico
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      debugPrint('📝 PUT: ${ApiConfig.beeceptorBaseUrl}$path');
      final response = await _dio.put(
        path,
        data: data,
      );
      
      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      debugPrint('❌ DioException en PUT $path: ${e.toString()}');
      debugPrint('URL: ${e.requestOptions.uri}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en PUT $path: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  
  /// Método DELETE genérico
  Future<dynamic> delete(String path) async {
    try {
      debugPrint('🗑️ DELETE: ${ApiConfig.beeceptorBaseUrl}$path');
      final response = await _dio.delete(path);
      
      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      debugPrint('❌ DioException en DELETE $path: ${e.toString()}');
      debugPrint('URL: ${e.requestOptions.uri}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en DELETE $path: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  
  /// Acceso protegido al cliente Dio para casos especiales
  Dio get dio => _dio;
}
