import 'package:abaez/exceptions/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/constants.dart';

class ReporteService {
  final Dio _dio;

  ReporteService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstantes.reportesUrl,
              contentType: 'application/json',
              responseType: ResponseType.json,
            ),
          );

  Future<Noticia> verificarNoticiaExiste(String noticiaId) async {
    try {
      final Response response = await _dio.get(
        '${ApiConstantes.noticiasUrl}/$noticiaId',
      );

      try {
        // Verify the response data can be converted to a Noticia object
        Noticia noticia = Noticia.fromJson(response.data);

        // Additional validation if needed
        if (noticia.id == null || noticia.id!.isEmpty) {
          throw ApiException(
            'La noticia con ID $noticiaId no tiene un ID válido.',
            statusCode: 0,
          );
        }

        return noticia;
      } catch (e) {
        if (e is ApiException) {
          rethrow;
        }
        throw ApiException(
          'Error al procesar datos de la noticia: ${e.toString()}',
          statusCode: 422,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(
          'La noticia con ID $noticiaId no existe.',
          statusCode: 404,
        );
      }
      throw ApiException(
        'Error al verificar noticia: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: ${e.toString()}', statusCode: 500);
    }
  }

  Future<void> enviarReporte(Reporte reporte) async {
    try {
      // Send the report
      print('\nEnviando reporte: ${reporte.toMap()}\n');
      await _dio.post(ApiConstantes.reportesUrl, data: reporte.toMap());


    } on DioException catch (e) {

      if (e.response != null) {

        final String errorMsg =
            e.response?.data?.toString() ?? 'Error desconocido';

        throw ApiException(
          'Error al enviar reporte: $errorMsg',
          statusCode: null,
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        // Timeout errors
        throw ApiException('Error de conexión: Timeout', statusCode: 408);
      } else if (e.type == DioExceptionType.connectionError) {
        // Network errors
        throw ApiException('Error de conexión de red', statusCode: 0);
      } else {
        // Something happened in setting up or sending the request
        throw ApiException('Error de conexión: ${e.message}', statusCode: 0);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: ${e.toString()}', statusCode: 500);
    }
  }

  Future<Map<String, dynamic>> obtenerReporteRaw(String id) async {
    try {
      final Response response = await _dio.get(
        '${ApiConstantes.reportesUrl}/$id',
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException('El reporte con ID $id no existe.', statusCode: 404);
      }
      throw ApiException(
        'Error al obtener reporte: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: ${e.toString()}', statusCode: 500);
    }
  }


  Future<List<Map<String, dynamic>>> obtenerReportesRaw() async {
    try {
      final Response response = await _dio.get('/reportes');

      if (response.data is! List) {
        throw ApiException('Formato de respuesta inválido', statusCode: 500);
      }

      final List<dynamic> reportesJson = response.data;
      return reportesJson.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw ApiException(
        'Error al obtener reportes: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error inesperado: ${e.toString()}', statusCode: 500);
    }
  }
}
