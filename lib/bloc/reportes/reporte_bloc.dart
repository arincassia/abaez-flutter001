import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/reportes/reporte_event.dart';
import 'package:abaez/bloc/reportes/reporte_state.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository _reporteRepository;

  // Constructor que recibe el repositorio como dependencia
  ReporteBloc({ReporteRepository? reporteRepository})
      : _reporteRepository = reporteRepository ?? di<ReporteRepository>(),
        super(ReporteInitial()) {
    on<CheckReporteStatus>(_onCheckReporteStatus);
    on<EnviarReporte>(_onEnviarReporte);
    on<EnviarReportePorParametros>(_onEnviarReportePorParametros);
    on<FetchReportesNoticia>(_onFetchReportesNoticia);
  }

  Future<void> _onCheckReporteStatus(
    CheckReporteStatus event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());
    try {
      final yaReportada = await _reporteRepository.verificarReporteExistente(
        event.noticiaId,
        event.usuarioId,
      );

      if (yaReportada) {
        emit(ReporteYaEnviado());
      } else {
        emit(ReporteDisponible());
      }
    } catch (e) {
      emit(ReporteError(mensaje: 'Error al verificar estado: ${e.toString()}'));
    }
  }

  Future<void> _onEnviarReporte(
    EnviarReporte event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());
    try {
      // Usa directamente el objeto Reporte completo
      final reporteEnviado = await _reporteRepository.enviarReporte(event.reporte);
      emit(ReporteExitoso());
    } on ApiException catch (e) {
      emit(ReporteError(
        mensaje: e.message,
        statusCode: e.statusCode,
      ));
      
      // Si el error es porque ya reportó, actualizar a ese estado
      if (e.statusCode == 409) {
        emit(ReporteYaEnviado());
      }
    } catch (e) {
      emit(ReporteError(mensaje: 'Error al enviar reporte: ${e.toString()}'));
    }
  }

  // Método para manejar el evento alternativo con parámetros individuales
  Future<void> _onEnviarReportePorParametros(
    EnviarReportePorParametros event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());
    try {
      // Convertir parámetros a un objeto Reporte
      final reporte = event.toReporte();
      
      // Enviar el reporte
      final reporteEnviado = await _reporteRepository.enviarReporte(reporte);
      emit(ReporteExitoso());
    } on ApiException catch (e) {
      emit(ReporteError(
        mensaje: e.message,
        statusCode: e.statusCode,
      ));
      
      if (e.statusCode == 409) {
        emit(ReporteYaEnviado());
      }
    } catch (e) {
      emit(ReporteError(mensaje: 'Error al enviar reporte: ${e.toString()}'));
    }
  }

  Future<void> _onFetchReportesNoticia(
    FetchReportesNoticia event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());
    try {
      final reportes = await _reporteRepository.obtenerReportesPorNoticia(
        event.noticiaId,
      );
      emit(ReportesLoaded(reportes));
    } catch (e) {
      emit(ReporteError(mensaje: 'Error al cargar reportes: ${e.toString()}'));
    }
  }
}