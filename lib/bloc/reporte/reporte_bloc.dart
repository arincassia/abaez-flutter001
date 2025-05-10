import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:abaez/bloc/reporte/reporte_event.dart';
import 'package:abaez/bloc/reporte/reporte_state.dart';
import 'package:watch_it/watch_it.dart';

/// BLoC that handles the business logic for report operations
class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository _reporteRepository = di<ReporteRepository>();

  /// Constructor that receives a ReporteRepository instance through dependency injection
  ReporteBloc() : super(ReporteInitial()) {
    on<EnviarReporteEvent>(_onEnviarReporte);
  }

  /// Handles the EnviarReporteEvent to send a report
  Future<void> _onEnviarReporte(
    EnviarReporteEvent event,
    Emitter<ReporteState> emit,
  ) async {
    try {
      // Emit loading state
      emit(ReporteLoading());

      // Send the report using the repository
      await _reporteRepository.crearReporte(
        noticiaId: event.noticiaId,
        motivo: event.motivo,
      );

      // Emit success state if the operation completes without errors
      emit(const ReporteSuccess());
    } on ApiException catch (e) {
      // Handle API exceptions by emitting an error state with the exception message
      emit(ReporteError(
        errorMessage: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      // Handle any other exceptions by emitting a generic error state
      emit(ReporteError(
        errorMessage: 'Error inesperado al enviar el reporte: ${e.toString()}',
      ));
    }
  }
}