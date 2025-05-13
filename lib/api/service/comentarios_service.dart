import 'package:dio/dio.dart';
import 'package:abaez/domain/comentario.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/api/service/base_service.dart';
import 'package:flutter/foundation.dart';

class ComentariosService extends BaseService {
  ComentariosService() : super();
  Future<void> _verificarNoticiaExiste(String noticiaId) async {
    try {
      await get('/noticias/$noticiaId');
      // Si la petición es exitosa, la noticia existe
    } on DioException catch (e) {
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error verificando la existencia de noticia: $e');
    }
  }
  /// Obtener comentarios por ID de noticia
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    await _verificarNoticiaExiste(noticiaId);

    try {
      final data = await get('/comentarios');

      final comentarios =
          data
              .where((json) => json['noticiaId'] == noticiaId)
              .map((json) => ComentarioMapper.fromMap(json))
              .toList();

        return comentarios;
      } else {
        debugPrint('❌ La respuesta no es una lista: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en obtenerComentariosPorNoticia: ${e.toString()}');
      handleError(e);
      return []; // Retornar lista vacía en caso de error
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  /// Agrega un comentario nuevo a una noticia existente
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    await _verificarNoticiaExiste(noticiaId);

    final nuevoComentario = Comentario(
      id: '',
      noticiaId: noticiaId,
      texto: texto,
      fecha: DateTime.now().toIso8601String(),
      autor: autor.isNotEmpty ? autor : 'Usuario Anónimo',
      likes: 0,
      dislikes: 0,
      subcomentarios: [],
      isSubComentario: false,
    );

    try {
      await post(
        '/comentarios',
        data: nuevoComentario.toJson(),
      );
      
      debugPrint('✅ Comentario agregado correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en agregarComentario: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      final data = await get('/comentarios');

      if (data is List) {
        final comentariosCount =
          data.where((json) => json['noticiaId'] == noticiaId).length;

        return comentariosCount;
      } else {
        debugPrint('❌ La respuesta no es una lista: $data');
        return 0;
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en obtenerNumeroComentarios: ${e.toString()}');
      // En caso de error simplemente devolvemos 0 para no romper la UI
      return 0;
    } catch (e) {
      debugPrint('❌ Error al obtener número de comentarios: ${e.toString()}');
      return 0;
    }
  }

  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    try {
      // Obtenemos todos los comentarios
      final response = await dio.get(ApiConstantes.comentariosUrl);
      if (response.statusCode != 200) {
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> comentarios = response.data as List<dynamic>;

      // Primero, buscamos si es un comentario principal
      final comentarioIndex = comentarios.indexWhere(
        (c) => c['_id'] == comentarioId,
      );

      // Si lo encontramos como comentario principal
      if (comentarioIndex != -1) {
        Map<String, dynamic> comentarioActualizado = Map<String, dynamic>.from(
          comentarios[comentarioIndex],
        );

        int currentLikes = comentarioActualizado['likes'] ?? 0;
        int currentDislikes = comentarioActualizado['dislikes'] ?? 0;

        await dio.put(
          '${ApiConstantes.comentariosUrl}/$comentarioId',
          data: {
            'noticiaId': comentarioActualizado['noticiaId'],
            'texto': comentarioActualizado['texto'],
            'fecha': comentarioActualizado['fecha'],
            'autor': comentarioActualizado['autor'],
            'likes': tipoReaccion == 'like' ? currentLikes + 1 : currentLikes,
            'dislikes':
                tipoReaccion == 'dislike'
                    ? currentDislikes + 1
                    : currentDislikes,
            'subcomentarios': comentarioActualizado['subcomentarios'] ?? [],
            'isSubComentario':
                comentarioActualizado['isSubComentario'] ?? false,
          },
        );
        return;
      }

      // Recorrer todos los comentarios principales
      for (int i = 0; i < comentarios.length; i++) {
        final comentarioPrincipal = comentarios[i];

        // Verificar si tiene subcomentarios
        if (comentarioPrincipal['subcomentarios'] != null &&
            comentarioPrincipal['subcomentarios'] is List &&
            (comentarioPrincipal['subcomentarios'] as List).isNotEmpty) {
          final List<dynamic> subcomentarios =
              comentarioPrincipal['subcomentarios'];

          // Buscar en los subcomentarios si alguno coincide con el ID
          for (int j = 0; j < subcomentarios.length; j++) {
            final subcomentario = subcomentarios[j];

            // Si encontramos el ID en el subcomentario (puede estar en _id o en idSubComentario)
            if (subcomentario['_id'] == comentarioId ||
                subcomentario['idSubComentario'] == comentarioId) {
              // Crear una copia del subcomentario para actualizarlo
              Map<String, dynamic> subcomentarioActualizado =
                  Map<String, dynamic>.from(subcomentario);

              // Actualizar el contador correspondiente
              int currentLikes = subcomentarioActualizado['likes'] ?? 0;
              int currentDislikes = subcomentarioActualizado['dislikes'] ?? 0;

              subcomentarioActualizado['likes'] =
                  tipoReaccion == 'like' ? currentLikes + 1 : currentLikes;
              subcomentarioActualizado['dislikes'] =
                  tipoReaccion == 'dislike'
                      ? currentDislikes + 1
                      : currentDislikes;

              // Actualizar la lista de subcomentarios
              subcomentarios[j] = subcomentarioActualizado;

              // Actualizar el comentario principal con la nueva lista de subcomentarios
              await dio.put(
                '${ApiConstantes.comentariosUrl}/${comentarioPrincipal['_id']}',
                data: {
                  'noticiaId': comentarioPrincipal['noticiaId'],
                  'texto': comentarioPrincipal['texto'],
                  'fecha': comentarioPrincipal['fecha'],
                  'autor': comentarioPrincipal['autor'],
                  'likes': comentarioPrincipal['likes'] ?? 0,
                  'dislikes': comentarioPrincipal['dislikes'] ?? 0,
                  'subcomentarios': subcomentarios,
                  'isSubComentario':
                      comentarioPrincipal['isSubComentario'] ?? false,
                },
              );

              return;
            }
          }
        }
      }

      throw ApiException(ApiConstantes.errorNotFound, statusCode: 404);
    } on DioException catch (e) {
      print('Error DioException: ${e.toString()}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else if (e.response?.statusCode == 404) {
        print('Error 404: Endpoint no encontrado');
        throw ApiException(ApiConstantes.errorNotFound, statusCode: 404);
      } else {
        print('Error del servidor: ${e.response?.statusCode}');
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      print('Error inesperado: ${e.toString()}');
      throw ApiException(ApiConstantes.errorServer);
    }
  }

  /// Agrega un subcomentario a un comentario existente
  /// Los subcomentarios no pueden tener a su vez subcomentarios
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId, // ID del comentario principal
    required String texto,
    required String autor,
  }) async {
    try {
      final subcomentarioId =
          'sub_${DateTime.now().millisecondsSinceEpoch}_${texto.hashCode}';
      // Primero, obtener el comentario al que queremos añadir un subcomentario
      final response = await dio.get(
        '${ApiConstantes.comentariosUrl}/$comentarioId',
      );
      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'No se pudo encontrar el comentario principal',
        };
      }

      final comentarioData = response.data as Map<String, dynamic>;

      // Verificar si estamos intentando añadir un subcomentario a otro subcomentario
      if (comentarioData['isSubComentario'] == true) {
        // Si no tiene campo de subcomentarios, es probable que estemos intentando
        // añadir un subcomentario a otro subcomentario, lo cual no está permitido
        return {
          'success': false,
          'message':
              'No se pueden añadir subcomentarios a otros subcomentarios',
        };
      }

      // Verificar si ya existe un subcomentario (opcional, puedes permitir múltiples subcomentarios)
      if ((comentarioData['subcomentarios'] as List).isNotEmpty) {
        // Si quieres permitir varios subcomentarios, comenta o elimina esta verificación
        // return {
        //   'success': false,
        //   'message': 'Este comentario ya contiene un subcomentario, no es posible agregar otro'
        // };
      }

      // Crear el nuevo subcomentario explícitamente SIN campo de subcomentarios
      final nuevoSubcomentario = Comentario(
        noticiaId: comentarioData['noticiaId'],
        texto: texto,
        fecha: DateTime.now().toIso8601String(),
        autor: autor,
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: true, // Explícitamente null para evitar anidación
        idSubComentario: subcomentarioId,
      );

      // Obtener la lista actual de subcomentarios o inicializarla
      final List<dynamic> subcomentariosActuales =
          comentarioData['subcomentarios'] as List<dynamic>? ?? [];

      // Añadir el nuevo subcomentario a la lista existente
      final subcomentariosActualizados = [
        ...subcomentariosActuales,
        nuevoSubcomentario.toJson(),
      ];

      // Actualizar el comentario con todos sus subcomentarios
      await dio.put(
        '${ApiConstantes.comentariosUrl}/$comentarioId',
        data: {
          'noticiaId': comentarioData['noticiaId'],
          'texto': comentarioData['texto'],
          'fecha': comentarioData['fecha'],
          'autor': comentarioData['autor'],
          'likes': comentarioData['likes'] ?? 0,
          'dislikes': comentarioData['dislikes'] ?? 0,
          'subcomentarios': subcomentariosActualizados,
          'isSubComentario':
              false, // Asegurarse de que el comentario principal no sea un subcomentario
        },
      );

      return {
        'success': true,
        'message': 'Subcomentario agregado correctamente',
      };
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return {'success': false, 'message': ApiConstantes.errorTimeout};
      } else if (e.response?.statusCode == 404) {
        return {'success': false, 'message': ApiConstantes.errorNotFound};
      } else {
        return {
          'success': false,
          'message': '${ApiConstantes.errorServer}: ${e.toString()}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: ${e.toString()}'};
    }
  }
}
