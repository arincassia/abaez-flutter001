import 'package:flutter/foundation.dart';
import 'package:abaez/exceptions/api_exception.dart';

/// Interfaz genérica para servicios
abstract class BaseService<T> {
  Future<List<T>> getAll();
  Future<void> create(dynamic data);
  Future<void> update(String id, dynamic data);
  Future<void> delete(String id);
}

/// Repositorio base genérico que implementa las operaciones CRUD comunes
abstract class BaseRepository<T, S extends BaseService<T>> {
  final S service;
  final String entityName;
  
  BaseRepository(this.service, this.entityName);
  
  /// Método genérico para obtener todos los elementos
  Future<List<T>> getAll() async {
    try {
      final items = await service.getAll();
      return items;
    } catch (e) {
      return handleError(e, 'obtener ${entityName}s');
    }
  }

  /// Método genérico para crear un elemento
  Future<void> create(dynamic data) async {
    try {
      await service.create(data);
      debugPrint('$entityName creado exitosamente.');
    } catch (e) {
      handleError(e, 'crear $entityName');
    }
  }

  /// Método genérico para actualizar un elemento
  Future<void> update(String id, dynamic data) async {
    try {
      await service.update(id, data);
      debugPrint('$entityName con ID $id actualizado exitosamente.');
    } catch (e) {
      handleError(e, 'actualizar $entityName $id');
    }
  }

  /// Método genérico para eliminar un elemento
  Future<void> delete(String id) async {
    if (id.isEmpty) {
      throw Exception('El ID del $entityName no puede estar vacío.');
    }
    
    try {
      await service.delete(id);
      debugPrint('$entityName con ID $id eliminado exitosamente.');
    } catch (e) {
      handleError(e, 'eliminar $entityName $id');
    }
  }
  
  /// Método para manejar errores de manera consistente
  dynamic handleError(dynamic e, String operacion) {
    if (e is ApiException) {
      return e;
    }
    debugPrint('Error inesperado al $operacion: $e');
    throw ApiException('Error inesperado al $operacion.');
  }
}