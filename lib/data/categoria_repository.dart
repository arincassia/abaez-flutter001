import 'package:abaez/domain/categoria.dart';
import 'package:abaez/constans.dart'; 
import 'package:dio/dio.dart';
import 'package:abaez/exceptions/api_exception.dart';

class CategoriaRepository {
  final Dio dio;

  CategoriaRepository()
      : dio = Dio(BaseOptions(
          baseUrl: ApiConstants.categoriasUrl,
          connectTimeout: const Duration(seconds: ApiConstants.timeoutSeconds), 
          receiveTimeout: const Duration(seconds: ApiConstants.timeoutSeconds), 
        ));
        
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      final response = await dio.get(ApiConstants.categoriasUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        _handleHttpError(response.statusCode, response.data);
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw ApiException(ApiConstants.errorServer);
  }

  Future<List<Categoria>> listarCategoriasDesdeAPI() async {
    try {
      final response = await dio.get(ApiConstants.categoriasUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        _handleHttpError(response.statusCode, response.data);
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw ApiException(ApiConstants.errorServer);
  }

  void _handleHttpError(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        throw ApiException('Petición incorrecta', statusCode: 400);
      case 401:
        throw ApiException(ApiConstants.errorUnauthorized, statusCode: 401);
      case 404:
        throw ApiException(ApiConstants.errorNoCategory, statusCode: 404);
      case 500:
        throw ApiException(ApiConstants.errorServer, statusCode: 500);
      default:
        throw ApiException('Error desconocido: Código de estado $statusCode', statusCode: statusCode);
    }
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(ApiConstants.errorTimeout, statusCode: 408);
    } else if (e.type == DioExceptionType.badResponse) {
      _handleHttpError(e.response?.statusCode, e.response?.data);
    } else if (e.type == DioExceptionType.cancel) {
      throw ApiException('Error: Solicitud cancelada');
    } else {
      throw ApiException('${ApiConstants.errorServer}: ${e.message}');
    }
  }

   Future<List<Categoria>> getCategorias() async {
    try {
      final response = await dio.get(ApiConstants.categoriasUrl);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Error al obtener las categorías',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<Categoria> crearCategoria(Categoria categoria) async {
  try {
    final response = await dio.post(
      ApiConstants.categoriasUrl, // URL del endpoint para categorías
      data: {
        'nombre': categoria.nombre,
        'descripcion': categoria.descripcion,
        'imagenUrl': categoria.imagenUrl ?? '',
      },
    );

    if (response.statusCode == 201) {
      // Devuelve la categoría creada con el ID generado por el servidor
      final data = response.data;
      final nuevaCategoria = Categoria.fromJson(data);

      // Verifica que la categoría exista en el servidor
      await _verificarCategoriaEnServidor(nuevaCategoria.id);

      return nuevaCategoria;
    } else {
      throw Exception('Error al crear la categoría: ${response.statusCode}');
    }
  } on DioException catch (e) {
    _handle4xxError(e); // Manejo de errores 4xx
    throw Exception('Error al conectar con la API: ${e.message}');
  }
}

Future<void> _verificarCategoriaEnServidor(String id) async {
  final url = '${ApiConstants.categoriasUrl}/$id';
  final response = await dio.get(url);

  if (response.statusCode != 200) {
    throw Exception('La categoría no está disponible en el servidor: ${response.statusCode}');
  }
}
  /// Edita una categoría existente en la API
  Future<void> editarCategoria(Categoria categoria) async {
  final url = '${ApiConstants.categoriasUrl}/${categoria.id}'; // Construye la URL para editar la categoría
  try {
    final response = await dio.put(
      url,
      data: {
        'nombre': categoria.nombre,
        'descripcion': categoria.descripcion, // Proporciona un valor predeterminado si es null
        'imagenUrl': categoria.imagenUrl ?? '', // Proporciona un valor predeterminado si es null
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(ApiConstants.errorServer); // Usar constante para error del servidor
    }
  } on DioException catch (e) {
    throw Exception('${ApiConstants.errorServer}: ${e.message}'); // Usar constante para error del servidor
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}
  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${ApiConstants.categoriasUrl}/$id';
      final response = await dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Error al eliminar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  void _handle4xxError(DioException e) {
  if (e.response?.statusCode != null &&
      e.response!.statusCode! >= 400 &&
      e.response!.statusCode! < 500) {
    final errorMessage = _extractErrorMessage(e.response!.data);
    throw ApiException('Error ${e.response?.statusCode}: $errorMessage');
  }
}

String _extractErrorMessage(dynamic errorData) {
  if (errorData is Map<String, dynamic>) {
    return errorData['message'] ?? errorData.toString();
  }
  if (errorData is String) {
    return errorData;
  }
  return 'Error desconocido del servidor';
}

 Future<Categoria> obtenerCategoriaPorId(String categoriaId) async {
    try {
      final response = await dio.get('${ApiConstants.categoriasUrl}/$categoriaId');
      if (response.statusCode == 200) {
        return Categoria.fromJson(response.data);
      } else {
        throw Exception('Error al obtener la categoría: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}