part of 'reportes_bloc.dart';

/// Eventos para el ReportesBloc
abstract class ReportesEvent extends Equatable {
  const ReportesEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para inicializar el BLoC de reportes
class ReporteInitEvent extends ReportesEvent {
  final String? noticiaId;

  const ReporteInitEvent({this.noticiaId});

  @override
  List<Object?> get props => [noticiaId];
}

/// Evento para crear un nuevo reporte
class ReporteCreateEvent extends ReportesEvent {
  final String noticiaId;
  final MotivoReporte motivo;

  const ReporteCreateEvent({required this.noticiaId, required this.motivo});

  @override
  List<Object> get props => [noticiaId, motivo];
}

/// Evento para enviar un reporte al servidor
class ReporteSendEvent extends ReportesEvent {
  final Reporte reporte;

  const ReporteSendEvent({required this.reporte});

  @override
  List<Object> get props => [reporte];
}
