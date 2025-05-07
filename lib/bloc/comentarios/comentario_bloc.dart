import 'package:abaez/domain/comentario.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';
import 'package:abaez/data/comentarios_repository.dart';
import 'package:abaez/exceptions/api_exception.dart';


class ComentarioBloc extends Bloc<ComentarioEvent, ComentarioState> {
  final ComentarioRepository comentarioRepository;

  ComentarioBloc({ComentarioRepository? comentarioRepository})
      : comentarioRepository = comentarioRepository ?? ComentarioRepository(),
        super(ComentarioInitial()) {
    on<LoadComentarios>(_onLoadComentarios);
    on<AddComentario>(_onAddComentario);
    on<GetNumeroComentarios>(_onGetNumeroComentarios);
    on<BuscarComentarios>(_onBuscarComentarios);
    on<OrdenarComentarios>(_onOrdenarComentarios);
  }

  Future<void> _onLoadComentarios(
    LoadComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      emit(ComentarioLoading());

      final comentarios = await comentarioRepository
          .obtenerComentariosPorNoticia(event.noticiaId);

      emit(ComentarioLoaded(comentariosList: comentarios));
    } on ApiException catch (e) {
      emit(ComentarioError(errorMessage: e.message));
    } catch (e) {
      emit(
        ComentarioError(
          errorMessage:
              'Error al cargar comentarios'
              '${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddComentario(
    AddComentario event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      // Guardamos el estado actual antes de emitir ComentarioLoading
      final currentState = state;
      
      await comentarioRepository.agregarComentario(
        event.noticiaId,
        event.texto,
        event.autor,
        event.fecha,
      );

      // Recargar comentarios después de agregar uno nuevo
      final comentarios = await comentarioRepository.obtenerComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoaded(comentariosList: comentarios));
      
      // Actualizar también el número de comentarios
      final numeroComentarios = await comentarioRepository.obtenerNumeroComentarios(
        event.noticiaId,
      );
      
      // Emitimos el nuevo estado con el número de comentarios actualizado
      emit(NumeroComentariosLoaded(
        noticiaId: event.noticiaId,
        numeroComentarios: numeroComentarios,
      ));
      
      // Si había un estado ComentarioLoaded, lo restauramos pero con la nueva lista
      if (currentState is ComentarioLoaded) {
        emit(ComentarioLoaded(comentariosList: comentarios));
      }
    } catch (e) {
      emit(
        const ComentarioError(errorMessage: 'Error al agregar el comentario'),
      );
    }
  }
  
  Future<void> _onGetNumeroComentarios(
    GetNumeroComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      emit(ComentarioLoading());
      
      final numeroComentarios = await comentarioRepository.obtenerNumeroComentarios(
        event.noticiaId,
      );
      
      emit(NumeroComentariosLoaded(
        noticiaId: event.noticiaId,
        numeroComentarios: numeroComentarios,
      ));
    } on ApiException catch (e) {
      emit(ComentarioError(errorMessage: e.message));
    } catch (e) {
      emit(
        ComentarioError(
          errorMessage: 'Error al obtener número de comentarios: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onBuscarComentarios(
    BuscarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      emit(ComentarioLoading());
      
      // Obtener todos los comentarios primero
      final comentarios = await comentarioRepository.obtenerComentariosPorNoticia(
        event.noticiaId,
      );
      
      // Filtrar los comentarios según el criterio
      final comentariosFiltrados = comentarios.where((comentario) {
        final textoBuscado = event.criterioBusqueda.toLowerCase();
        final textoComentario = comentario.texto.toLowerCase();
        final autorComentario = comentario.autor.toLowerCase();
        
        return textoComentario.contains(textoBuscado) || 
               autorComentario.contains(textoBuscado);
      }).toList();
      
      // Emitir el estado con comentarios filtrados
      emit(ComentarioLoaded(comentariosList: comentariosFiltrados));
    } catch (e) {
      emit(ComentarioError(
        errorMessage: 'Error al buscar comentarios: ${e.toString()}',
      ));
    }
  }

  
  Future<void> _onOrdenarComentarios(
    OrdenarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    if (state is ComentarioLoaded) {
      final currentState = state as ComentarioLoaded;
      final comentarios = List<Comentario>.from(currentState.comentariosList); // Crear una copia para no modificar la lista original

      comentarios.sort((a, b) {
        return event.ascendente 
          ? a.fecha.compareTo(b.fecha)  // Orden ascendente 
          : b.fecha.compareTo(a.fecha); // Orden descendente
      });

      emit(ComentarioLoaded(comentariosList: comentarios));
    }
  }
}
