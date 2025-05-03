import  'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/bloc/categorias/categorias_event.dart';
import 'package:abaez/bloc/categorias/categorias_state.dart';
import 'package:abaez/data/categorias_repository.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:watch_it/watch_it.dart';


class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
   final CategoriaRepository categoriaRepository = di<CategoriaRepository>();
 
   CategoriaBloc() : super(CategoriaInitial()) {
     on<CategoriaInitEvent>(_onInit);
     on<CategoriaCreateEvent>(_onCreateCategoria);
     on<CategoriaUpdateEvent>(_onUpdateCategoria);
     on<CategoriaDeleteEvent>(_onDeleteCategoria);
   }
 
   Future<void> _onInit (CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
     emit(CategoriaLoading());
 
     try {
       final categorias = await categoriaRepository.obtenerCategorias();
       emit(CategoriaLoaded(categorias, DateTime.now()));
     } catch (e) {
       emit(CategoriaError('Failed to load categories: ${e.toString()}'));
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
       
       // Recargar la lista después de crear
       add(CategoriaInitEvent());
     } catch (e) {
       debugPrint('Error creando categoría: $e');
       emit(CategoriaError('Error al crear categoría: ${e.toString()}'));
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
       
       // Recargar la lista después de actualizar
       add(CategoriaInitEvent());
     } catch (e) {
       debugPrint('Error actualizando categoría: $e');
       emit(CategoriaError('Error al actualizar categoría: ${e.toString()}'));
     }
   }
   
   Future<void> _onDeleteCategoria(CategoriaDeleteEvent event, Emitter<CategoriaState> emit) async {
     emit(CategoriaDeleting());
     
     try {
       // Llamar al repositorio para eliminar la categoría
       await categoriaRepository.eliminarCategoria(event.id);
       
       emit(CategoriaDeleted(event.id));
       
       // Recargar la lista después de eliminar
       add(CategoriaInitEvent());
     } catch (e) {
       debugPrint('Error eliminando categoría: $e');
       emit(CategoriaError('Error al eliminar categoría: ${e.toString()}'));
     }
   }
}