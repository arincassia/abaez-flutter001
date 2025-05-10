import 'package:equatable/equatable.dart';

/// Base class for all report-related states
abstract class ReporteState extends Equatable {
  const ReporteState();

  @override
  List<Object?> get props => [];
}

/// Initial state for report interactions
class ReporteInitial extends ReporteState {}

/// State indicating a report is being processed
class ReporteLoading extends ReporteState {}

/// State indicating a report was successfully submitted
class ReporteSuccess extends ReporteState {
  final String message;

  const ReporteSuccess({this.message = 'Reporte enviado con éxito'});

  @override
  List<Object?> get props => [message];
}

/// State indicating an error occurred while submitting a report
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