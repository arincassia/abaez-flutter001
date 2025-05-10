import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:abaez/bloc/reporte/reporte_event.dart';
import 'package:abaez/bloc/reporte/reporte_state.dart';
import 'package:watch_it/watch_it.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository _reporteRepository;

  ReporteBloc({ReporteRepository? reporteRepository}) 
      : _reporteRepository = reporteRepository ?? di<ReporteRepository>(),
        super(ReporteInitial()) {
    on<EnviarReporte>(_onEnviarReporte);
  }

  Future<void> _onEnviarReporte(
    EnviarReporte event,
    Emitter<ReporteState> emit,
  ) async {
    emit(ReporteLoading());
    
    try {
      await _reporteRepository.enviarReporte(
        noticiaId: event.reporte.noticiaId,
        motivo: event.reporte.motivo,
      );
      emit(ReporteSuccess());
    } on ApiException catch (e) {
      emit(ReporteError(e.message));
    } catch (e) {
      emit(ReporteError('Error al enviar el reporte: ${e.toString()}'));
    }
  }
}