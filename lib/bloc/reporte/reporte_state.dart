import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/domain/reporte.dart';

@immutable
abstract class ReporteState extends Equatable {
  const ReporteState();
  
  @override
  List<Object?> get props => [];
}

class ReporteInitial extends ReporteState {}

class ReporteLoading extends ReporteState {}

class ReporteSuccess extends ReporteState {
  final String mensaje;
  
  const ReporteSuccess({required this.mensaje});
  
  @override
  List<Object?> get props => [mensaje];
}

class ReporteError extends ReporteState {
  final String errorMessage;
  final int? statusCode;
  
  const ReporteError({
    required this.errorMessage,
    this.statusCode,
  });
  
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

// Nuevo estado para estadísticas de reportes
class ReporteEstadisticasLoaded extends ReporteState {
  final String noticiaId;
  final Map<MotivoReporte, int> estadisticas;
  
  const ReporteEstadisticasLoaded({
    required this.noticiaId,
    required this.estadisticas,
  });
  
  @override
  List<Object?> get props => [noticiaId, estadisticas];
}

// Nuevo estado para verificación de reportes del usuario
class ReporteUsuarioVerificado extends ReporteState {
  final String noticiaId;
  final MotivoReporte motivo;
  final bool reportado;
  
  const ReporteUsuarioVerificado({
    required this.noticiaId,
    required this.motivo,
    required this.reportado,
  });
  
  @override
  List<Object?> get props => [noticiaId, motivo, reportado];
}