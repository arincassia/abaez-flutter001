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

  ReporteError(this.message, {int? statusCode});

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

// Estado para la cantidad de reportes por noticia
class ReporteCountLoaded extends ReporteState {
  final String noticiaId;
  final int numeroReportes;
  
  ReporteCountLoaded({
    required this.noticiaId,
    required this.numeroReportes,
  });
  
  @override
  List<Object> get props => [noticiaId, numeroReportes];
}

class ReporteCountDetailLoaded extends ReporteState {
  final String noticiaId;
  final Map<MotivoReporte, int> conteosPorMotivo;
  
  ReporteCountDetailLoaded({
    required this.noticiaId,
    required this.conteosPorMotivo,
  });
  
  int get total => conteosPorMotivo.values.fold(0, (a, b) => a + b);
  
  @override
  List<Object> get props => [noticiaId, conteosPorMotivo];
}