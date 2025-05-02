import 'package:bloc/bloc.dart';
import 'package:abaez/bloc/bloc noticias/noticias_event.dart';
import 'package:abaez/bloc/bloc noticias/noticias_state.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:watch_it/watch_it.dart';

class NoticiasBloc extends Bloc<NoticiasEvent, NoticiasState> {
  final NoticiaRepository _noticiaRepository = di<NoticiaRepository>();

  NoticiasBloc() : super(NoticiasInitial()) {
    on<FetchNoticias>(_onFetchNoticias);
    on<AddNoticia>(_onAddNoticia);
    on<UpdateNoticia>(_onUpdateNoticia);
    on<DeleteNoticia>(_onDeleteNoticia);
    on<FilterNoticiasByPreferencias>(_onFilterNoticiasByPreferencias);
  }

  Future<void> _onFetchNoticias(
    FetchNoticias event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      emit(NoticiasError('Error al cargar noticias: ${e.toString()}'));
    }
  }

  Future<void> _onAddNoticia(
    AddNoticia event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      await _noticiaRepository.crearNoticia(
        titulo: event.noticia.titulo,
        descripcion: event.noticia.descripcion,
        fuente: event.noticia.fuente,
        publicadaEl: event.noticia.publicadaEl.toIso8601String(),
        urlImagen: event.noticia.imageUrl,
        categoriaId: event.noticia.categoriaId,
      );

      // Refrescar la lista de noticias después de agregar
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      emit(NoticiasError('Error al agregar noticia: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNoticia(
    UpdateNoticia event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      await _noticiaRepository.actualizarNoticia(
        id: event.id,
        titulo: event.noticia.titulo,
        descripcion: event.noticia.descripcion,
        fuente: event.noticia.fuente,
        publicadaEl: event.noticia.publicadaEl.toIso8601String(),
        urlImagen: event.noticia.imageUrl,
        categoriaId: event.noticia.categoriaId,
      );

      // Refrescar la lista de noticias después de actualizar
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      emit(NoticiasError('Error al actualizar noticia: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNoticia(
    DeleteNoticia event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      await _noticiaRepository.eliminarNoticia(event.id);

      // Refrescar la lista de noticias después de eliminar
      final noticias = await _noticiaRepository.obtenerNoticias();
      emit(NoticiasLoaded(noticias, DateTime.now()));
    } catch (e) {
      emit(NoticiasError('Error al eliminar noticia: ${e.toString()}'));
    }
  }

  Future<void> _onFilterNoticiasByPreferencias(
    FilterNoticiasByPreferencias event,
    Emitter<NoticiasState> emit,
  ) async {
    emit(NoticiasLoading());
    try {
      final allNoticias = await _noticiaRepository.obtenerNoticias();

      final filteredNoticias =
          allNoticias
              .where(
                (noticia) => event.categoriasIds.contains(noticia.categoriaId),
              )
              .toList();

      emit(NoticiasLoaded(filteredNoticias, DateTime.now()));
    } catch (e) {
      emit(NoticiasError('Error al filtrar noticias: ${e.toString()}'));
    }
  }
}
