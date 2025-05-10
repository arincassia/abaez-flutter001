import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/exceptions/api_exception.dart';

part 'reportes_event.dart';
part 'reportes_state.dart';

/// BLoC para manejar la lógica de reportes
class ReportesBloc extends Bloc<ReportesEvent, ReportesState> {
  // Crear una instancia de ReporteRepository directamente
  final ReporteRepository _reporteRepository = ReporteRepository();

  /// Constructor del ReportesBloc
  ReportesBloc() : super(ReportesInitial()) {
    on<ReporteInitEvent>(_onInit);
    on<ReporteCreateEvent>(_onCreate);
    on<ReporteSendEvent>(_onSendReporte);
    debugPrint('ReportesBloc: Inicializado');
  }

  /// Maneja la inicialización del ReportesBloc
  Future<void> _onInit(
    ReporteInitEvent event,
    Emitter<ReportesState> emit,
  ) async {
    emit(ReportesLoading());

    try {
      if (event.noticiaId != null) {
        // Cargar reportes de una noticia específica
        final reportes = await _reporteRepository.obtenerReportesPorNoticia(
          event.noticiaId!,
        );
        emit(ReportesLoaded(reportes: reportes, timestamp: DateTime.now()));
      } else {
        emit(ReportesInitial());
      }
    } on ApiException catch (e) {
      emit(ReporteError(errorMessage: e.message));
    } catch (e) {
      emit(ReporteError(errorMessage: 'Error inesperado: ${e.toString()}'));
    }
  }

  /// Maneja la creación de un reporte
  Future<void> _onCreate(
    ReporteCreateEvent event,
    Emitter<ReportesState> emit,
  ) async {
    emit(ReporteLoading());

    try {
      // Crear un objeto de reporte con los datos proporcionados
      final motivo = event.motivo;
      final reporte = Reporte(
        noticiaId: event.noticiaId,
        fecha: DateTime.now().toIso8601String(),
        motivo: motivo,
      );

      // Emitir evento para enviar el reporte
      add(ReporteSendEvent(reporte: reporte));
    } catch (e) {
      emit(
        ReporteError(
          errorMessage: 'Error al crear el reporte: ${e.toString()}',
        ),
      );
    }
  }

  /// Maneja el envío del reporte al servidor
  Future<void> _onSendReporte(
    ReporteSendEvent event,
    Emitter<ReportesState> emit,
  ) async {
    debugPrint('ReportesBloc: Procesando evento ReporteSendEvent');
    emit(ReporteLoading());

    try {
      // Log de depuración
      debugPrint(
        'ReportesBloc: Enviando reporte para noticia: ${event.reporte.noticiaId}',
      );
      debugPrint('ReportesBloc: Motivo del reporte: ${event.reporte.motivo}');

      // Enviar el reporte usando el repositorio
      final success = await _reporteRepository.enviarReporte(
        noticiaId: event.reporte.noticiaId,
        motivo: event.reporte.motivo,
        fecha: event.reporte.fecha,
      );

      if (success) {
        debugPrint('ReportesBloc: Reporte enviado correctamente');
        emit(ReporteSuccess(reporte: event.reporte, timestamp: DateTime.now()));
      } else {
        debugPrint('ReportesBloc: No se pudo enviar el reporte');
        emit(const ReporteError(errorMessage: 'No se pudo enviar el reporte'));
      }
    } on ApiException catch (e) {
      debugPrint('ReportesBloc: ApiException: ${e.message}');
      emit(ReporteError(errorMessage: e.message));
    } catch (e) {
      debugPrint('ReportesBloc: Error inesperado: $e');
      emit(ReporteError(errorMessage: 'Error inesperado: ${e.toString()}'));
    }
  }
}
