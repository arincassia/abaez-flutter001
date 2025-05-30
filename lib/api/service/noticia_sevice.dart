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

  /// Elimina una noticia de la API junto con todos sus reportes y comentarios asociados
Future<void> eliminarNoticia(String id) async {
  try {
    // Validar que el ID no sea nulo o vacío
    if (id.isEmpty) {
      throw ApiException('ID de noticia inválido', statusCode: 400);
    }
    
    debugPrint('🗑️ Iniciando eliminación de noticia con ID: $id y sus datos asociados');
    
    // 1. Primero obtenemos y eliminamos los reportes asociados
    try {
      debugPrint('🔍 Buscando reportes asociados a la noticia $id');
      final reportes = await get('/reportes', requireAuthToken: true);
      
      if (reportes is List) {
        // Filtrar reportes por noticiaId
        final reportesDeNoticia = reportes.where((reporte) => 
          reporte is Map && reporte['noticiaId'] == id).toList();
          
        if (reportesDeNoticia.isNotEmpty) {
          debugPrint('🚨 Encontrados ${reportesDeNoticia.length} reportes para eliminar');
          
          for (final reporte in reportesDeNoticia) {
            final reporteId = reporte['id'];
            await delete('/reportes/$reporteId', requireAuthToken: true);
            debugPrint('✅ Reporte $reporteId eliminado');
          }
        } else {
          debugPrint('ℹ️ No se encontraron reportes para esta noticia');
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error al eliminar reportes: $e');
      // Continuamos con el proceso aunque falle la eliminación de reportes
    }

    // Añadir después de la eliminación de reportes

// 2. Luego obtenemos y eliminamos los comentarios y subcomentarios asociados
try {
  debugPrint('🔍 Buscando comentarios asociados a la noticia $id');
  final comentarios = await get('/comentarios', requireAuthToken: true);
  
  if (comentarios is List) {
    // Paso 1: Identificar todos los comentarios principales de la noticia
    final comentariosDeNoticia = comentarios.where((comentario) => 
      comentario is Map && comentario['noticiaId'] == id).toList();
    
    // Paso 2: Extraer y eliminar subcomentarios anidados
    for (final comentario in comentariosDeNoticia) {
      if (comentario['subcomentarios'] != null && comentario['subcomentarios'] is List) {
        final subcomentarios = comentario['subcomentarios'] as List;
        
        if (subcomentarios.isNotEmpty) {
          debugPrint('📝 Encontrados ${subcomentarios.length} subcomentarios para el comentario ${comentario['id']}');
          
          // Eliminar cada subcomentario
          for (final subcomentario in subcomentarios) {
            final subcomentarioId = subcomentario['idSubComentario'];
            await delete('/comentarios/sub/$subcomentarioId', requireAuthToken: true);
            debugPrint('✅ Subcomentario $subcomentarioId eliminado');
          }
        }
      }
    }
    
    // Paso 3: Eliminar los comentarios principales
    if (comentariosDeNoticia.isNotEmpty) {
      debugPrint('📝 Eliminando ${comentariosDeNoticia.length} comentarios principales');
      
      for (final comentario in comentariosDeNoticia) {
        final comentarioId = comentario['id'];
        await delete('/comentarios/$comentarioId', requireAuthToken: true);
        debugPrint('✅ Comentario principal $comentarioId eliminado');
      }
    }
  }
} catch (e) {
  debugPrint('⚠️ Error al eliminar comentarios y subcomentarios: $e');
}

// 3. Finalmente eliminamos la noticia
try {
  await delete('/noticias/$id', requireAuthToken: true);
  debugPrint('✅ Noticia eliminada correctamente junto con sus datos asociados');
} catch (e) {
  debugPrint('❌ Error al eliminar la noticia: $e');
  throw ApiException('Error al eliminar la noticia: $e');
}
    debugPrint('🗑️ Eliminación de noticia y datos asociados completada');
  } catch (e) {
    if (e is ApiException) {
      rethrow;
    }
    debugPrint('❌ Error inesperado en eliminarNoticia: ${e.toString()}');
    throw ApiException('Error inesperado: $e');
  }
}

}