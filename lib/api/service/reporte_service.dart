import 'dart:async';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/exceptions/api_exception.dart';

class ReporteService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: ApiConstantes.timeoutSeconds),
    receiveTimeout: const Duration(seconds: ApiConstantes.timeoutSeconds),
  ));

  /// Verifica si una noticia existe
  Future<bool> verificarNoticiaExiste(String noticiaId) async {
    try {
      final response = await _dio.get(
        '${ApiConstantes.noticiasUrl}/$noticiaId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false; // La noticia no existe
      }
      throw ApiException(ApiConstantes.errorTimeout);
    }
  }

  /// Envía un reporte
  Future<void> enviarReporte(Reporte reporte) async {
    try {
      // Usando el método generado por dart_mappable
      final Map<String, dynamic> reporteData = reporte.toMap();
      
      await _dio.post(
        ApiConstantes.reportesUrl,
        data: reporteData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException {
      throw ApiException(ReporteConstantes.errorCrearReporte);
    }
  }

  /// Obtiene todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      final response = await _dio.get(
        ApiConstantes.reportesUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Usando el método fromMap del mapper generado
        return data.map((json) => ReporteMapper.fromMap(json)).toList();
      } else {
        throw ApiException(ReporteConstantes.errorObtenerReportes);
      }
    } on DioException {
      throw ApiException(ReporteConstantes.errorObtenerReportes);
    }
  }
}