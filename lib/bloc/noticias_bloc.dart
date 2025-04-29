import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/event/noticias_event.dart';
import 'package:abaez/bloc/state/noticias_state.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/domain/noticia.dart';

class NoticiasBloc extends Bloc<NoticiasEvent, NoticiasState> {
  final NoticiaRepository noticiaRepository;

  NoticiasBloc(this.noticiaRepository) : super(const NoticiasInicioState()) {
    // Manejar el evento CargarNoticiasEvent
    on<CargarNoticiasEvent>((event, emit) async {
      emit(const NoticiasCargandoState());
      try {
        final noticias = await noticiaRepository.listarNoticiasDesdeAPI();
        emit(NoticiasCargadasState(noticias)); // Constructor posicional
      } catch (e) {
        emit(NoticiasErrorState('Error al cargar noticias: $e'));
      }
    });

    // Manejar el evento AgregarNoticiaEvent
  on<AgregarNoticiaEvent>((event, emit) async {
  if (state is NoticiasCargadasState) {
    final currentState = state as NoticiasCargadasState;
    try {
      // Llama al repositorio para agregar la noticia
      await noticiaRepository.crearNoticia(event.noticia);

      // Actualiza el estado con la nueva lista de noticias
      final List<Noticia> noticiasActualizadas = List.from(currentState.noticias)
        ..add(event.noticia);
      emit(NoticiasCargadasState(noticiasActualizadas));
    } catch (e) {
      emit(NoticiasErrorState('Error al agregar noticia: $e'));
    }
  } else {
    emit(const NoticiasErrorState('No se pueden agregar noticias en el estado actual'));
  }
});
    // Manejar otros eventos como EliminarNoticiaEvent, etc.
    on<EliminarNoticiaEvent>((event, emit) async {
      if (state is NoticiasCargadasState) {
        final currentState = state as NoticiasCargadasState;
        final List<Noticia> noticiasActualizadas = List.from(currentState.noticias)
          ..remove(event.noticia);
        emit(NoticiasCargadasState(noticiasActualizadas)); // Constructor posicional
      }
    });
  }
}