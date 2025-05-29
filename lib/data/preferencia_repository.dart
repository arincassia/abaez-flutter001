import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/preferencia_service.dart';
import 'package:abaez/domain/preferencia.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/data/base_repository.dart';

// Adaptador para PreferenciaService
class PreferenciaServiceAdapter extends BaseService<Preferencia> {
  final PreferenciaService _service = PreferenciaService();
  
  @override
  Future<List<Preferencia>> getAll() async {
    final pref = await _service.getPreferencias();
    return [pref]; // Convertimos a lista para compatibilidad con el BaseService
  }
  
  @override
  Future<void> create(dynamic data) {
    return _service.guardarPreferencias(data);
  }
  
  @override
  Future<void> update(String id, dynamic data) {
    return _service.guardarPreferencias(data);
  }
  
  @override
  Future<void> delete(String id) {
    throw UnimplementedError('Eliminación de preferencias no implementada');
  }
  
  // Métodos específicos
  Future<Preferencia> getPreferencias() {
    return _service.getPreferencias();
  }
  
  Future<void> guardarPreferencias(Preferencia preferencia) {
    return _service.guardarPreferencias(preferencia);
  }
}

class PreferenciaRepository extends BaseRepository<Preferencia, PreferenciaServiceAdapter> {
  PreferenciaRepository() : super(PreferenciaServiceAdapter(), 'Preferencia');

    @override
  void validarEntidad(Preferencia preferencia) {
    // Implement validation logic for Preferencia entities
    if (preferencia.categoriasSeleccionadas.isEmpty) {
      throw Exception('Las categorías seleccionadas no pueden estar vacías');
    }
    // Add any other validations specific to Preferencia entities
  }

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await (service).getPreferencias();

      return _cachedPreferencias!.categoriasSeleccionadas;
    } catch (e) {
      debugPrint('Error al obtener categorías seleccionadas: $e');
      if (e is ApiException) {
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
      _cachedPreferencias ??= await (service).getPreferencias();

      // Actualizar el objeto en caché
      _cachedPreferencias = Preferencia(categoriasSeleccionadas: categoriaIds);

      // Guardar en la API
      await (service).guardarPreferencias(_cachedPreferencias!);
    } catch (e) {
      throw handleError(e, 'guardar categorías seleccionadas');
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
      throw handleError(e, 'agregar categoría');
    }
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await guardarCategoriasSeleccionadas(categorias);
    } catch (e) {
      throw handleError(e, 'eliminar categoría');
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
      throw handleError(e, 'limpiar filtros');
    }
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    _cachedPreferencias = null;
  }
}