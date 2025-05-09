import 'package:equatable/equatable.dart';
import 'package:abaez/domain/reporte.dart';

/// Estados posibles para el flujo de reportes
abstract class ReporteState extends Equatable {
  const ReporteState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial antes de cualquier acción
class ReporteInitial extends ReporteState {}

/// Estado mientras se procesa una acción de reporte
class ReporteLoading extends ReporteState {}

/// Estado cuando un reporte ya ha sido enviado para esta noticia
class ReporteYaEnviado extends ReporteState {}

/// Estado cuando una noticia puede ser reportada
class ReporteDisponible extends ReporteState {}

/// Estado cuando un reporte se ha enviado correctamente
class ReporteExitoso extends ReporteState {}

/// Estado cuando ocurre un error en el proceso
class ReporteError extends ReporteState {
  final String mensaje;
  final int? statusCode;

  const ReporteError({
    required this.mensaje,
    this.statusCode,
  });

  @override
  List<Object?> get props => [mensaje, statusCode];
}

/// Estado cuando se han cargado los reportes de una noticia
class ReportesLoaded extends ReporteState {
  final List<Reporte> reportes;

  const ReportesLoaded(this.reportes);

  @override
  List<Object?> get props => [reportes];
}