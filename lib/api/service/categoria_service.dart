import 'package:abaez/constants.dart';
import 'package:abaez/core/api_config.dart';
import 'package:dio/dio.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:flutter/foundation.dart';

class CategoriaService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.beeceptorBaseUrl, // URL base para los endpoints
      connectTimeout: const Duration(
        seconds: CategoriaConstantes.timeoutSeconds,
      ), // Tiempo de conexión
      receiveTimeout: const Duration(
        seconds: CategoriaConstantes.timeoutSeconds,
      ), // Tiempo de recepción
      headers: {
        'Authorization':
            'Bearer ${ApiConfig.beeceptorApiKey}', // Añadir API Key
        'Content-Type': 'application/json',
      },
    ),
  );

  /// Manejo centralizado de errores
  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(CategoriaConstantes.errorTimeout);
    }

    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        throw ApiException(CategoriaConstantes.mensajeError, statusCode: 400);
      case 401:
        throw ApiException(ErrorConstantes.errorUnauthorized, statusCode: 401);
      case 404:
        throw ApiException(ErrorConstantes.errorNotFound, statusCode: 404);
      case 500:
        throw ApiException(ErrorConstantes.errorServer, statusCode: 500);
      default:
        throw ApiException(
          'Error desconocido: ${statusCode ?? 'Sin código'}',
          statusCode: statusCode,
        );
    }
  }

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    try {
      debugPrint(
        '🔍 Obteniendo categorías desde ${ApiConfig.beeceptorBaseUrl}/categorias',
      );
      final response = await _dio.get('/categorias');

      if (response.statusCode == 200) {
        debugPrint(
          '✅ Respuesta de categorías recibida: ${response.statusCode}',
        );

        if (response.data is List) {
          final List<dynamic> categoriasJson = response.data;
          debugPrint('📊 Procesando ${categoriasJson.length} categorías');
          debugPrint('📄 Primer elemento de muestra: ${categoriasJson.isNotEmpty ? categoriasJson.first : "ninguno"}');

          // Filtrar cualquier categoría que no se pueda deserializar correctamente
          List<Categoria> categorias = [];
          for (var json in categoriasJson) {
            try {
              if (json != null && json is Map<String, dynamic>) {
                // CAMBIO IMPORTANTE: Verificar tanto 'id' como '_id' para manejar diferentes formatos de API
                if (json['id'] != null || json['_id'] != null) {
                  // Asegurarse de que siempre haya un 'id' para deserializar correctamente
                  if (json['_id'] != null && json['id'] == null) {
                    json['id'] = json['_id']; // Copiar '_id' a 'id' si solo existe '_id'
                  }
                  categorias.add(Categoria.fromJson(json));
                } else {
                  debugPrint('⚠️ Categoría sin ID ni _id, ignorando: $json');
                }
              }
            } catch (e) {
              debugPrint('❌ Error al deserializar categoría: $e');
              debugPrint('Datos problemáticos: $json');
              // Ignoramos esta categoría y continuamos con la siguiente
            }
          }
          return categorias;
        } else {
          debugPrint('❌ La respuesta no es una lista: ${response.data}');
          throw ApiException(
            'Formato de respuesta inválido',
            statusCode: response.statusCode,
          );
        }
      } else {
        debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
        throw ApiException(
          'Error desconocido',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en getCategorias: ${e.toString()}');
      _handleError(e);
      throw ApiException(
        'Error al obtener categorías',
      ); // Esta línea nunca debería ejecutarse
    } catch (e) {
      debugPrint('❌ Error inesperado en getCategorias: ${e.toString()}');
      if (e is ApiException) {
        rethrow; // Si ya es un ApiException, lo propagamos
      }
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      debugPrint('➕ Creando nueva categoría: $categoria');
      final response = await _dio.post('/categorias', data: categoria);

      debugPrint('✅ Respuesta de creación: ${response.statusCode}');
      if (response.statusCode != 201 && response.statusCode != 200) {
        debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
        throw ApiException(
          'Error desconocido',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en crearCategoria: ${e.toString()}');
      _handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en crearCategoria: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(
    String id,
    Map<String, dynamic> categoria,
  ) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de categoría inválido', statusCode: 400);
      }

      debugPrint('🔄 Editando categoría con ID: $id');
      final response = await _dio.put('/categorias/$id', data: categoria);

      debugPrint('✅ Respuesta de edición: ${response.statusCode}');
      if (response.statusCode != 200 && response.statusCode != 204) {
        debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
        throw ApiException(
          'Error desconocido',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en editarCategoria: ${e.toString()}');
      _handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en editarCategoria: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de categoría inválido', statusCode: 400);
      }

      debugPrint('🗑️ Eliminando categoría con ID: $id');
      final response = await _dio.delete('/categorias/$id');

      debugPrint('✅ Respuesta de eliminación: ${response.statusCode}');
      if (response.statusCode != 200 && response.statusCode != 204) {
        debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
        throw ApiException(
          'Error desconocido',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en eliminarCategoria: ${e.toString()}');
      _handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en eliminarCategoria: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: $e');
    }
  }

/// Obtiene una categoría específica por su ID
Future<Categoria> obtenerCategoriaPorId(String id) async {
  try {
    // Validar que el ID no sea nulo o vacío
    if (id.isEmpty) {
      throw ApiException('ID de categoría inválido', statusCode: 400);
    }

    debugPrint('🔍 Obteniendo categoría con ID: $id');
    final response = await _dio.get('/categorias/$id');

    debugPrint('✅ Respuesta recibida: ${response.statusCode}');
    if (response.statusCode == 200) {
      if (response.data != null && response.data is Map<String, dynamic>) {
        try {
          // CAMBIO IMPORTANTE: Asegurar que exista un campo 'id'
          var respData = Map<String, dynamic>.from(response.data);
          if (respData['_id'] != null && respData['id'] == null) {
            respData['id'] = respData['_id']; // Copiar '_id' a 'id' si solo existe '_id'
          }
          
          return Categoria.fromJson(respData);
        } catch (e) {
          debugPrint('❌ Error al deserializar categoría: $e');
          debugPrint('Datos problemáticos: ${response.data}');
          throw ApiException(
            'Error al procesar la categoría',
            statusCode: response.statusCode,
          );
        }
      } else {
        debugPrint('❌ Respuesta no válida: ${response.data}');
        throw ApiException(
          'Formato de respuesta inválido',
          statusCode: response.statusCode,
        );
      }
    } else {
      debugPrint('❌ Código de estado inesperado: ${response.statusCode}');
      throw ApiException(
        'Error desconocido',
        statusCode: response.statusCode,
      );
    }
  } on DioException catch (e) {
    debugPrint('❌ DioException en obtenerCategoriaPorId: ${e.toString()}');
    _handleError(e);
    throw ApiException(
      'Error al obtener la categoría',
    ); // Esta línea nunca debería ejecutarse
  } catch (e) {
    debugPrint(
      '❌ Error inesperado en obtenerCategoriaPorId: ${e.toString()}',
    );
    if (e is ApiException) {
      rethrow;
    }
    throw ApiException('Error inesperado: $e');
  }
}
}
