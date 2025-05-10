import 'package:equatable/equatable.dart';
import 'package:abaez/domain/reporte.dart';

/// Base class for all report-related events
abstract class ReporteEvent extends Equatable {
  const ReporteEvent();

  @override
  List<Object?> get props => [];
}


class EnviarReporteEvent extends ReporteEvent {
  final String noticiaId;
  final MotivoReporte motivo; // Debe ser el enum directamente

  const EnviarReporteEvent({
    required this.noticiaId,
    required this.motivo,
  });
}