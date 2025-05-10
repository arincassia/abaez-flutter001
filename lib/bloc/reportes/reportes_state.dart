import 'package:equatable/equatable.dart';

// Clase base para los estados de reportes
abstract class ReportesState extends Equatable {
  const ReportesState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class ReporteInitial extends ReportesState {}

// Estado mientras se envía el reporte
class ReporteLoading extends ReportesState {}

// Estado cuando el reporte se envía correctamente
class ReporteSuccess extends ReportesState {}

// Estado cuando ocurre un error (contiene un mensaje)
class ReporteError extends ReportesState {
  final String errorMessage;

  const ReporteError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}