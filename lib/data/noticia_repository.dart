import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/noticia_sevice.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/exceptions/api_exception.dart';

class NoticiaRepository {
  final NoticiaService _service = NoticiaService();

  /// Obtiene cotizaciones paginadas con validaciones
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      final noticias = await _service.getNoticias();
      return noticias;
    } catch (e) {
      if (e is ApiException) {
        throw e; // Relanza la excepción para que la maneje la capa superior
      }
      debugPrint('Error inesperado al obtener noticias: $e');
      throw ApiException('Error inesperado al obtener noticias.');
    }
  }

  Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required String publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    final noticia = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl,
      'urlImagen': urlImagen,
      'categoriaId': categoriaId,
    };
    try {
      await _service.crearNoticia(noticia);
    } catch (e) {
      if (e is ApiException) {
        throw e;
      }
      debugPrint('Error inesperado al crear noticia: $e');
      throw ApiException('Error inesperado al crear noticia.');
    }
  }

  Future<void> eliminarNoticia(String id) async {
    if (id.isEmpty) {
      throw Exception(
        '${NoticiaConstantes.mensajeError} El ID de la noticia no puede estar vacío.',
      );
    }
    try {
      await _service.eliminarNoticia(id);
    } catch (e) {
      if (e is ApiException) {
        throw e;
      }
      debugPrint('Error inesperado al eliminar noticia: $e');
      throw ApiException('Error inesperado al eliminar noticia.');
    }
  }

  Future<void> actualizarNoticia({
    required String id,
    required String titulo,
    required String descripcion,
    required String fuente,
    required String publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    if (id.isEmpty) {
      throw ApiException('El ID de la noticia no puede estar vacío.');
    }

    if (titulo.isEmpty || descripcion.isEmpty || fuente.isEmpty) {
      throw ApiException(
        'Los campos título, descripción y fuente no pueden estar vacíos.',
      );
    }

    final noticia = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl,
      'urlImagen': urlImagen,
      'categoriaId': categoriaId,
    };
    try {
      await _service.editarNoticia(id, noticia);
    } catch (e) {
      if (e is ApiException) {
        throw e;
      }
      debugPrint('Error inesperado al editar noticia: $e');
      throw ApiException('Error inesperado al editar noticia.');
    }
  }
}