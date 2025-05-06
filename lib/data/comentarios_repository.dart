import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:abaez/domain/comentario.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/exceptions/api_exception.dart';
class ComentarioRepository {
  final Dio dio = Dio();
  final String baseUrl = dotenv.env['NEWS_URL'] ?? 'URL_NO_DEFINIDA';

  final String noticiasEndpoint = '/noticias';
  final String comentariosEndpoint = '/comentarios';

  Future<void> _verificarNoticiaExiste(String noticiaId) async {
    try {
      final response = await dio.get('$baseUrl$noticiasEndpoint/$noticiaId');
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
      final response = await dio.get('$baseUrl$comentariosEndpoint');
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
  Future<void> agregarComentario(String noticiaId, String texto) async {
    await _verificarNoticiaExiste(noticiaId);

    final nuevoComentario = Comentario(
      id: '',
      noticiaId: noticiaId,
      texto: texto,
      fecha: DateTime.now(),
      autor: 'Usuario Anónimo',
    );

    try {
      await dio.post(
        '$baseUrl$comentariosEndpoint',
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
}
