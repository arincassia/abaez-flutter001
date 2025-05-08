import 'package:dio/dio.dart';
import 'package:abaez/domain/comentario.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ComentariosService {
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
      subcomentarios: [], // Inicializar como lista vacía
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
  
  /// Agrega un subcomentario a un comentario existente
  /// Los subcomentarios no pueden tener a su vez subcomentarios
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId, // ID del comentario principal
    required String texto,
    required String autor,
  }) async {
    try {
      // Primero, obtener el comentario al que queremos añadir un subcomentario
      final response = await dio.get('${ApiConstantes.comentariosUrl}/$comentarioId');
      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'No se pudo encontrar el comentario principal'
        };
      }
      
      final comentarioData = response.data as Map<String, dynamic>;
      
      // Verificar si estamos intentando añadir un subcomentario a otro subcomentario
      if (comentarioData['subcomentarios'] == null) {
        // Si no tiene campo de subcomentarios, es probable que estemos intentando 
        // añadir un subcomentario a otro subcomentario, lo cual no está permitido
        return {
          'success': false,
          'message': 'No se pueden añadir subcomentarios a otros subcomentarios'
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
        id: '', // El ID será asignado por el servidor
        noticiaId: comentarioData['noticiaId'],
        texto: texto,
        fecha: DateTime.now().toIso8601String(),
        autor: autor,
        likes: 0,
        dislikes: 0,
        subcomentarios: null, // Explícitamente null para evitar anidación
      );
      
      // Obtener la lista actual de subcomentarios o inicializarla
      final List<dynamic> subcomentariosActuales = 
          comentarioData['subcomentarios'] as List<dynamic>? ?? [];
      
      // Añadir el nuevo subcomentario a la lista existente
      final subcomentariosActualizados = [
        ...subcomentariosActuales,
        nuevoSubcomentario.toJson()
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
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      
      return {
        'success': true,
        'message': 'Subcomentario agregado correctamente'
      };
      
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return {
          'success': false,
          'message': ApiConstantes.errorTimeout
        };
      } else if (e.response?.statusCode == 404) {
        return {
          'success': false,
          'message': ApiConstantes.errorNotFound
        };
      } else {
        return {
          'success': false,
          'message': '${ApiConstantes.errorServer}: ${e.toString()}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}'
      };
    }
  }
}

