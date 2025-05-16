import 'package:abaez/api/service/reporte_service.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ReporteRepository {
  final ReporteService _reporteService = ReporteService();

  // Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      return await _reporteService.getReportes();
    } on ApiException catch (e) {
      throw Exception('Error al obtener reportes: ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener reportes: ${e.toString()}');
    }
  }

  // Crear un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      return await _reporteService.crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      );
    } on ApiException catch (e) {
      throw Exception('Error al crear reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error al crear reporte: ${e.toString()}');
    }
  }

  // Obtener reportes por id de noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      return await _reporteService.getReportesPorNoticia(noticiaId);
    } on ApiException catch (e) {
      throw Exception('Error al obtener reportes por noticia: ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener reportes por noticia: ${e.toString()}');
    }
  }

  // Eliminar un reporte
  Future<void> eliminarReporte(String reporteId) async {
    try {
      await _reporteService.eliminarReporte(reporteId);
    } on ApiException catch (e) {
      throw Exception('Error al eliminar reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error al eliminar reporte: ${e.toString()}');
    }
  }

  // Obtener cantidad de reportes por id de noticia
  Future<int> obtenerCantidadReportesPorNoticia(String noticiaId) async {
    try {
      return await _reporteService.getCantidadReportesPorNoticia(noticiaId);
    } on ApiException catch (e) {
      throw Exception('Error al obtener cantidad de reportes: ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener cantidad de reportes: ${e.toString()}');
    }
  }

  Future<Map<MotivoReporte, int>> obtenerConteoReportesPorTipo(String noticiaId) async {
  return await _reporteService.getConteoReportesPorTipo(noticiaId);
}
}