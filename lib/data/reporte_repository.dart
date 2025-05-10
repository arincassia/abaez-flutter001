import 'package:abaez/domain/reporte.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/api/service/reporte_service.dart';

class ReporteRepository {
  final ReporteService _service = ReporteService();

  ReporteRepository();

  /// Verifies if a news item exists by its ID
  ///
  /// Returns the Noticia object if it exists
  /// Throws [ApiException] if the news doesn't exist or there's an error
  Future<Noticia> verificarNoticia(String noticiaId) async {
    try {
      return await _service.verificarNoticiaExiste(noticiaId);
    } on ApiException {
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }

  Future<int> getReportesPorNoticia(String noticiaId) async {
    try {
      final List<Reporte> reportes = await obtenerReportes();
      return reportes.where((reporte) => reporte.noticiaId == noticiaId).length;
    } catch (e) {
      print('Error al obtener reportes: $e');
      return 0;
    }
  }

  Future<void> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      final reporte = Reporte(
        noticiaId: noticiaId,
        motivo: motivo,
        fecha: DateTime.now().toIso8601String(),
      );

      // Validate report data if necessary
      _validarReporte(reporte);

      // Send the report
      await _service.enviarReporte(reporte);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Error al procesar el reporte: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Validates report data before sending
  ///
  /// Throws an exception if the report data is invalid
  void _validarReporte(Reporte reporte) {
    if (reporte.noticiaId.isEmpty) {
      throw ApiException('El ID de la noticia es obligatorio', statusCode: 422);
    }

    if (reporte.fecha.isEmpty) {
      throw ApiException(
        'La fecha del reporte es obligatoria',
        statusCode: 422,
      );
    }
  }

  /// Throws [ApiException] if the report doesn't exist or there's an error
  Future<Reporte> obtenerReporte(String id) async {
    try {
      final Map<String, dynamic> reporteData = await _service.obtenerReporteRaw(
        id,
      );
      return ReporteMapper.fromMap(reporteData);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Error al procesar datos del reporte: ${e.toString()}',
        statusCode: 422,
      );
    }
  }

  /// Gets all reports
  ///
  /// Returns a list of Reporte objects
  /// Throws [ApiException] if there's an error
  Future<List<Reporte>> obtenerReportes() async {
    try {
      final List<Map<String, dynamic>> reportesData =
          await _service.obtenerReportesRaw();

      return reportesData.map((data) => ReporteMapper.fromMap(data)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Error al procesar lista de reportes: ${e.toString()}',
        statusCode: 422,
      );
    }
  }

  Future<void> reportarNoticia({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    await crearReporte(noticiaId: noticiaId, motivo: motivo);
  }
}

// Import the ReporteService class
