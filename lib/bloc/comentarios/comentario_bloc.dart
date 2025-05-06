import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';
import 'package:abaez/data/comentarios_repository.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class ComentarioBloc extends Bloc<ComentarioEvent, ComentarioState> {
  final ComentarioRepository comentarioRepository = di<ComentarioRepository>();

  ComentarioBloc() : super(ComentarioInitial()) {
    on<LoadComentarios>(_onLoadComentarios);
    on<AddComentario>(_onAddComentario);
    on<GetNumeroComentarios>(_onGetNumeroComentarios);
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
      await comentarioRepository.agregarComentario(
        event.noticiaId,
        event.texto,
        event.autor,
        event.fecha,
      );

      // Recargar comentarios después de agregar uno nuevo
      add(LoadComentarios(noticiaId: event.noticiaId));
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
}
