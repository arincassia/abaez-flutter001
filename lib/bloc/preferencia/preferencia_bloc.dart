import 'package:abaez/exceptions/api_exception.dart';
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
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(PreferenciaError('Error al cargar preferencias: ${e.toString()}', statusCode: statusCode));
    }
  }

  void _onCambiarCategoria(
    CambiarCategoria event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // 1. Crear una copia de las categorías actuales para modificar
      final List<String> categoriasActualizadas = [...state.categoriasSeleccionadas];

      // 2. Actualizar localmente primero para feedback inmediato
      if (event.seleccionada) {
        if (!categoriasActualizadas.contains(event.categoria)) {
          categoriasActualizadas.add(event.categoria);
        }
      } else {
        categoriasActualizadas.remove(event.categoria);
      }

      // 3. Emitir estado actualizado inmediatamente para UI responsiva
      emit(state.copyWith(categoriasSeleccionadas: categoriasActualizadas));

      // 4. Luego intentar persistir el cambio (sin bloquear la UI)
      try {
        if (event.seleccionada) {
          await _preferenciasRepository.agregarCategoriaFiltro(event.categoria);
        } else {
          await _preferenciasRepository.eliminarCategoriaFiltro(event.categoria);
        }
      } catch (e) {
        // Si falla la persistencia, no interrumpir la experiencia del usuario
        // pero registrar el error para depuración
        print('Error al persistir cambio de categoría: $e');

        // Opcionalmente, podrías emitir un estado de "sincronización pendiente"
        // para indicar que los cambios locales no se han guardado aún
      }
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      // Este catch solo atraparía errores graves en la lógica del bloc
      emit(PreferenciaError('Error al cambiar categoría: ${e.toString()}', statusCode: statusCode));
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
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(PreferenciaError('Error al reiniciar filtros: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onSavePreferencias(
    SavePreferencias event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      // Más eficiente: guardar todas las categorías a la vez
      await _preferenciasRepository.guardarCategoriasSeleccionadas(event.categoriasSeleccionadas);

      // Emitir el estado actualizado
      emit(state.copyWith(categoriasSeleccionadas: event.categoriasSeleccionadas));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(PreferenciaError('Error al guardar preferencias: ${e.toString()}', statusCode: statusCode));
    }
  }
}
