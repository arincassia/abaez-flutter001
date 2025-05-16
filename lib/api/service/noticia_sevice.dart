import 'dart:async';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/base_service.dart';

class NoticiaService extends BaseService {
  NoticiaService() : super();

  /// Obtiene todas las noticias de la API
  Future<List<Noticia>> getNoticias() async {
    try {

      final data = await get('/noticias', requireAuthToken: false);

      
      // Verificamos que la respuesta sea una lista
      if (data is List) {
        final List<dynamic> noticiasJson = data;
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
        debugPrint('❌ La respuesta no es una lista: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
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
    
      await put(
        '/noticias/$id',
        data: noticiaJson,
        requireAuthToken: true,
      );
      
      debugPrint('✅ Noticia editada correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en editarNoticia: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
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
      
      await post(
        '/noticias',
        data: noticiaJson,
        requireAuthToken: true,
      );
      
      debugPrint('✅ Noticia creada con éxito');
    } on DioException catch (e) {
      debugPrint('❌ DioException en crearNoticia: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
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
      
      await delete('/noticias/$id', requireAuthToken: true);

      debugPrint('✅ Noticia eliminada correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en eliminarNoticia: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en eliminarNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
}
