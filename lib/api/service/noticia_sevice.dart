import 'package:dio/dio.dart';
import 'package:abaez/constantes/constants.dart';
import 'package:abaez/domain/noticia.dart';
import 'dart:convert';

class NoticiaService {
  final Dio dio;

  NoticiaService()
      : dio = Dio(BaseOptions(
          baseUrl: ApiConstants.noticiasUrl,
          connectTimeout: const Duration(seconds: ApiConstants.timeoutSeconds), // Usar Duration
          receiveTimeout: const Duration(seconds: ApiConstants.timeoutSeconds), // Usar Duration
          validateStatus: (status) {
           return status != null && status < 500; // Permite manejar errores 4xx manualmente
  },
        ));
 
  Future<List<Map<String, dynamic>>> obtenerNoticias({
  required int page,
  required int pageSize,
  required bool ordenarPorFecha,
}) async {
  try {
    final response = await dio.get(
      ApiConstants.noticiasUrl, // Usar noticiasEndpoint
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'sortBy': ordenarPorFecha ? 'publishedAt' : 'source.name',
        'language': 'es',
      },
    );

    if (response.statusCode == 200) {
      // Éxito: Devuelve las noticias
      return List<Map<String, dynamic>>.from(response.data['articles']);
    } else {
      // Manejo de errores HTTP
      _handleHttpError(response.statusCode);
    }
  } on DioException catch (e) {
    // Manejo de errores de red
    _handleDioError(e);
  }
  throw Exception('Error desconocido al obtener noticias');
}

void _handleHttpError(int? statusCode) {
  switch (statusCode) {
    case 400:
      throw Exception(AppConstants.mensajeError); // Mensaje de error definido
    case 401:
      throw Exception('No autorizado');
    case 404:
      throw Exception('Noticias no encontradas');
    case 500:
      throw Exception('Error del servidor');
    default:
      throw Exception('Error desconocido: Código de estado $statusCode');
  }
}

void _handleDioError(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    throw Exception(ApiConstants.errorTimeout); // Timeout
  } else if (e.type == DioExceptionType.badResponse) {
    _handleHttpError(e.response?.statusCode); // Manejo de errores HTTP
  } else if (e.type == DioExceptionType.cancel) {
    throw Exception('Solicitud cancelada');
  } else {
    throw Exception('Error desconocido: ${e.message}');
  }
}

  Future<List<Noticia>> listarNoticiasDesdeAPI() async {
  try {
    final response = await dio.get(ApiConstants.noticiasUrl);

    if (response.statusCode == 200) {
      final data = response.data;

      // Imprime la respuesta para inspeccionar su estructura
      //print('Respuesta de la API: $data');

      // Verifica si la respuesta es un String y decodifícala
      final decodedData = data is String ? jsonDecode(data) : data;

      // Verifica si la respuesta es una lista
      if (decodedData is List) {
        // Mapea cada elemento de la lista a un objeto Noticia
        return decodedData.map((json) {
          if (json is Map<String, dynamic>) {
            return Noticia.fromJson(json);
          } else {
            throw Exception('Elemento de la lista no es un Map<String, dynamic>');
          }
        }).toList();
      } else if (decodedData is Map<String, dynamic>) {
        // Si la respuesta es un único objeto JSON, conviértelo en una lista
        return [Noticia.fromJson(decodedData)];
      } else {
        throw Exception('Estructura de respuesta inesperada: $decodedData');
      }
    } else {
      throw Exception('Error al obtener noticias: ${response.statusCode}');
    }
  } on DioException catch (e) {
    _handle4xxError(e); // Manejo de errores 4xx
    throw Exception('Error al conectar con la API: ${e.message}');
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}
 
 Future<Noticia> crearNoticia(Noticia noticia) async {
  try {
    final response = await dio.post(
      ApiConstants.noticiasUrl,
      data: {
        'titulo': noticia.titulo,
        'descripcion': noticia.contenido,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.imagenUrl,
        'categoriaId': noticia.categoriaId, // ID de la categoría asociada
      },
    );

    if (response.statusCode == 201) {
      // Devuelve la noticia creada con el ID generado por el servidor
      final data = response.data;
      final nuevaNoticia = Noticia.fromJson(data);

      // Verifica que la noticia exista en el servidor
      await _verificarNoticiaEnServidor(nuevaNoticia.id);

      return nuevaNoticia;
    } else {
      throw Exception('Error al crear la noticia: ${response.statusCode}');
    }
  } on DioException catch (e) {
    _handle4xxError(e); // Manejo de errores 4xx
    throw Exception('Error al conectar con la API: ${e.message}');
  }
}

Future<void> _verificarNoticiaEnServidor(String id) async {
  final url = '${ApiConstants.noticiasUrl}/$id';
  final response = await dio.get(url);

  if (response.statusCode != 200) {
    throw Exception('La noticia no está disponible en el servidor: ${response.statusCode}');
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
  return ApiConstants.errorServer; // Usar constante para error desconocido
}

Future<void> editarNoticia(Noticia noticia) async {
  final url = '${ApiConstants.noticiasUrl}/${noticia.id}'; // Construye la URL para editar la noticia
  try {
    final response = await dio.put(
      url,
      data: {
        'titulo': noticia.titulo,
        'descripcion': noticia.contenido,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.imagenUrl,
        'categoriaId': noticia.categoriaId,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(ApiConstants.errorServer); // Usar constante para error del servidor
    }
  } catch (e) {
    throw Exception('${ApiConstants.errorServer}: $e'); // Usar constante para error del servidor
  }
}

Future<void> eliminarNoticia(Noticia noticia) async {
  final url = '${ApiConstants.noticiasUrl}/${noticia.id}';
  try {
    final response = await dio.delete(url);

    if (response.statusCode == 405) {
      throw Exception('Método no permitido: Verifica el endpoint o el método HTTP');
    }

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar la noticia: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Error al conectar con la API: ${e.message}');
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}
void handleHttpError(int? statusCode) {
  switch (statusCode) {
    case 401:
      throw Exception(ApiConstants.errorUnauthorized); // Usar constante para error 401
    case 404:
      throw Exception(ApiConstants.errorNotFound); // Usar constante para error 404
    case 500:
      throw Exception(ApiConstants.errorServer); // Usar constante para error 500
    default:
      throw Exception('Error desconocido: Código de estado $statusCode');
  }
}
}