import 'package:dio/dio.dart';
import 'package:abaez/constants.dart'; 
import 'package:abaez/domain/reporte.dart'; 
import 'package:abaez/exceptions/api_exception.dart'; 
import 'package:flutter/foundation.dart';

class ReporteService {
  final Dio dio = Dio()
    ..options.connectTimeout = const Duration(seconds: ApiConstantes.timeoutSeconds)
    // Añadimos interceptor para ver las peticiones y respuestas
    ..interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
    ));

  /// Envía un reporte después de verificar que la noticia existe
  Future<void> enviarReporte(Reporte reporte) async {
    try {
      debugPrint('Iniciando envío de reporte: ${reporte.toMap()}');
      
      // Verificar que la noticia existe
      final verificacionResponse = await dio.get(
        '${ApiConstantes.noticiasUrl}/${reporte.noticiaId}',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500
        ),
      );
      
      if (verificacionResponse.statusCode != 200) {
        debugPrint('Error en verificación: ${verificacionResponse.statusCode}');
        throw ApiException('La noticia no existe o no está disponible.');
      }
      
      // Preparamos el mapa manualmente para asegurar serialización correcta del enum
      final reporteMap = {
        'noticiaId': reporte.noticiaId,
        'fecha': reporte.fecha,
        'motivo': reporte.motivo.toString().split('.').last, // Convertir enum a string simple
      };
      
      debugPrint('Enviando reporte: $reporteMap');

      // Enviar el reporte al endpoint
      final response = await dio.post(
        ApiConstantes.reportesUrl,
        data: reporteMap,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500
        ),
      );

      // Manejar la respuesta
      debugPrint('Respuesta: ${response.statusCode} - ${response.data}');
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        String errorMessage;
        if (response.data != null && response.data is Map) {
          errorMessage = response.data['error'] ?? 
                        response.data['message'] ?? 
                        'Error desconocido (código: ${response.statusCode})';
        } else {
          errorMessage = 'Error desconocido (código: ${response.statusCode})';
        }
        throw ApiException('Error al enviar el reporte: $errorMessage');
      }
    } on DioException catch (e) {
      debugPrint('DioException: ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.connectionError) {
        throw ApiException('Error de conexión: verifica tu internet');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ApiException('Tiempo de espera agotado: el servidor no responde');
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        String message = 'Error en la respuesta del servidor';
        if (e.response!.data != null && e.response!.data is Map) {
          message = e.response!.data['message'] ?? message;
        }
        throw ApiException('Error $statusCode: $message');
      } else {
        throw ApiException('Error de red: ${e.message}');
      }
    } catch (e) {
      debugPrint('Error general: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado: ${e.toString()}');
    }
  }
}