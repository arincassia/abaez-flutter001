import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/tareas/tareas_event.dart';
import 'package:abaez/bloc/tareas/tareas_state.dart';
import 'package:abaez/data/tarea_repository.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class TareaBloc extends Bloc<TareaEvent, TareaState> {
  final TareasRepository _tareaRepository = di<TareasRepository>();
  static const int _limitePorPagina = 5;

  TareaBloc() : super(TareaInitial()) {

    on<LoadTareasEvent>(_onLoadTareas);
    on<LoadMoreTareasEvent>(_onLoadMoreTareas);
    on<CreateTareaEvent>(_onCreateTarea);
    on<UpdateTareaEvent>(_onUpdateTarea);
    on<DeleteTareaEvent>(_onDeleteTarea);
    on<SaveTareasEvent>(_onSaveTareas);
    on<SyncTareasEvent>(_onSyncTareas);
    on<CompletarTareaEvent>(_onCompletarTarea);
  }

  Future<void> _onLoadTareas(
    LoadTareasEvent event,
    Emitter<TareaState> emit,
  ) async {
    emit(TareaLoading());
    try {
      final tareas = await _tareaRepository.obtenerTareas(
        forzarRecarga: event.forzarRecarga,
      );
      emit(
        TareaLoaded(
          tareas: tareas,
          lastUpdated: DateTime.now(),
          hayMasTareas: tareas.length >= _limitePorPagina,
          paginaActual: 0,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onLoadMoreTareas(
    LoadMoreTareasEvent event,
    Emitter<TareaState> emit,
  ) async {
    if (state is TareaLoaded) {
      final currentState = state as TareaLoaded;
      try {
        final nuevasTareas = await _tareaRepository.obtenerTareas(
          forzarRecarga: true,
        );

        emit(
          TareaLoaded(
            tareas: [...currentState.tareas, ...nuevasTareas],
            lastUpdated: DateTime.now(),
            hayMasTareas: nuevasTareas.length >= event.limite,
            paginaActual: event.pagina,
          ),
        );
      } catch (e) {
        if (e is ApiException) {
          emit(TareaError(e));
        }
      }
    }
  }

  Future<void> _onCreateTarea(
    CreateTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      final nuevaTarea = await _tareaRepository.agregarTarea(event.tarea);
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas = [nuevaTarea, ...currentState.tareas];

        emit(
          TareaCreated(
            tareas,
            TipoOperacionTarea.crear,
            'Tarea creada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onUpdateTarea(
    UpdateTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      final tareaActualizada = await _tareaRepository.actualizarTarea(
        event.tarea,
      );
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas =
            currentState.tareas.map((tarea) {
              return tarea.id == event.tarea.id ? tareaActualizada : tarea;
            }).toList();

        emit(
          TareaUpdated(
            tareas,
            TipoOperacionTarea.editar,
            'Tarea actualizada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onDeleteTarea(
    DeleteTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      await _tareaRepository.eliminarTarea(event.id);
      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas =
            currentState.tareas.where((t) => t.id != event.id).toList();

        emit(
          TareaDeleted(
            tareas,
            TipoOperacionTarea.eliminar,
            'Tarea eliminada exitosamente',
          ),
        );
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

   Future<void> _onSaveTareas(
    SaveTareasEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      // Call your repository method to save tasks locally
      await _tareaRepository.guardarTareasLocalmente(event.tareas);
    } catch (e) {
      // Silent error handling - don't emit new state
      
    }
  }


  
Future<void> _onSyncTareas(
  SyncTareasEvent event,
  Emitter<TareaState> emit,
) async {
  if (state is TareaLoaded) {
    try {
      final currentState = state as TareaLoaded;
      
      // Primero obtener las tareas más recientes del servidor
      final remoteTareas = await _tareaRepository.obtenerTareas(forzarRecarga: true);
      
      // Combinar con las tareas locales (resolver conflictos según tu lógica de negocio)
      // Aquí usamos una estrategia simple donde las tareas locales tienen prioridad
      final Set<String?> remoteIds = remoteTareas.map((t) => t.id).toSet();
      final localOnlyTareas = currentState.tareas.where((t) => !remoteIds.contains(t.id)).toList();
      
      // Unir tareas locales y remotas
      final mergedTareas = [...remoteTareas, ...localOnlyTareas];
      
      // Actualizar estado
      emit(TareaLoaded(
        tareas: mergedTareas,
        lastUpdated: DateTime.now(),
        hayMasTareas: mergedTareas.length >= _limitePorPagina,
        paginaActual: 0,
      ));
      
      // Guardar resultado sincronizado en la caché local
      await _tareaRepository.guardarTareasLocalmente(mergedTareas);
      
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }
}

Future<void> _onCompletarTarea(
    CompletarTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      final tareaActualizada = event.tarea.copyWith(
        completado: event.completada,
      );

      if (state is TareaLoaded) {
        final currentState = state as TareaLoaded;
        final tareas =
            currentState.tareas.map((tarea) {
              return tarea.id == event.tarea.id ? tareaActualizada : tarea;
            }).toList();

        // Emitimos solo el estado de completado una vez
        emit(
          TareaCompletada(
            tarea: tareaActualizada,
            completada: event.completada,
            tareas: tareas,
            mensaje: event.completada ? 'Tarea completada' : 'Tarea pendiente',
          ),
        );

        // Actualizamos el estado de la lista
        emit(
          TareaLoaded(
            tareas: tareas,
            lastUpdated: DateTime.now(),
            hayMasTareas: currentState.hayMasTareas,
            paginaActual: currentState.paginaActual,
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }
  
}