import 'package:dio/dio.dart';
import 'package:abaez/domain/comentario.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ComentarioRepository {
  final Dio dio = Dio();

  Future<void> _verificarNoticiaExiste(String noticiaId) async {
    try {
      //final response = await dio.get('$baseUrl$noticiasEndpoint/$noticiaId');
      final response = await dio.get('${ApiConstantes.newsurl}/$noticiaId');
      if (response.statusCode != 200) {
        throw ApiException(
          ApiConstantes.errorNotFound,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else if (e.response?.statusCode == 404) {
        throw ApiException(ApiConstantes.errorNotFound, statusCode: 404);
      } else {
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: e.response?.statusCode,
        );
      }
    }
  }

  /// Obtener comentarios por ID de noticia
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    await _verificarNoticiaExiste(noticiaId);

    try {
      final response = await dio.get(ApiConstantes.comentariosUrl);
      final data = response.data as List<dynamic>;

      final comentarios =
          data
              .where((json) => json['noticiaId'] == noticiaId)
              .map((json) => Comentario.fromJson(json))
              .toList();

      return comentarios;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else {
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: e.response?.statusCode,
        );
      }
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
      autor: 'Usuario Anónimo',
      likes: 0,
      dislikes: 0,
    );

    try {
      await dio.post(
        ApiConstantes.comentariosUrl,
        data: nuevoComentario.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else {
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: e.response?.statusCode,
        );
      }
    }
  }

  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      final response = await dio.get(ApiConstantes.comentariosUrl);
      final data = response.data as List<dynamic>;

      final comentariosCount =
          data.where((json) => json['noticiaId'] == noticiaId).length;

      return comentariosCount;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else {
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      print('Error al obtener número de comentarios: ${e.toString()}');
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

      // Buscamos el comentario específico por ID (usando '_id' en lugar de 'id')
      final comentarioIndex = comentarios.indexWhere(
        (c) => c['_id'] == comentarioId,
      );

      if (comentarioIndex == -1) {
        print('Comentario no encontrado con ID: $comentarioId');
        throw ApiException(ApiConstantes.errorNotFound, statusCode: 404);
      }

      // Construimos el comentario actualizado
      Map<String, dynamic> comentarioActualizado = Map<String, dynamic>.from(
        comentarios[comentarioIndex],
      );
      print(comentarioActualizado);
      // Actualizamos los likes o dislikes según el tipo de reacción
     

      /*print(
        'Actualizando comentario: ${comentarioActualizado['_id']} con $tipoReaccion',
      );*/

      // IMPORTANTE: Al enviar al servidor, usamos el ID específico del comentario con '_id'
      int currentLikes = comentarioActualizado['likes'] ?? 0;
      int currentDislikes = comentarioActualizado['dislikes'] ?? 0;
      await dio.put(
      '${ApiConstantes.comentariosUrl}/$comentarioId',
        data: {
          'id': comentarioId,
          'noticiaId': comentarioActualizado['noticiaId'],
          'texto': comentarioActualizado['texto'],
          'fecha': comentarioActualizado['fecha'],
          'autor': comentarioActualizado['autor'],
          'likes': tipoReaccion == 'like' ? currentLikes + 1 : currentLikes,
          'dislikes': tipoReaccion == 'dislike' ? currentDislikes + 1 : currentDislikes,
        },
      );
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
  
}

  /// Registra una reacción (like o dislike) a un comentario

