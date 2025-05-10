import 'package:equatable/equatable.dart';
import 'package:abaez/domain/reporte.dart';
// Clase base para los eventos de reportes
abstract class ReportesEvent extends Equatable {
  const ReportesEvent();

  @override
  List<Object?> get props => [];
}

// Evento para enviar un reporte
class EnviarReporte extends ReportesEvent {
  final Reporte reporte;

  const EnviarReporte(this.reporte);

  @override
  List<Object?> get props => [reporte];
}