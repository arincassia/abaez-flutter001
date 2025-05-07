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
        throw ApiException(ApiConstantes.errorNotFound, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else if (e.response?.statusCode == 404) {
        throw ApiException(ApiConstantes.errorNotFound, statusCode: 404);
      } else {
        throw ApiException(ApiConstantes.errorServer, statusCode: e.response?.statusCode);
      }
    }
  }

  /// Obtener comentarios por ID de noticia
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    await _verificarNoticiaExiste(noticiaId);

    try {
      final response = await dio.get(ApiConstantes.comentariosUrl);
      final data = response.data as List<dynamic>;

      final comentarios = data
          .where((json) => json['noticiaId'] == noticiaId)
          .map((json) => Comentario.fromJson(json))
          .toList();

      return comentarios;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else {
        throw ApiException(ApiConstantes.errorServer, statusCode: e.response?.statusCode);
      }
    }
  }

  /// Agrega un comentario nuevo a una noticia existente
  Future<void> agregarComentario(String noticiaId, String texto, String autor, String fecha) async {
    await _verificarNoticiaExiste(noticiaId);

    final nuevoComentario = Comentario(
      id: '',
      noticiaId: noticiaId,
      texto: texto,
      fecha: DateTime.now().toIso8601String(),
      autor: 'Usuario Anónimo',
    );

    try {
      await dio.post(
        ApiConstantes.comentariosUrl,
        data: nuevoComentario.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else {
        throw ApiException(ApiConstantes.errorServer, statusCode: e.response?.statusCode);
      }
    }
  }
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
  try {
    final response = await dio.get(ApiConstantes.comentariosUrl);
    final data = response.data as List<dynamic>;

    final comentariosCount = data
        .where((json) => json['noticiaId'] == noticiaId)
        .length;

    return comentariosCount;
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(ApiConstantes.errorTimeout);
    } else {
      throw ApiException(ApiConstantes.errorServer, statusCode: e.response?.statusCode);
    }
  } catch (e) {
    print('Error al obtener número de comentarios: ${e.toString()}');
    return 0;
  }
}

  /// Registra una reacción (like o dislike) a un comentario
  Future<void> reaccionarComentario({
    required String comentarioId, 
    required String tipoReaccion, 
    required String usuarioId
  }) async {
    if (comentarioId.isEmpty) {
      throw ApiException('El ID del comentario no puede estar vacío', statusCode: 400);
    }
    
    if (tipoReaccion != 'like' && tipoReaccion != 'dislike') {
      throw ApiException('Tipo de reacción inválida. Debe ser "like" o "dislike"', statusCode: 400);
    }
    
    try {
      // Primero obtenemos el comentario actual para verificar que existe
      final response = await dio.get('${ApiConstantes.comentariosUrl}/$comentarioId');
      
      if (response.statusCode != 200) {
        throw ApiException('Comentario no encontrado', statusCode: 404);
      }
      
      // Extraemos los datos del comentario
      final Map<String, dynamic> comentarioData = response.data;
      
      // Inicializamos las listas de reacciones si no existen
      if (!comentarioData.containsKey('likes')) {
        comentarioData['likes'] = <String>[];
      }
      if (!comentarioData.containsKey('dislikes')) {
        comentarioData['dislikes'] = <String>[];
      }
      
      // Convertimos a listas
      List<String> likes = List<String>.from(comentarioData['likes'] ?? []);
      List<String> dislikes = List<String>.from(comentarioData['dislikes'] ?? []);
      
      // Lógica de reacciones
      if (tipoReaccion == 'like') {
        // Si ya dio like, lo quitamos (toggle)
        if (likes.contains(usuarioId)) {
          likes.remove(usuarioId);
        } else {
          // Si dio dislike antes, lo quitamos
          if (dislikes.contains(usuarioId)) {
            dislikes.remove(usuarioId);
          }
          // Agregamos el like
          likes.add(usuarioId);
        }
      } else {
        // Si ya dio dislike, lo quitamos (toggle)
        if (dislikes.contains(usuarioId)) {
          dislikes.remove(usuarioId);
        } else {
          // Si dio like antes, lo quitamos
          if (likes.contains(usuarioId)) {
            likes.remove(usuarioId);
          }
          // Agregamos el dislike
          dislikes.add(usuarioId);
        }
      }
      
      // Actualizamos el comentario con las nuevas reacciones
      comentarioData['likes'] = likes;
      comentarioData['dislikes'] = dislikes;
      
      // Enviamos la actualización
      await dio.put(
        '${ApiConstantes.comentariosUrl}/$comentarioId',
        data: comentarioData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else {
        throw ApiException(
          'Error al procesar la reacción: ${e.message}', 
          statusCode: e.response?.statusCode
        );
      }
    } catch (e) {
      throw ApiException('Error inesperado: ${e.toString()}');
    }
  }
}
