import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/comentarios_service.dart';
import 'package:abaez/domain/comentario.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/data/base_repository.dart';

// Adaptador para ComentariosService que implementa BaseService
class ComentarioServiceAdapter extends BaseService<Comentario> {
  final ComentariosService _service = ComentariosService();
  
  @override
  Future<List<Comentario>> getAll() {
    // Implementación por defecto que devuelve lista vacía o todos los comentarios
    throw UnimplementedError('Método no aplicable - use obtenerComentariosPorNoticia');
  }
  
  @override
  Future<void> create(dynamic data) {
    // La creación de comentarios necesita parámetros específicos
    throw UnimplementedError('Método no aplicable - use agregarComentario');
  }
  
  @override
  Future<void> update(String id, dynamic data) {
    throw UnimplementedError('Actualización de comentarios no implementada');
  }
  
  @override
  Future<void> delete(String id) {
    throw UnimplementedError('Eliminación de comentarios no implementada');
  }
  
  // Métodos específicos del servicio
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) {
    return _service.obtenerComentariosPorNoticia(noticiaId);
  }
  
  Future<void> agregarComentario(String noticiaId, String texto, String autor, String fecha) {
    return _service.agregarComentario(noticiaId, texto, autor, fecha);
  }
  
  Future<int> obtenerNumeroComentarios(String noticiaId) {
    return _service.obtenerNumeroComentarios(noticiaId);
  }
  
  Future<void> reaccionarComentario({required String comentarioId, required String tipoReaccion}) {
    return _service.reaccionarComentario(comentarioId: comentarioId, tipoReaccion: tipoReaccion);
  }
  
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId, 
    required String texto, 
    required String autor
  }) {
    return _service.agregarSubcomentario(comentarioId: comentarioId, texto: texto, autor: autor);
  }
}

class ComentarioRepository extends BaseRepository<Comentario, ComentarioServiceAdapter> {
  ComentarioRepository() : super(ComentarioServiceAdapter(), 'Comentario');

  /// Obtiene los comentarios asociados a una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    try {
      return await (service).obtenerComentariosPorNoticia(noticiaId);
    } catch (e) {
      throw handleError(e, 'obtener comentarios');
    }
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    if (texto.isEmpty) {
      throw ApiException('El texto del comentario no puede estar vacío.');
    }
    
    try {
      await (service).agregarComentario(
        noticiaId, texto, autor, fecha
      );
    } catch (e) {
      throw handleError(e, 'agregar comentario');
    }
  }

  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      final count = await (service).obtenerNumeroComentarios(noticiaId);
      return count;
    } catch (e) {
      debugPrint('Error al obtener número de comentarios: $e');
      return 0; // En caso de error, retornamos 0 como valor seguro
    }
  }

  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    try {
      await (service).reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      );
    } catch (e) {
      throw handleError(e, 'reaccionar al comentario');
    }
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
  }) async {
    if (texto.isEmpty) {
      return {
        'success': false,
        'message': 'El texto del subcomentario no puede estar vacío.'
      };
    }

    try {
      return await (service).agregarSubcomentario(
        comentarioId: comentarioId,
        texto: texto,
        autor: autor,
      );
    } catch (e) {
      debugPrint('Error inesperado al agregar subcomentario: $e');
      return {
        'success': false,
        'message': 'Error inesperado al agregar subcomentario: ${e.toString()}'
      };
    }
  }
}