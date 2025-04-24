import 'package:dio/dio.dart';
import 'package:abaez/constans.dart';
import 'package:abaez/domain/noticia.dart';

class NoticiaRepository {
  final Dio dio = Dio();

  Future<List<Map<String, dynamic>>> obtenerNoticias({
    required int page,
    required int pageSize,
    required bool ordenarPorFecha,
  }) async {
    try {
      final response = await dio.get(
        AppConstants.newsurl,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'sortBy': ordenarPorFecha ? 'publishedAt' : 'source.name',
          'language': 'es',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['articles']);
      } else {
        throw Exception('Error al obtener noticias: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handle4xxError(e); // Manejo de errores 4xx
      throw Exception('Error al conectar con la API: ${e.message}');
    }
  }

  Future<List<Noticia>> listarNoticiasDesdeAPI() async {
    try {
      final response = await dio.get(AppConstants.newsurl);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener noticias: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handle4xxError(e); // Manejo de errores 4xx
      throw Exception('Error al conectar con la API: ${e.message}');
    }
  }

  Future<void> crearNoticia(Noticia noticia) async {
    try {
      final response = await dio.post(
        AppConstants.newsurl,
        data: {
          'titulo': noticia.titulo,
          'descripcion': noticia.contenido,
          'fuente': noticia.fuente,
          'publicadaEl': noticia.publicadaEl.toIso8601String(),
          'urlImagen': noticia.imagenUrl,
        },
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear la noticia: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handle4xxError(e); // Manejo de errores 4xx
      throw Exception('Error al conectar con la API: ${e.message}');
    }
  }

  void _handle4xxError(DioException e) {
    if (e.response?.statusCode != null &&
        e.response!.statusCode! >= 400 &&
        e.response!.statusCode! < 500) {
      final errorMessage = _extractErrorMessage(e.response!.data);
      throw Exception('Error ${e.response?.statusCode}: $errorMessage');
    }
  }

  String _extractErrorMessage(dynamic errorData) {
    if (errorData is Map<String, dynamic>) {
      return errorData['message'] ?? errorData.toString();
    }
    if (errorData is String) {
      return errorData;
    }
    return 'Error desconocido en la operación';
  }

  Future<void> editarNoticia(Noticia noticia) async {
  final url = '${AppConstants.newsurl}/${noticia.id}'; // Construye la URL para editar la noticia
  try {
    final response = await dio.put(
      url,
      data: {
        'titulo': noticia.titulo,
        'descripcion': noticia.contenido,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.imagenUrl,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al editar la noticia: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al conectar con el servidor: $e');
  }
}

  Future<void> eliminarNoticia(String id) async {
  final url = '${AppConstants.newsurl}/$id'; // Construye la URL para eliminar la noticia
  try {
    final response = await dio.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar la noticia: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al conectar con el servidor: $e');
  }
}
}