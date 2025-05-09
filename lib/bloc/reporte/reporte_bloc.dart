import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/bloc/reporte/reporte_event.dart';
import 'package:abaez/bloc/reporte/reporte_state.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository _reporteRepository = di<ReporteRepository>();
  
  ReporteBloc() : super(ReporteInitial()) {
    on<EnviarReporte>(_onEnviarReporte);
  }

  Future<void> _onEnviarReporte(
    EnviarReporte event,
    Emitter<ReporteState> emit,
  ) async {
    try {
      // Indicar que estamos procesando el reporte
      emit(ReporteLoading());

      // Llamar al repositorio para enviar el reporte
      final exito = await _reporteRepository.enviarReporte(
        noticiaId: event.noticiaId,
        motivo: event.motivo,
      );

      // Si la operación fue exitosa
      if (exito) {
        emit(const ReporteSuccess(mensaje: ReporteConstantes.reporteCreado));
      } else {
        // Este caso no debería ocurrir dado que el método lanza excepciones en caso de error
        // Pero lo incluimos por completitud
        emit(const ReporteError(
          errorMessage: ReporteConstantes.errorCrearReporte,
        ));
      }
    } on ApiException catch (e) {
      // Si es una ApiException, emitir un ReporteError con el mensaje y código de estado
      emit(ReporteError(
        errorMessage: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      // Para cualquier otra excepción, registrar y emitir un error genérico
      debugPrint('Error al enviar reporte: $e');
      emit(const ReporteError(
        errorMessage: ReporteConstantes.errorCrearReporte,
      ));
    }
  }
}