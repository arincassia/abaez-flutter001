import 'package:equatable/equatable.dart';
import 'package:abaez/domain/reporte.dart';

abstract class ReporteEvent extends Equatable {
  const ReporteEvent();

  @override
  List<Object?> get props => [];
}

class EnviarReporte extends ReporteEvent {
  final String noticiaId;
  final MotivoReporte motivo;

  const EnviarReporte({
    required this.noticiaId,
    required this.motivo,
  });

  @override
  List<Object?> get props => [noticiaId, motivo];
}

// Nuevo evento para cargar estadísticas de reportes para una noticia específica
class CargarEstadisticasReporte extends ReporteEvent {
  final String noticiaId;

  const CargarEstadisticasReporte({required this.noticiaId});

  @override
  List<Object?> get props => [noticiaId];
}

// Nuevo evento para verificar si el usuario ha reportado una noticia
class VerificarReporteUsuario extends ReporteEvent {
  final String noticiaId;
  final MotivoReporte motivo;

  const VerificarReporteUsuario({
    required this.noticiaId,
    required this.motivo,
  });

  @override
  List<Object?> get props => [noticiaId, motivo];
}