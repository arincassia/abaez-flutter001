import 'package:shared_preferences/shared_preferences.dart';

class PreferenciaRepository {
  static const String _keyCategoriasSeleccionadas = 'categorias_seleccionadas';

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCategoriasSeleccionadas) ?? [];
  }

  /// Guarda las categorías seleccionadas para filtrar las noticias
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCategoriasSeleccionadas, categoriaIds);
  }

  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    final categorias = await obtenerCategoriasSeleccionadas();
    if (!categorias.contains(categoriaId)) {
      categorias.add(categoriaId);
      await guardarCategoriasSeleccionadas(categorias);
    }
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    final categorias = await obtenerCategoriasSeleccionadas();
    categorias.remove(categoriaId);
    await guardarCategoriasSeleccionadas(categorias);
  }

  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    await guardarCategoriasSeleccionadas([]);
  }
}