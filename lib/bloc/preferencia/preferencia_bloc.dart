import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/preferencia/preferencia_event.dart';
import 'package:abaez/bloc/preferencia/preferencia_state.dart';
import 'package:abaez/data/preferencia_repository.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaBloc extends Bloc<PreferenciaEvent, PreferenciaState> {
  final PreferenciaRepository _preferenciasRepository = di<PreferenciaRepository>(); // Obtenemos el repositorio del locator
  
  PreferenciaBloc() : super(const PreferenciaState()) {
    on<CargarPreferencias>(_onCargarPreferencias);
    on<CambiarCategoria>(_onCambiarCategoria);
    on<CambiarMostrarFavoritos>(_onCambiarMostrarFavoritos);
    on<SavePreferencias>(_onSavePreferencias);
    on<BuscarPorPalabraClave>(_onBuscarPorPalabraClave);
    on<FiltrarPorFecha>(_onFiltrarPorFecha);
    on<CambiarOrdenamiento>(_onCambiarOrdenamiento);
    on<ReiniciarFiltros>(_onReiniciarFiltros);
  }

  Future<void> _onCargarPreferencias(
    CargarPreferencias event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Obtener solo las categorías seleccionadas del repositorio existente
      final categoriasSeleccionadas = await _preferenciasRepository.obtenerCategoriasSeleccionadas();
      
      // Como el repositorio original solo almacena categorías, el resto de valores serían por defecto
      emit(PreferenciaState(
        categoriasSeleccionadas: categoriasSeleccionadas,
        // Valores por defecto para el resto de propiedades
        mostrarFavoritos: false,
        palabraClave: '',
        fechaDesde: null,
        fechaHasta: null,
        ordenarPor: 'fecha',
        ascendente: false,
      ));
    } catch (_) {
      // Si hay error, mantener estado actual
    }
  }

  void _onCambiarCategoria(
    CambiarCategoria event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      if (event.seleccionada) {
        // Agregar categoría usando el método del repositorio
        await _preferenciasRepository.agregarCategoriaFiltro(event.categoria);
      } else {
        // Eliminar categoría usando el método del repositorio
        await _preferenciasRepository.eliminarCategoriaFiltro(event.categoria);
      }
      
      // Obtener la lista actualizada de categorías
      final categoriasActualizadas = await _preferenciasRepository.obtenerCategoriasSeleccionadas();
      
      // Actualizar el estado con las categorías actualizadas
      final nuevoEstado = state.copyWith(categoriasSeleccionadas: categoriasActualizadas);
      emit(nuevoEstado);
    } catch (_) {
      // Manejar errores si es necesario
    }
  }

  void _onCambiarMostrarFavoritos(
    CambiarMostrarFavoritos event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(mostrarFavoritos: event.mostrarFavoritos);
    emit(nuevoEstado);
  }

  void _onBuscarPorPalabraClave(
    BuscarPorPalabraClave event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(palabraClave: event.palabraClave);
    emit(nuevoEstado);
  }

  void _onFiltrarPorFecha(
    FiltrarPorFecha event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(
      fechaDesde: event.fechaDesde,
      fechaHasta: event.fechaHasta,
    );
    emit(nuevoEstado);
  }

  void _onCambiarOrdenamiento(
    CambiarOrdenamiento event,
    Emitter<PreferenciaState> emit,
  ) {
    // Como el repositorio original no maneja esta preferencia,
    // solo actualizamos el estado en memoria
    final nuevoEstado = state.copyWith(
      ordenarPor: event.ordenarPor,
      ascendente: event.ascendente,
    );
    emit(nuevoEstado);
  }

  void _onReiniciarFiltros(
    ReiniciarFiltros event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Limpiar las categorías seleccionadas usando el método del repositorio
      await _preferenciasRepository.limpiarFiltrosCategorias();
      
      // Emitir un estado inicial
      const estadoInicial = PreferenciaState();
      emit(estadoInicial);
    } catch (_) {
      // Manejar errores si es necesario
    }
  }

  Future<void> _onSavePreferencias(
    SavePreferencias event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Guardamos las categorías en el repositorio
      // (esto puede requerir implementación adicional en el repositorio)
      for (final categoriaId in event.categoriasSeleccionadas) {
        await _preferenciasRepository.agregarCategoriaFiltro(categoriaId);
      }
      
      // Emitimos el estado actualizado
      emit(state.copyWith(
        categoriasSeleccionadas: event.categoriasSeleccionadas,
      ));
    } catch (e) {
      // Manejar errores si es necesario
    }
  }
}