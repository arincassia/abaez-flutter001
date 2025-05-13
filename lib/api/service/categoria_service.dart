import 'package:abaez/domain/categoria.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:abaez/api/service/base_service.dart';

class CategoriaService extends BaseService {
  CategoriaService() : super();
  
  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final data = await get('/categorias');
      
      if (data is List) {
        final List<dynamic> categoriasJson = data;
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
        debugPrint('❌ La respuesta no es una lista: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en getCategorias: ${e.toString()}');
      handleError(e);
      return []; // En caso de error, devolvemos una lista vacía
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en getCategorias: ${e.toString()}');
      throw ApiException('Error al obtener categorías: $e');
    }
  }

  /// Obtiene una categoría por su ID desde la API
  Future<Categoria> obtenerCategoriaPorId(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de categoría inválido', statusCode: 400);
      }
      
      debugPrint('🔍 Buscando categoría con ID: $id');
      
      final data = await get('/categorias/$id');
      
      if (data != null && data is Map<String, dynamic>) {
        try {
          // CAMBIO IMPORTANTE: Verificar tanto 'id' como '_id' para manejar diferentes formatos de API
          if (data['id'] != null || data['_id'] != null) {
            // Asegurarse de que siempre haya un 'id' para deserializar correctamente
            if (data['_id'] != null && data['id'] == null) {
              data['id'] = data['_id']; // Copiar '_id' a 'id' si solo existe '_id'
            }
            return Categoria.fromJson(data);
          } else {
            throw ApiException('Categoría sin identificador válido');
          }
        } catch (e) {
          debugPrint('❌ Error al deserializar categoría: $e');
          throw ApiException('Error al procesar los datos de la categoría');
        }
      } else {
        debugPrint('❌ Respuesta no es un objeto: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en obtenerCategoriaPorId: ${e.toString()}');
      handleError(e);
      throw ApiException('Error al obtener la categoría');
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en obtenerCategoriaPorId: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      debugPrint('➕ Creando nueva categoría');
      debugPrint('📤 Datos a enviar: $categoria');
      
      await post('/categorias', data: categoria);
      
      debugPrint('✅ Categoría creada con éxito');
    } on DioException catch (e) {
      debugPrint('❌ DioException en crearCategoria: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en crearCategoria: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(String id, Map<String, dynamic> categoria) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de categoría inválido', statusCode: 400);
      }

      debugPrint('🔄 Editando categoría con ID: $id');
      await put('/categorias/$id', data: categoria);
      
      debugPrint('✅ Categoría editada correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en editarCategoria: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en editarCategoria: ${e.toString()}');
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
      await delete('/categorias/$id');

      debugPrint('✅ Categoría eliminada correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en eliminarCategoria: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en eliminarCategoria: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
}
