import 'package:abaez/domain/comentario.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/data/comentario_repository.dart';

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
    on<AddReaccion>(_onAddReaccion);
    on<AddSubcomentario>(_onAddSubcomentario);
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
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ComentarioError(
          errorMessage:
              'Error al cargar comentarios'
              '${e.toString()}',statusCode: statusCode
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
      final comentarios = await comentarioRepository
          .obtenerComentariosPorNoticia(event.noticiaId);
      emit(ComentarioLoaded(comentariosList: comentarios));

      // Actualizar también el número de comentarios
      final numeroComentarios = await comentarioRepository
          .obtenerNumeroComentarios(event.noticiaId);

      // Emitimos el nuevo estado con el número de comentarios actualizado
      emit(
        NumeroComentariosLoaded(
          noticiaId: event.noticiaId,
          numeroComentarios: numeroComentarios,
        ),
      );

      // Si había un estado ComentarioLoaded, lo restauramos pero con la nueva lista
      if (currentState is ComentarioLoaded) {
        emit(ComentarioLoaded(comentariosList: comentarios));
      }
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ComentarioError(errorMessage: 'Error al agregar el comentario',statusCode: statusCode),
      );
    }
  }

  Future<void> _onGetNumeroComentarios(
    GetNumeroComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      emit(ComentarioLoading());

      final numeroComentarios = await comentarioRepository
          .obtenerNumeroComentarios(event.noticiaId);

      emit(
        NumeroComentariosLoaded(
          noticiaId: event.noticiaId,
          numeroComentarios: numeroComentarios,
        ),
      );
    } on ApiException catch (e) {
      emit(ComentarioError(errorMessage: e.message));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ComentarioError(
          errorMessage:
              'Error al obtener número de comentarios: ${e.toString()}',statusCode: statusCode,
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
      final comentarios = await comentarioRepository
          .obtenerComentariosPorNoticia(event.noticiaId);

      // Filtrar los comentarios según el criterio
      final comentariosFiltrados =
          comentarios.where((comentario) {
            final textoBuscado = event.criterioBusqueda.toLowerCase();
            final textoComentario = comentario.texto.toLowerCase();
            final autorComentario = comentario.autor.toLowerCase();

            return textoComentario.contains(textoBuscado) ||
                autorComentario.contains(textoBuscado);
          }).toList();

      // Emitir el estado con comentarios filtrados
      emit(ComentarioLoaded(comentariosList: comentariosFiltrados));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ComentarioError(
          errorMessage: 'Error al buscar comentarios: ${e.toString()}',statusCode: statusCode
        ),
      );
    }
  }

  Future<void> _onOrdenarComentarios(
    OrdenarComentarios event,
    Emitter<ComentarioState> emit,
  ) async {
    if (state is ComentarioLoaded) {
      final currentState = state as ComentarioLoaded;
      final comentarios = List<Comentario>.from(
        currentState.comentariosList,
      ); // Crear una copia para no modificar la lista original

      comentarios.sort((a, b) {
        return event.ascendente
            ? a.fecha.compareTo(b.fecha) // Orden ascendente
            : b.fecha.compareTo(a.fecha); // Orden descendente
      });

      emit(ComentarioLoaded(comentariosList: comentarios));
    }
  }

  Future<void> _onAddReaccion(AddReaccion event, Emitter<ComentarioState> emit,) async {
    final currentState = state;

    try {
      emit(ReaccionLoading());
      // Llamamos al repositorio para persistir el cambio
      final comentarioResponse = await comentarioRepository.reaccionarComentario(
        comentarioId: event.comentarioId,
        tipoReaccion: event.tipoReaccion,
      );

      // Recargamos los comentarios para asegurar los datos más recientes
      //final comentariosActualizados = await comentarioRepository.obtenerComentariosPorNoticia(event.noticiaId);

      if (currentState is ComentarioLoaded) {
        final comentarios = List<Comentario>.from(currentState.comentariosList);
        final comentarioIndex = comentarios.indexWhere(
              (c) => c.id == event.comentarioId,
        );
        print('\n\nComentario index: $comentarioIndex\n\n\n');
        if (comentarioIndex != -1) {
            comentarios[comentarioIndex] = comentarioResponse;
            emit(ComentarioLoaded(comentariosList: comentarios));
        } else {
            final comentariosActualizados = comentarios.map((comentario) {
              final subcomentarios = comentario.subcomentarios ?? [];
              final subIndex = subcomentarios.indexWhere((sc) => sc.idSubComentario == event.comentarioId);
              if (subIndex != -1) {
                final nuevosSubcomentarios = List<Comentario>.from(subcomentarios);
                nuevosSubcomentarios[subIndex] = comentarioResponse;
                return nuevosSubcomentarios[subIndex];
              }
              return comentario;
            }).toList();
            emit(ComentarioLoaded(comentariosList: comentariosActualizados));
        }
      }
    } catch (e) {
      print('Error en _onAddReaccion: ${e.toString()}');
      emit(const ComentarioError(errorMessage: 'Error al reaccionar comentario'));
    }
  }

  Future<void> _onAddSubcomentario(
    AddSubcomentario event,
    Emitter<ComentarioState> emit,
  ) async {
    try {
      // Mostrar estado de carga
      emit(ComentarioLoading());

      // Llamar al repositorio para agregar el subcomentario
      final resultado = await comentarioRepository.agregarSubcomentario(
        comentarioId: event.comentarioId,
        texto: event.texto,
        autor: event.autor,
      );

      if (resultado['success'] == true) {
        // Recargar comentarios usando directamente el noticiaId proporcionado
        final comentarios = await comentarioRepository
            .obtenerComentariosPorNoticia(event.noticiaId);

        emit(ComentarioLoaded(comentariosList: comentarios));
      } else {
        // Si hubo un error, mostrar el mensaje de error
        emit(ComentarioError(errorMessage: resultado['message']));
      }
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(
        ComentarioError(
          errorMessage: 'Error al agregar subcomentario: ${e.toString()}', statusCode: statusCode,
        ),
      );
    }
  }
}
