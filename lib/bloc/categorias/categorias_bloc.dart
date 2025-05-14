import 'package:abaez/exceptions/api_exception.dart';
import  'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/bloc/categorias/categorias_event.dart';
import 'package:abaez/bloc/categorias/categorias_state.dart';
import 'package:abaez/data/categorias_repository.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/api/service/category_cache_service.dart';
import 'package:watch_it/watch_it.dart';


class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
   final CategoriaRepository categoriaRepository = di<CategoriaRepository>();
   final CategoryCacheService categoryCacheService = di<CategoryCacheService>();
 
   CategoriaBloc() : super(CategoriaInitial()) {
     on<CategoriaInitEvent>(_onInit);
     on<CategoriaCreateEvent>(_onCreateCategoria);
     on<CategoriaUpdateEvent>(_onUpdateCategoria);
     on<CategoriaDeleteEvent>(_onDeleteCategoria);
   }
 
   Future<void> _onInit (CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
     emit(CategoriaLoading());
 
     try {
       // Usar el servicio de cache en lugar del repositorio directamente
       final categorias = await categoryCacheService.getCategories();
       emit(CategoriaLoaded(categorias, categoryCacheService.lastRefreshed ?? DateTime.now()));
     } catch (e) {
        final int? statusCode = e is ApiException ? e.statusCode : null;
        emit(CategoriaError('Failed to load categories: ${e.toString()}',statusCode: statusCode));
     }
   }
     Future<void> _onCreateCategoria(CategoriaCreateEvent event, Emitter<CategoriaState> emit) async {
     emit(CategoriaCreating());
     
     try {
       // Crear el mapa de datos de la categoria
       final categoriaData = {
         'nombre': event.nombre,
         'descripcion': event.descripcion,
         'imagenUrl': event.imagenUrl,
       };
       
       // Llamar al repositorio para crear la categoría
       await categoriaRepository.crearCategoria(categoriaData);
       
       // Crear instancia de Categoria (sin ID ya que es generado por el backend)
       final newCategoria = Categoria(
         id: '',
         nombre: event.nombre,
         descripcion: event.descripcion,
         imagenUrl: event.imagenUrl,
       );
       
       emit(CategoriaCreated(newCategoria));
       
       // Refrescar el caché de categorías
       await categoryCacheService.refreshCategories();
       
       // Recargar la lista después de crear
       add(CategoriaInitEvent());
     } catch (e) {
        final int? statusCode = e is ApiException ? e.statusCode : null;
        debugPrint('Error creando categoría: $e');
        emit(CategoriaError('Error al crear categoría: ${e.toString()}',statusCode: statusCode));
     }
   }
     Future<void> _onUpdateCategoria(CategoriaUpdateEvent event, Emitter<CategoriaState> emit) async {
     emit(CategoriaUpdating());
     
     try {
       // Crear el mapa de datos de la categoria
       final categoriaData = {
         'nombre': event.nombre,
         'descripcion': event.descripcion,
         'imagenUrl': event.imagenUrl,
       };
       
       // Llamar al repositorio para actualizar la categoría
       await categoriaRepository.actualizarCategoria(event.id, categoriaData);
       
       // Crear instancia de Categoria actualizada
       final updatedCategoria = Categoria(
         id: event.id,
         nombre: event.nombre,
         descripcion: event.descripcion,
         imagenUrl: event.imagenUrl,
       );
       
       emit(CategoriaUpdated(updatedCategoria));
       
       // Refrescar el caché de categorías
       await categoryCacheService.refreshCategories();
       
       // Recargar la lista después de actualizar
       add(CategoriaInitEvent());
     } catch (e) {
        final int? statusCode = e is ApiException ? e.statusCode : null;
        debugPrint('Error actualizando categoría: $e');
        emit(CategoriaError('Error al actualizar categoría: ${e.toString()}',statusCode: statusCode));
     }
   }
     Future<void> _onDeleteCategoria(CategoriaDeleteEvent event, Emitter<CategoriaState> emit) async {
     emit(CategoriaDeleting());
     
     try {
       // Llamar al repositorio para eliminar la categoría
       await categoriaRepository.eliminarCategoria(event.id);
       
       emit(CategoriaDeleted(event.id));
       
       // Refrescar el caché de categorías
       await categoryCacheService.refreshCategories();
       
       // Recargar la lista después de eliminar
       add(CategoriaInitEvent());
     } catch (e) {
        final int? statusCode = e is ApiException ? e.statusCode : null;
        debugPrint('Error eliminando categoría: $e');
        emit(CategoriaError('Error al eliminar categoría: ${e.toString()}',statusCode: statusCode));
     }
   }
}