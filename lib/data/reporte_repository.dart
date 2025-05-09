import 'package:abaez/api/service/reporte_service.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:flutter/foundation.dart';

class ReporteRepository {
  final ReporteService _service;

  ReporteRepository({ReporteService? service}) 
    : _service = service ?? ReporteService();

  /// Envía un nuevo reporte (con parámetros individuales)
  Future<Reporte> crearReportePorParametros({
    required String noticiaId,
    required String usuarioId, 
    required MotivoReporte motivo,
    String? descripcion,
  }) async {
    try {
      // Validaciones básicas
      if (noticiaId.isEmpty) {
        throw ApiException('El ID de la noticia es requerido', statusCode: 400);
      }
      if (usuarioId.isEmpty) {
        throw ApiException('El ID del usuario es requerido', statusCode: 400);
      }

      // Crear objeto reporte
      final reporte = Reporte.crear(
        noticiaId: noticiaId,
        usuarioId: usuarioId,
        motivo: motivo,
        descripcion: descripcion,
      );
      
      // Usar el servicio para enviar el reporte
      return await _service.enviarReporte(reporte);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error al crear reporte: $e');
      throw ApiException('Error al crear el reporte');
    }
  }

  /// Envía un nuevo reporte
  Future<Reporte> enviarReporte(Reporte reporte) async {
    try {
      // La validación y verificación de duplicados ya se realiza en el servicio,
      // así que simplemente pasamos el reporte al servicio
      return await _service.enviarReporte(reporte);
    } catch (e) {
      // Solo propagamos la excepción, ya que el servicio ya maneja los errores específicos
      rethrow;
    }
  }

  /// Verifica si una noticia ya fue reportada por el usuario
  Future<bool> verificarReporteExistente(String noticiaId, String usuarioId) async {
    try {
      return await _service.verificarReporteExistente(noticiaId, usuarioId);
    } catch (e) {
      debugPrint('Error al verificar reporte: $e');
      return false; // En caso de error, asumimos que no existe el reporte para permitir continuar
    }
  }

  /// Obtiene todos los reportes de una noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      if (noticiaId.isEmpty) {
        throw ApiException('El ID de la noticia es requerido', statusCode: 400);
      }
      return await _service.obtenerReportesPorNoticia(noticiaId);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('Error al obtener reportes: $e');
      throw ApiException('Error al obtener reportes');
    }
  }
}