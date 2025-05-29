import 'package:flutter/foundation.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/constants.dart';

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

   void validarEntidad(T entidad);

  /// Método utilitario para manejar excepciones de manera consistente.
  /// Diferencia entre ApiException y otras excepciones, permitiendo un manejo adecuado.
  Future<R> manejarExcepcion<R>(
    Future<R> Function() accion, {
    String mensajeError = 'Error desconocido',
  }) async {
    try {
      return await accion();
    } catch (e) {
      if (e is ApiException) {
        // Propagar ApiException directamente
        rethrow;
      } else {
        // Envolver otras excepciones en ApiException con mensaje contextual
        throw ApiException('$mensajeError: $e');
      }
    }
  }

  /// Valida que un valor no esté vacío y lanza una excepción si lo está.
  void validarNoVacio(String? valor, String nombreCampo) {
    if (valor == null || valor.isEmpty) {
      throw ApiException(
        '$nombreCampo${ValidacionConstantes.campoVacio}',
        statusCode: 400,
      );
    }
  }

  /// Valida que un ID no esté vacío.
  void validarId(String? id) {
    validarNoVacio(id, 'ID');
  }

  /// Valida que una fecha no esté en el futuro
  /// @param fecha La fecha a validar
  /// @param nombreCampo Nombre del campo para el mensaje de error
  /// @param mensajeError Mensaje de error personalizado (opcional)
  void validarFechaNoFutura(DateTime fecha, String nombreCampo) {
    if (fecha.isAfter(DateTime.now())) {
      throw ApiException(
        '$nombreCampo${ValidacionConstantes.noFuturo}',
        statusCode: 400,
      );
    }
  }
}

  
