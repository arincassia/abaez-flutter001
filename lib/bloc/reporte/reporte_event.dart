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