import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/reportes/reportes_event.dart';
import 'package:abaez/bloc/reportes/reportes_state.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ReportesBloc extends Bloc<ReportesEvent, ReportesState> {
  final ReporteRepository reporteRepository;

  ReportesBloc({ReporteRepository? reporteRepository}) 
  : reporteRepository = reporteRepository ?? ReporteRepository(),
  super(ReporteInitial()) {
    on<EnviarReporte>(_onEnviarReporte);
  }

  Future<void> _onEnviarReporte(
    EnviarReporte event, 
    Emitter<ReportesState> emit
  ) async {
    // Emitir estado de carga
    emit(ReporteLoading());

    try {
      // Intentar enviar el reporte
      await reporteRepository.enviarReporte(event.reporte);
      
      // Si no hay excepciones, emitir éxito
      emit(ReporteSuccess());
    } on ApiException catch (e) {
      // Capturar excepciones específicas de la API
      emit(ReporteError(e.message));
    } catch (e) {
      // Capturar cualquier otra excepción
      emit(ReporteError('Error inesperado: ${e.toString()}'));
    }
  }
}