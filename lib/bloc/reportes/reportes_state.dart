import 'package:equatable/equatable.dart';
import 'package:abaez/domain/reporte.dart';

abstract class ReporteState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Estado inicial
class ReporteInitial extends ReporteState {}

// Estado de error
class ReporteError extends ReporteState {
  final String message;

  ReporteError(this.message);

  @override
  List<Object> get props => [message];
}

// Estado de carga
class ReporteLoading extends ReporteState {}

// Estado cuando los reportes están cargados
class ReporteLoaded extends ReporteState {
  final List<Reporte> reportes;
  final DateTime timestamp;

  ReporteLoaded(this.reportes, this.timestamp);

  @override
  List<Object> get props => [reportes, timestamp];
}

// Estado cuando un reporte ha sido creado exitosamente
class ReporteCreated extends ReporteState {
  final Reporte reporte;

  ReporteCreated(this.reporte);

  @override
  List<Object> get props => [reporte];
}

// Estado cuando un reporte ha sido eliminado exitosamente
class ReporteDeleted extends ReporteState {
  final String id;

  ReporteDeleted(this.id);

  @override
  List<Object> get props => [id];
}

// Estado para reportes filtrados por noticia
class ReportesPorNoticiaLoaded extends ReporteState {
  final List<Reporte> reportes;
  final String noticiaId;

  ReportesPorNoticiaLoaded(this.reportes, this.noticiaId);

  @override
  List<Object> get props => [reportes, noticiaId];
}