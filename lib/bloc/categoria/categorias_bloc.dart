import 'package:abaez/bloc/categoria/categorias_event.dart';
import 'package:abaez/bloc/categoria/categoria_state.dart';
import 'package:abaez/data/categorias_repository.dart';
import 'package:watch_it/watch_it.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository = di<CategoriaRepository>();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onInit);
    on<CategoriaAddEvent>(_onAddCategoria);
    on<CategoriaUpdateEvent>(_onUpdateCategoria);
    on<CategoriaDeleteEvent>(_onDeleteCategoria);
  }

  Future<void> _onInit (CategoriaInitEvent event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());

    try {
      final categorias = await categoriaRepository.listarCategoriasDesdeAPI();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> _onAddCategoria(CategoriaAddEvent event, Emitter<CategoriaState> emit) async {
    // Store current state to restore if needed
    final currentState = state;
    
    // Show loading state
    emit(CategoriaLoading());
    
    try {
      // Add the category using the repository
      await categoriaRepository.crearCategoria(event.categoria);
      
      // Reload the categories to get the updated list
      final categorias = await categoriaRepository.listarCategoriasDesdeAPI();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Failed to add category: ${e.toString()}'));
      
      // Optionally restore previous state if adding fails
      if (currentState is CategoriaLoaded) {
        emit(currentState);
      }
    }
  }

    Future<void> _onUpdateCategoria(CategoriaUpdateEvent event, Emitter<CategoriaState> emit) async {
    final currentState = state;
    emit(CategoriaLoading());
    
    try {
      await categoriaRepository.editarCategoria(event.categoria);
      final categorias = await categoriaRepository.listarCategoriasDesdeAPI();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Failed to update category: ${e.toString()}'));
      
      if (currentState is CategoriaLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteCategoria(CategoriaDeleteEvent event, Emitter<CategoriaState> emit) async {
    final currentState = state;
    emit(CategoriaLoading());
    
    try {
      await categoriaRepository.eliminarCategoria(event.id);
      final categorias = await categoriaRepository.listarCategoriasDesdeAPI();
      emit(CategoriaLoaded(categorias, DateTime.now()));
    } catch (e) {
      emit(CategoriaError('Failed to delete category: ${e.toString()}'));
      
      if (currentState is CategoriaLoaded) {
        emit(currentState);
      }
    }
  }

}