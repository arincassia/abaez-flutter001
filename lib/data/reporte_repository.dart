import 'package:abaez/api/service/reporte_service.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/data/base_repository.dart';

// Adaptador para ReporteService
class ReporteServiceAdapter extends BaseService<Reporte> {
  final ReporteService _service = ReporteService();
  
  @override
  Future<List<Reporte>> getAll() {
    return _service.getReportes();
  }
  
  @override
  Future<void> create(dynamic data) async {
    await _service.crearReporte(
      noticiaId: data['noticiaId'],
      motivo: data['motivo'],
    );
  }
  
  @override
  Future<void> update(String id, dynamic data) {
    throw UnimplementedError('Actualización de reportes no implementada');
  }
  
  @override
  Future<void> delete(String id) {
    return _service.eliminarReporte(id);
  }
  
  // Métodos específicos
  Future<List<Reporte>> getReportesPorNoticia(String noticiaId) {
    return _service.getReportesPorNoticia(noticiaId);
  }
  
  Future<int> getCantidadReportesPorNoticia(String noticiaId) {
    return _service.getCantidadReportesPorNoticia(noticiaId);
  }
  
  Future<Map<MotivoReporte, int>> getConteoReportesPorTipo(String noticiaId) {
    return _service.getConteoReportesPorTipo(noticiaId);
  }
  
  Future<Reporte?> crearReporte({required String noticiaId, required MotivoReporte motivo}) {
    return _service.crearReporte(noticiaId: noticiaId, motivo: motivo);
  }
}

class ReporteRepository extends BaseRepository<Reporte, ReporteServiceAdapter> {
  ReporteRepository() : super(ReporteServiceAdapter(), 'Reporte');

    @override
  void validarEntidad(Reporte reporte) {
    // Implement validation logic for Reporte entities
    if (reporte.noticiaId == '' || reporte.noticiaId.isEmpty) {
      throw Exception('El ID de noticia no puede estar vacío');
    }
    // Add any other validations specific to Reporte entities
  }

  // Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() => getAll();

  // Crear un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      return await (service).crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      );
    } catch (e) {
      throw handleError(e, 'crear reporte');
    }
  }

  // Obtener reportes por id de noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      return await (service).getReportesPorNoticia(noticiaId);
    } catch (e) {
      throw handleError(e, 'obtener reportes por noticia');
    }
  }

  // Eliminar un reporte
  Future<void> eliminarReporte(String reporteId) => delete(reporteId);

  // Obtener cantidad de reportes por id de noticia
  Future<int> obtenerCantidadReportesPorNoticia(String noticiaId) async {
    try {
      return await (service).getCantidadReportesPorNoticia(noticiaId);
    } catch (e) {
      throw handleError(e, 'obtener cantidad de reportes');
    }
  }

  Future<Map<MotivoReporte, int>> obtenerConteoReportesPorTipo(String noticiaId) async {
    try {
      return await (service).getConteoReportesPorTipo(noticiaId);
    } catch (e) {
      throw handleError(e, 'obtener conteo de reportes por tipo');
    }
  }
}