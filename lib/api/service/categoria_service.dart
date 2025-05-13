import 'package:abaez/constants.dart';
import 'package:abaez/core/api_config.dart';
import 'package:dio/dio.dart';
import 'package:abaez/domain/categoria.dart';

class CategoriaService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.beeceptorBaseUrl, // URL base para los endpoints
    connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds), // Tiempo de conexión
    receiveTimeout: const Duration(seconds:CategoriaConstantes.timeoutSeconds), // Tiempo de recepción
    headers: {
            'Authorization': 'Bearer ${ApiConfig.beeceptorApiKey}', // Añadir API Key
            'Content-Type': 'application/json',
          },
  ));

  /// Manejo centralizado de errores
  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      throw Exception(CategoriaConstantes.errorTimeout);
    }

    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        throw Exception(CategoriaConstantes.mensajeError);
      case 401:
        throw Exception(ErrorConstantes.errorUnauthorized);
      case 404:
        throw Exception(ErrorConstantes.errorNotFound);
      case 500:
        throw Exception(ErrorConstantes.errorServer);
      default:
        throw Exception('Error desconocido: ${statusCode ?? 'Sin código'}');
    }
  }

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _dio.get(ApiConstantes.categoriasUrl);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
    throw Exception('Error desconocido: No se pudo obtener las categorías');
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      final response = await _dio.post(
        ApiConstantes.categoriasUrl,
        data: categoria,
      );

      if (response.statusCode != 201) {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(String id, Map<String, dynamic> categoria) async {
    try {
      final url = '${ApiConstantes.categoriasUrl}/$id';
      final response = await _dio.put(url, data: categoria);

      if (response.statusCode != 200) {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${ApiConstantes.categoriasUrl}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<Categoria> obtenerCategoriaPorId(String id) async {
    try {
      final url = '${ApiConstantes.categoriasUrl}/$id';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return Categoria.fromJson(response.data);
      } else {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
      throw Exception('Error al obtener la categoría'); // Esta línea nunca se ejecutará, pero es necesaria para el compilador
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}