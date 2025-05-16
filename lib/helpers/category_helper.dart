import 'package:abaez/domain/categoria.dart';
import 'package:abaez/api/service/category_cache_service.dart';
import 'package:watch_it/watch_it.dart';

/// Utilidad para trabajar con categorías en la aplicación
class CategoryHelper {
  /// Obtiene una categoría por su ID
  /// Usa el caché para minimizar llamadas a la API
  static Future<Categoria?> getCategoryById(String id) async {
    final categoryService = di<CategoryCacheService>();
    try {
      final List<Categoria> categorias = await categoryService.getCategories();
      return categorias.firstWhere(
        (categoria) => categoria.id == id,
        orElse: () => throw Exception('Categoría no encontrada'),
      );
    } catch (e) {
      // Si ocurre un error o la categoría no existe, intentar refrescar la cache
      try {
        await categoryService.refreshCategories();
        final List<Categoria> categorias = await categoryService.getCategories();
        return categorias.firstWhere(
          (categoria) => categoria.id == id,
          orElse: () => throw Exception('Categoría no encontrada'),
        );
      } catch (_) {
        return null; // No se encontró la categoría incluso después de refrescar
      }
    }
  }

  /// Obtiene el nombre de una categoría por su ID
  /// Retorna "Sin categoría" si no se encuentra
  static Future<String> getCategoryName(String id) async {
    if (id.isEmpty) return 'Sin categoría';
    
    final categoria = await getCategoryById(id);
    return categoria?.nombre ?? 'Sin categoría';
  }
  
  /// Verifica si hay categorías en caché
  static bool hasCachedCategories() {
    final categoryService = di<CategoryCacheService>();
    return categoryService.hasCachedCategories;
  }

  /// Fuerza una actualización de las categorías desde la API
  static Future<void> refreshCategories() async {
    final categoryService = di<CategoryCacheService>();
    await categoryService.refreshCategories();
  }
}
