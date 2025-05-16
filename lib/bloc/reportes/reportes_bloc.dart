import 'package:abaez/exceptions/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/reportes/reportes_event.dart';
import 'package:abaez/bloc/reportes/reportes_state.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:watch_it/watch_it.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteRepository reporteRepository = di<ReporteRepository>();

  ReporteBloc() : super(ReporteInitial()) {
    on<ReporteInitEvent>(_onInit);
    on<ReporteCreateEvent>(_onCreateReporte);
    on<ReporteDeleteEvent>(_onDeleteReporte);
    on<ReporteGetByNoticiaEvent>(_onGetByNoticia);
    on<ReporteGetCountEvent>(_onGetCount);
    on<ReporteGetCountDetailEvent>(_onGetCountDetail);
  }

  Future<void> _onInit(ReporteInitEvent event, Emitter<ReporteState> emit) async {
    emit(ReporteLoading());

    try {
      final reportes = await reporteRepository.obtenerReportes();
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al cargar reportes: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onCreateReporte(ReporteCreateEvent event, Emitter<ReporteState> emit) async {
    emit(ReporteLoading());

    try {
      final reporte = await reporteRepository.crearReporte(
        noticiaId: event.noticiaId,
        motivo: event.motivo,
      );
      emit(ReporteCreated(reporte!));

      // Recargar la lista después de crear
      final reportes = await reporteRepository.obtenerReportes();
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al crear reporte: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onDeleteReporte(ReporteDeleteEvent event, Emitter<ReporteState> emit) async {
    emit(ReporteLoading());

    try {
      await reporteRepository.eliminarReporte(event.id);
      emit(ReporteDeleted(event.id));

      // Recargar la lista después de eliminar
      final reportes = await reporteRepository.obtenerReportes();
      emit(ReporteLoaded(reportes, DateTime.now()));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al eliminar reporte: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onGetByNoticia(ReporteGetByNoticiaEvent event, Emitter<ReporteState> emit) async {
    emit(ReporteLoading());

    try {
      final reportes = await reporteRepository.obtenerReportesPorNoticia(event.noticiaId);
      emit(ReportesPorNoticiaLoaded(reportes, event.noticiaId));
    } catch (e) {
      final int? statusCode = e is ApiException ? e.statusCode : null;
      emit(ReporteError('Error al obtener reportes por noticia: ${e.toString()}', statusCode: statusCode));
    }
  }

  Future<void> _onGetCount(ReporteGetCountEvent event, Emitter<ReporteState> emit) async {
  emit(ReporteLoading());

  try {
    final numeroReportes = await reporteRepository.obtenerCantidadReportesPorNoticia(event.noticiaId);
    emit(ReporteCountLoaded(noticiaId: event.noticiaId, numeroReportes: numeroReportes));
  } catch (e) {
    final int? statusCode = e is ApiException ? e.statusCode : null;
    emit(ReporteError('Error al obtener cantidad de reportes: ${e.toString()}', statusCode: statusCode));
  }
}

Future<void> _onGetCountDetail(
  ReporteGetCountDetailEvent event, 
  Emitter<ReporteState> emit
) async {
  emit(ReporteLoading());

  try {
    final conteosPorMotivo = await reporteRepository.obtenerConteoReportesPorTipo(event.noticiaId);
    emit(ReporteCountDetailLoaded(
      noticiaId: event.noticiaId, 
      conteosPorMotivo: conteosPorMotivo
    ));
  } catch (e) {
    final int? statusCode = e is ApiException ? e.statusCode : null;
    emit(ReporteError('Error al obtener conteo por tipo: ${e.toString()}', statusCode: statusCode));
  }
}
}