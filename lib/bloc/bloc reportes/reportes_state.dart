part of 'reportes_bloc.dart';

/// Estados para el ReportesBloc
abstract class ReportesState extends Equatable {
  const ReportesState();

  @override
  List<Object> get props => [];
}

/// Estado inicial
final class ReportesInitial extends ReportesState {}

/// Estado de carga
final class ReportesLoading extends ReportesState {}

/// Estado específico para la carga de un reporte individual
final class ReporteLoading extends ReportesState {}

/// Estado cuando un reporte se envía exitosamente
final class ReporteSuccess extends ReportesState {
  final Reporte reporte;
  final DateTime timestamp;

  const ReporteSuccess({required this.reporte, required this.timestamp});

  @override
  List<Object> get props => [reporte, timestamp];
}

/// Estado cuando ocurre un error al enviar el reporte
final class ReporteError extends ReportesState {
  final String errorMessage;

  const ReporteError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Estado cuando los reportes se han cargado correctamente
final class ReportesLoaded extends ReportesState {
  final List<Reporte> reportes;
  final DateTime timestamp;

  const ReportesLoaded({required this.reportes, required this.timestamp});

  @override
  List<Object> get props => [reportes, timestamp];
}
