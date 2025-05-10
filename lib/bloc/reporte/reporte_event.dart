import 'package:equatable/equatable.dart';
import 'package:abaez/domain/reporte.dart';

abstract class ReporteEvent extends Equatable {
  const ReporteEvent();

  @override
  List<Object> get props => [];
}

class EnviarReporte extends ReporteEvent {
  final Reporte reporte;

  const EnviarReporte(this.reporte);

  @override
  List<Object> get props => [reporte];
}