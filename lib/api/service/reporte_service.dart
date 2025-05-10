import 'dart:async';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/error_helper.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';

class ReporteService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
    receiveTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
  ));
  
  // URL base para los reportes
  final String _reportesUrl = '${ApiConstantes.newsurl}/reportes';
  
  /// Envía un reporte a la API
  /// 
  /// Parámetros:
  /// - reporte: Objeto Reporte con la información a enviar
  Future<void> enviarReporte(Reporte reporte) async {
    try {
      
      Map<String, dynamic> reporteJson = reporte.toMap();
      
      final response = await _dio.post(
        _reportesUrl,
        data: reporteJson,
      );

      if (response.statusCode != 201) {
        throw ApiException('Error al enviar reporte', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }
}