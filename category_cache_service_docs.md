# CategoryCacheService

## Descripción
Un servicio singleton para mantener en caché las categorías de la aplicación. Este servicio
permite reducir las llamadas a la API, mejorando el rendimiento de la aplicación.

## Características
- Implementación de patrón Singleton
- Almacenamiento en caché de categorías
- Métodos para refrescar datos desde API
- Control del tiempo de actualización
- Integrado con el sistema de inyección de dependencias

## Métodos principales

### getCategories()
Retorna la lista actual de categorías almacenadas en caché. Si la caché está vacía,
automáticamente realiza una llamada a la API para obtener los datos.

```dart
final categoryService = di<CategoryCacheService>();
final List<Categoria> categorias = await categoryService.getCategories();
```

### refreshCategories()
Fuerza la actualización de las categorías desde la API, refrescando la caché.

```dart
final categoryService = di<CategoryCacheService>();
await categoryService.refreshCategories();
```

## Uso recomendado
- Usar CategoryCacheService en lugar de llamadas directas al repositorio cuando se necesiten categorías.
- Refrescar las categorías al iniciar la aplicación o cuando se realizan cambios en ellas.
- Verificar el estado de la caché usando las propiedades `hasCachedCategories` y `lastRefreshed`.

## Ejemplo de implementación en un Bloc
```dart
class MiBloc extends Bloc<MiEvent, MiState> {
  final CategoryCacheService _categoryService = di<CategoryCacheService>();
  
  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<MiState> emit) async {
    emit(LoadingState());
    try {
      final categorias = await _categoryService.getCategories();
      emit(LoadedState(categorias));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
```
