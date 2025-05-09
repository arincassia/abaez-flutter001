import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/exceptions/api_exception.dart';

/// Repositorio para manejar operaciones relacionadas con reportes de noticias
class ReporteService {
  final Dio _dio = Dio();

  /// Verifica que una noticia exista antes de enviar un reporte
  Future<bool> _verificarNoticiaExiste(String noticiaId) async {
    try {
      final response = await _dio.get('${ApiConstantes.newsurl}/$noticiaId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else if (e.response?.statusCode == 404) {
        return false; // La noticia no existe
      } else {
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: e.response?.statusCode,
        );
      }
    }
  }

  /// Envía un reporte sobre una noticia
  ///
  /// [noticiaId] ID de la noticia que se está reportando
  /// [motivo] Motivo del reporte (enum MotivoReporte)
  /// [fecha] Fecha del reporte en formato ISO 8601
  ///
  /// Retorna true si el reporte se envió correctamente, false en caso contrario
  Future<bool> enviarReporte({
    required String noticiaId,
    required MotivoReporte motivo,
    String? fecha,
  }) async {
    // Verificar que la noticia exista
    final noticiaExiste = await _verificarNoticiaExiste(noticiaId);
    if (!noticiaExiste) {
      throw ApiException(
        'La noticia que intentas reportar no existe',
        statusCode: 404,
      );
    }

    // Crear objeto reporte
    final reporte = Reporte(
      noticiaId: noticiaId,
      fecha: fecha ?? DateTime.now().toIso8601String(),
      motivo: motivo,
    );

    try {
      // Crear un formato de JSON específico para la API que evite problemas de serialización
      final customJsonMap = {
        'noticiaId': reporte.noticiaId,
        'fecha': reporte.fecha,
        'motivo': motivo.toApiFormat(), // Usando la extensión para formato API
      }; // Obtener el mapa automático (solo para depuración)
      final jsonMap = reporte.toMap();

      // Depuración: Imprimir los JSON que se enviarían
      debugPrint('Mapa automático JSON (no enviado): $jsonMap');
      debugPrint('Enviando JSON personalizado: $customJsonMap');
      debugPrint('Motivo original codificado: ${motivo.toValue()}');
      debugPrint(
        'Motivo simplificado: ${motivo.toString().split('.').last.toLowerCase()}',
      );

      // URL de la API donde se envía el reporte
      debugPrint('URL del endpoint: ${ApiConstantes.reportesUrl}');

      // Serializar y enviar el reporte con el formato personalizado
      final response = await _dio.post(
        ApiConstantes.reportesUrl,
        data: customJsonMap,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus:
              (status) =>
                  status! < 500, // Aceptar códigos 2xx y 4xx pero no 5xx
        ),
      ); // Depuración: Imprimir la respuesta
      debugPrint(
        'Respuesta del servidor: ${response.statusCode} - ${response.data}',
      );

      // Verificar respuesta
      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('Reporte enviado correctamente');
        return true;
      } else {
        debugPrint('Error al enviar reporte. Código: ${response.statusCode}');
        throw ApiException(
          'Error al enviar el reporte. Código: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Depuración detallada: Imprimir el error de Dio con toda la información posible
      debugPrint('DioException en enviarReporte: ${e.type} - ${e.message}');

      if (e.response != null) {
        debugPrint(
          'Respuesta de error: ${e.response?.statusCode} - ${e.response?.data}',
        );
        debugPrint('Headers de la respuesta: ${e.response?.headers}');
      }

      // Guardar la petición que causó el error
      debugPrint('Request data: ${e.requestOptions.data}');
      debugPrint('Request path: ${e.requestOptions.path}');
      debugPrint('Request headers: ${e.requestOptions.headers}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else if (e.response?.statusCode == 400) {
        // Error de validación - datos incorrectos
        throw ApiException(
          'Datos de reporte inválidos: ${e.response?.data.toString() ?? "Sin detalles"}',
          statusCode: 400,
        );
      } else if (e.response?.statusCode == 500) {
        // Error del servidor - detalles adicionales si están disponibles
        throw ApiException(
          'Error en el servidor al procesar el reporte. Contacte al equipo de backend con este detalle: ${e.response?.data.toString() ?? "Sin detalles"}',
          statusCode: 500,
        );
      } else {
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error inesperado al enviar reporte: $e');
      throw ApiException('Error inesperado al enviar el reporte');
    }
  }

  /// Obtiene todos los reportes para una noticia específica
  ///
  /// [noticiaId] ID de la noticia de la que se quieren obtener reportes
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      final response = await _dio.get(
        ApiConstantes.reportesUrl,
        queryParameters: {'noticiaId': noticiaId},
      );

      final data = response.data as List<dynamic>;

      // Usar el método fromMap generado por dart_mappable
      return data.map((json) => ReporteMapper.fromMap(json)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(ApiConstantes.errorTimeout);
      } else {
        throw ApiException(
          ApiConstantes.errorServer,
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Error inesperado al obtener reportes: $e');
      throw ApiException('Error inesperado al obtener los reportes');
    }
  }

  //   Future<Reporte> crearReporte({
  //     required String noticiaId,
  //     required MotivoReporte motivo,
  //   }) async {
  //     try {
  //       final fecha =
  //           DateTime.now()
  //               .toIso8601String(); // Usamos el método toValue proporcionado por la extensión para asegurar la serialización correcta
  //       final response = await _dio.post(
  //         ApiConstantes.reportesUrl,
  //         data: {
  //           'noticiaId': noticiaId,
  //           'fecha': fecha,
  //           'motivo':
  //               motivo
  //                   .toValue(), // Usamos el método correcto para serializar el enum
  //         },
  //       );
  //       if (response.statusCode == 201 || response.statusCode == 200) {
  //         // Utilizamos fromMap si ya tenemos un Map<String, dynamic>
  //         if (response.data is Map<String, dynamic>) {
  //           return ReporteMapper.fromMap(response.data as Map<String, dynamic>);
  //         } else {
  //           // Si es JSON en formato String, usamos fromJson
  //           return ReporteMapper.fromJson(response.data.toString());
  //         }
  //       } else {
  //         throw ApiException(
  //           'Error al crear reporte',
  //           statusCode: response.statusCode,
  //         );
  //       }
  //     } on DioException catch (e) {
  //       _handleError(e);
  //       rethrow;
  //     } catch (e) {
  //       throw ApiException('Error inesperado: $e');
  //     }
  //   }
  // }
}
