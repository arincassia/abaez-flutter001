import 'package:equatable/equatable.dart';
import 'package:abaez/domain/reporte.dart';

abstract class ReporteEvent extends Equatable {
  const ReporteEvent();

  @override
  List<Object?> get props => [];
}

class CheckReporteStatus extends ReporteEvent {
  final String noticiaId;
  final String usuarioId;

  const CheckReporteStatus({
    required this.noticiaId,
    required this.usuarioId,
  });

  @override
  List<Object?> get props => [noticiaId, usuarioId];
}

class EnviarReporte extends ReporteEvent {
  /// El reporte completo a enviar
  final Reporte reporte;

  const EnviarReporte({
    required this.reporte,
  });

  @override
  List<Object?> get props => [reporte];
}

/// Evento alternativo si prefieres mantener parámetros individuales
class EnviarReportePorParametros extends ReporteEvent {
  final String noticiaId;
  final String usuarioId;
  final MotivoReporte motivo;
  final String? descripcion;

  const EnviarReportePorParametros({
    required this.noticiaId,
    required this.usuarioId,
    required this.motivo,
    this.descripcion,
  });

  /// Convierte los parámetros a un objeto Reporte
  Reporte toReporte() {
    return Reporte.crear(
      noticiaId: noticiaId,
      usuarioId: usuarioId,
      motivo: motivo,
      descripcion: descripcion,
    );
  }

  @override
  List<Object?> get props => [noticiaId, usuarioId, motivo, descripcion];
}

class FetchReportesNoticia extends ReporteEvent {
  final String noticiaId;

  const FetchReportesNoticia({required this.noticiaId});

  @override
  List<Object?> get props => [noticiaId];
}