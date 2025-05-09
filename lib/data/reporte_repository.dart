import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/reporte_service.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ReporteRepository {
  final ReporteService _reporteService = ReporteService();
  
  // Caché de reportes (similar a preferencias)
  List<Reporte>? _cachedReportes;

  /// Envía un reporte de una noticia
  Future<bool> enviarReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      // Verificar que la noticia exista
      final noticiaExiste = await _reporteService.verificarNoticiaExiste(noticiaId);
      
      if (!noticiaExiste) {
        throw ApiException(ReporteConstantes.noticiaNoExiste);
      }
      
      // Crear el objeto Reporte
      final reporte = Reporte(
        noticiaId: noticiaId,
        fecha: DateTime.now().toIso8601String(),
        motivo: motivo,
      );
      
      // Enviar el reporte
      await _reporteService.enviarReporte(reporte);
      
      // Invalidar caché si la operación fue exitosa
      invalidarCache();
      
      return true;
    } catch (e) {
      debugPrint('Error al enviar reporte: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(ReporteConstantes.errorCrearReporte);
    }
  }

  /// Obtiene todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      // Si hay caché, devolver la caché
      if (_cachedReportes != null) {
        return _cachedReportes!;
      }
      
      // Si no hay caché, obtener de la API
      final reportes = await _reporteService.obtenerReportes();
      
      // Guardar en caché
      _cachedReportes = reportes;
      
      return reportes;
    } catch (e) {
      debugPrint('Error al obtener reportes: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(ReporteConstantes.errorObtenerReportes);
    }
  }
  
  /// Obtiene estadísticas de reportes por motivo
  Future<Map<MotivoReporte, int>> obtenerEstadisticasReportes() async {
    try {
      final reportes = await obtenerReportes();
      final estadisticas = <MotivoReporte, int>{};
      
      // Inicializar contadores
      for (final motivo in MotivoReporte.values) {
        estadisticas[motivo] = 0;
      }
      
      // Contar reportes por motivo
      for (final reporte in reportes) {
        estadisticas[reporte.motivo] = (estadisticas[reporte.motivo] ?? 0) + 1;
      }
      
      return estadisticas;
    } catch (e) {
      debugPrint('Error al obtener estadísticas: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(ReporteConstantes.errorObtenerReportes);
    }
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    _cachedReportes = null;
  }
}