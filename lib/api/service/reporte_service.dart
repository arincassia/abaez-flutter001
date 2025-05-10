import 'dart:async';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';

class ReporteService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
    receiveTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
  ));

  // URL base para los endpoints de reportes
  final String _baseUrl = ApiConstantes.reportesUrl;

  /// Manejo centralizado de errores
  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      throw Exception(CategoriaConstantes.errorTimeout);
    }

    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        throw Exception(CategoriaConstantes.mensajeError);
      case 401:
        throw Exception(ErrorConstantes.errorUnauthorized);
      case 404:
        throw Exception(ErrorConstantes.errorNotFound);
      case 500:
        throw Exception(ErrorConstantes.errorServer);
      default:
        throw Exception('Error desconocido: ${statusCode ?? 'Sin código'}');
    }
  }
  /// Obtiene todos los reportes
  Future<List<Reporte>> getReportes() async {
    try {
      final response = await _dio.get(_baseUrl);
      
      if (response.statusCode == 200) {
        final List<dynamic> reportesJson = response.data;
        return reportesJson.map((json) {
          // Convertimos correctamente según el tipo de dato recibido
          if (json is Map<String, dynamic>) {
            return ReporteMapper.fromMap(json);
          } else {
            return ReporteMapper.fromJson(json.toString());
          }
        }).toList();
      } else {
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow; // Nunca debería llegar aquí porque _handleError siempre lanza una excepción
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Crea un nuevo reporte
  Future<Reporte> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      final fecha = DateTime.now().toIso8601String();      // Usamos el método toValue proporcionado por la extensión para asegurar la serialización correcta
      final response = await _dio.post(
        _baseUrl,
        data: {
          'noticiaId': noticiaId,
          'fecha': fecha,
          'motivo': motivo.toValue(), // Usamos el método correcto para serializar el enum
        },
      );
        if (response.statusCode == 201 || response.statusCode == 200) {
        // Utilizamos fromMap si ya tenemos un Map<String, dynamic>
        if (response.data is Map<String, dynamic>) {
          return ReporteMapper.fromMap(response.data as Map<String, dynamic>);
        } else {
          // Si es JSON en formato String, usamos fromJson
          return ReporteMapper.fromJson(response.data.toString());
        }
      } else {
        throw ApiException('Error al crear reporte', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Obtiene reportes por ID de noticia
  Future<List<Reporte>> getReportesPorNoticia(String noticiaId) async {
    try {
      final response = await _dio.get('$_baseUrl/noticia/$noticiaId');
        if (response.statusCode == 200) {
        final List<dynamic> reportesJson = response.data;
        return reportesJson.map((json) {
          // Convertimos correctamente según el tipo de dato recibido
          if (json is Map<String, dynamic>) {
            return ReporteMapper.fromMap(json);
          } else {
            return ReporteMapper.fromJson(json.toString());
          }
        }).toList();
      } else {
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Elimina un reporte
  Future<void> eliminarReporte(String reporteId) async {
    try {
      final response = await _dio.delete('$_baseUrl/$reporteId');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('Error al eliminar reporte', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }
}