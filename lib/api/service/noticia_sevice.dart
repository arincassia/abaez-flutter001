import 'dart:async';
import 'package:abaez/core/api_config.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/error_helper.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';
import 'package:flutter/foundation.dart';

class NoticiaService {
  final Dio _dioNew = Dio(BaseOptions(
    baseUrl: ApiConfig.beeceptorBaseUrl, // URL base para los endpoints
    connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds), // Tiempo de conexión
    receiveTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds), // Tiempo de recepción
    headers: {
      'Authorization': 'Bearer ${ApiConfig.beeceptorApiKey}', // Añadir API Key
      'Content-Type': 'application/json',
    },
  ));
 
  /// Obtiene todas las noticias de la API
  Future<List<Noticia>> getNoticias() async {
    try {
      debugPrint('🔍 Obteniendo noticias desde ${ApiConfig.beeceptorBaseUrl}/noticias');
      final response = await _dioNew.get('/noticias');

      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      
      // Maneja el código de estado HTTP
      if (response.statusCode == 200) {
        // Verificamos que la respuesta sea una lista
        if (response.data is List) {
          final List<dynamic> noticiasJson = response.data;
          debugPrint('📊 Procesando ${noticiasJson.length} noticias');
          
          return noticiasJson.map((json) {
            try {
              return Noticia.fromJson(json);
            } catch (e) {
              debugPrint('❌ Error al deserializar noticia: $e');
              debugPrint('Datos problemáticos: $json');
              // Retornar null y luego filtrar los nulos
              return null;
            }
          }).where((noticia) => noticia != null).cast<Noticia>().toList();
        } else {
          debugPrint('❌ La respuesta no es una lista: ${response.data}');
          throw ApiException('Formato de respuesta inválido', statusCode: response.statusCode);
        }
      } else {
        debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException: ${e.toString()}');
      debugPrint('Tipo: ${e.type}, Mensaje: ${e.message}');
      debugPrint('URL: ${e.requestOptions.uri}');
      
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      debugPrint('❌ Error inesperado: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Edita una noticia en la API
  Future<void> editarNoticia(String id, Noticia noticia) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de noticia inválido', statusCode: 400);
      }
      
      debugPrint('🔄 Editando noticia con ID: $id');
      
      // Convertir el objeto Noticia a JSON utilizando el método generado
      Map<String, dynamic> noticiaJson = noticia.toJson();
      debugPrint('📤 Datos a enviar: $noticiaJson');
    
      final response = await _dioNew.put(
        '/noticias/$id',
        data: noticiaJson,
      );

      debugPrint('✅ Respuesta de edición: ${response.statusCode}');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en editarNoticia: ${e.toString()}');
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      debugPrint('❌ Error inesperado en editarNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Crea una nueva noticia en la API
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      debugPrint('➕ Creando nueva noticia');
      
      // Convertir el objeto Noticia a JSON utilizando el método generado
      Map<String, dynamic> noticiaJson = noticia.toJson();
      debugPrint('📤 Datos a enviar: $noticiaJson');
      
      final response = await _dioNew.post(
        '/noticias',
        data: noticiaJson,
      );

      debugPrint('✅ Respuesta de creación: ${response.statusCode}');
      
      if (response.statusCode != 201 && response.statusCode != 200) {
        debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en crearNoticia: ${e.toString()}');
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      debugPrint('❌ Error inesperado en crearNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Elimina una noticia de la API
  Future<void> eliminarNoticia(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de noticia inválido', statusCode: 400);
      }
      
      debugPrint('🗑️ Eliminando noticia con ID: $id');
      
      final response = await _dioNew.delete('/noticias/$id');

      debugPrint('✅ Respuesta de eliminación: ${response.statusCode}');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en eliminarNoticia: ${e.toString()}');
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      debugPrint('❌ Error inesperado en eliminarNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
}



