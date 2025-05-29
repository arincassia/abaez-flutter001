import 'package:equatable/equatable.dart';
import 'package:abaez/domain/tarea.dart';
import 'package:abaez/exceptions/api_exception.dart';

abstract class TareaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TareaInitial extends TareaState {}

class TareaLoading extends TareaState {}

enum TipoOperacionTarea { cargar, crear, editar, eliminar }

class TareaError extends TareaState {
  final ApiException error;

  TareaError(this.error);

  @override
  List<Object?> get props => [error];
}

class TareaLoaded extends TareaState {
  final List<Tarea> tareas;
  final DateTime lastUpdated;
  final bool hayMasTareas;
  final int paginaActual;
  
  TareaLoaded({
    required this.tareas,
    required this.lastUpdated,
    this.hayMasTareas = true,
    this.paginaActual = 0,
  });

  @override
  List<Object?> get props => [tareas, lastUpdated, hayMasTareas, paginaActual];
}

class TareaOperationSuccess extends TareaState {
  final List<Tarea> tareas;
  final TipoOperacionTarea tipoOperacion;
  final String mensaje;

  TareaOperationSuccess(this.tareas, this.tipoOperacion, this.mensaje);

  @override
  List<Object?> get props => [tareas, tipoOperacion, mensaje];
}

class TareaCreated extends TareaOperationSuccess {
  TareaCreated(super.tareas, super.tipoOperacion, super.mensaje);
}

class TareaUpdated extends TareaOperationSuccess {
  TareaUpdated(super.tareas, super.tipoOperacion, super.mensaje);
}

class TareaDeleted extends TareaOperationSuccess {
  TareaDeleted(super.tareas, super.tipoOperacion, super.mensaje);
}

class TareaCompletada extends TareaState {
  final Tarea tarea;
  final bool completada;
  final String mensaje;
  final List<Tarea> tareas; // Agregamos la lista completa de tareas

  TareaCompletada({
    required this.tarea,
    required this.completada,
    required this.tareas,
    this.mensaje = '',
  });


  int get totalTareas => tareas.length;
  int get tareasCompletadas => tareas.where((t) => t.completado).length;
  double get progreso => totalTareas > 0 ? tareasCompletadas / totalTareas : 0.0;
}