import 'package:equatable/equatable.dart';
import 'package:abaez/domain/reporte.dart';

abstract class ReporteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento para inicializar y cargar todos los reportes
class ReporteInitEvent extends ReporteEvent {}

// Evento para crear un nuevo reporte
class ReporteCreateEvent extends ReporteEvent {
  final String noticiaId;
  final MotivoReporte motivo;

  ReporteCreateEvent({
    required this.noticiaId,
    required this.motivo,
  });

  @override
  List<Object?> get props => [noticiaId, motivo];
}

// Evento para eliminar un reporte
class ReporteDeleteEvent extends ReporteEvent {
  final String id;

  ReporteDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

// Evento para obtener reportes por ID de noticia
class ReporteGetByNoticiaEvent extends ReporteEvent {
  final String noticiaId;

  ReporteGetByNoticiaEvent({required this.noticiaId});

  @override
  List<Object?> get props => [noticiaId];
}