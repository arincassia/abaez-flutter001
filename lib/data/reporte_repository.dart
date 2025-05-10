import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/noticia_sevice.dart';
import 'package:abaez/api/service/reporte_service.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ReporteRepository {
  final ReporteService _reporteService = ReporteService();
  final NoticiaService _noticiaService = NoticiaService();

  /// Enviar un reporte de una noticia
  /// 
  /// Este método:
  /// 1. Verifica que la noticia exista consultando /noticias/<noticiaId>
  /// 2. Envía el reporte a /reportes usando una solicitud POST
  /// 
  /// Parámetros:
  /// - noticiaId: ID de la noticia a reportar
  /// - motivo: Motivo del reporte (enum MotivoReporte)
  /// 
  /// Excepciones:
  /// - ApiException: Si la noticia no existe o si ocurre un error durante el proceso
  Future<void> enviarReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      try {
        await _noticiaService.getNoticiaById(noticiaId);
      } catch (e) {
        throw ApiException('La noticia no existe o fue eliminada');
      }

    
      final reporte = Reporte(
        noticiaId: noticiaId,
        fecha: DateTime.now(),
        motivo: motivo,
      );

      await _reporteService.enviarReporte(reporte);
    } on ApiException {
      rethrow; // Relanza la excepción para que la maneje la capa superior
    } catch (e) {
      debugPrint('Error inesperado al enviar reporte: $e');
      throw ApiException('Error inesperado al enviar reporte');
    }
  }
}