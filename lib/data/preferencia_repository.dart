import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/preferencia_service.dart';
import 'package:abaez/domain/preferencia.dart';
import 'package:abaez/exceptions/api_exception.dart';

class PreferenciaRepository {
  final PreferenciaService _preferenciaService = PreferenciaService(); // o new PreferenciaService()

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API
      if (_cachedPreferencias == null) {
        _cachedPreferencias = await _preferenciaService.getPreferencias();
      }

      return _cachedPreferencias!.categoriasSeleccionadas;
    } catch (e) {
      debugPrint('Error al obtener categorías seleccionadas: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        // En caso de error desconocido, devolver lista vacía para no romper la UI
        return [];
      }
    }
  }

  /// Guarda las categorías seleccionadas para filtrar las noticias
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API
      if (_cachedPreferencias == null) {
        _cachedPreferencias = await _preferenciaService.getPreferencias();
      }

      // Actualizar el objeto en caché
      _cachedPreferencias = Preferencia(categoriasSeleccionadas: categoriaIds);

      // Guardar en la API
      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
    } catch (e) {
      debugPrint('Error al guardar categorías seleccionadas: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al guardar preferencias: $e');
      }
    }
  }

  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await guardarCategoriasSeleccionadas(categorias);
      }
    } catch (e) {
      debugPrint('Error al agregar categoría: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al agregar categoría: $e');
      }
    }
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await guardarCategoriasSeleccionadas(categorias);
    } catch (e) {
      debugPrint('Error al eliminar categoría: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al eliminar categoría: $e');
      }
    }
  }

  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    try {
      await guardarCategoriasSeleccionadas([]);

      // Limpiar también la caché
      if (_cachedPreferencias != null) {
        _cachedPreferencias = Preferencia.empty();
      }
    } catch (e) {
      debugPrint('Error al limpiar filtros: $e');
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw ApiException('Error al limpiar filtros: $e');
      }
    }
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    _cachedPreferencias = null;
  }
}
