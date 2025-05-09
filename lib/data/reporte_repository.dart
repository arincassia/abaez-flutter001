import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/reporte_service.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ReporteRepository {
  final ReporteService _service = ReporteService();

  /// Envía un reporte sobre una noticia
  Future<bool> enviarReporte({
    required String noticiaId,
    required MotivoReporte motivo,
    String? fecha,
  }) async {
    try {
      return await _service.enviarReporte(
        noticiaId: noticiaId,
        motivo: motivo,
        fecha: fecha,
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow; // Relanza la excepción para que la maneje el BLoC
      }
      debugPrint('Error inesperado al enviar reporte: $e');
      throw ApiException('Error inesperado al enviar reporte.');
    }
  }

  /// Obtiene todos los reportes para una noticia específica
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      return await _service.obtenerReportesPorNoticia(noticiaId);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error inesperado al obtener reportes: $e');
      throw ApiException('Error inesperado al obtener reportes.');
    }
  }

  /// Verifica si una noticia ha sido reportada anteriormente por el mismo motivo
  Future<bool> verificarReporteExistente({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      final reportes = await obtenerReportesPorNoticia(noticiaId);
      return reportes.any((reporte) => reporte.motivo == motivo);
    } catch (e) {
      debugPrint('Error al verificar reporte existente: $e');
      return false; // En caso de error, asumimos que no existe reporte previo
    }
  }
}
