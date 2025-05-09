import 'package:flutter/foundation.dart';
import 'package:abaez/api/service/reporte_service.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ReporteRepository {
  final ReporteService _service = ReporteService();

  /// Envía un reporte a la API
  Future<void> enviarReporte(Reporte reporte) async {
    try {
      await _service.enviarReporte(reporte);
    } catch (e) {
      if (e is ApiException) {
        rethrow; // Relanza la excepción para que la maneje el BLoC
      }
      debugPrint('Error inesperado al enviar reporte: $e');
      throw ApiException('Error inesperado al enviar reporte.');
    }
  }
}