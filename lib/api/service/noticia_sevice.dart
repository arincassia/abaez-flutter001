import 'dart:async';
import 'package:abaez/core/api_config.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/error_helper.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';

class NoticiaService {
  final Dio _dioNew = Dio(BaseOptions(
    baseUrl: ApiConfig.beeceptorBaseUrl, // URL base para los endpoints
    connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds), // Tiempo de conexión
    receiveTimeout: const Duration(seconds:CategoriaConstantes.timeoutSeconds), // Tiempo de recepción
    headers: {
            'Authorization': 'Bearer ${ApiConfig.beeceptorApiKey}', // Añadir API Key
            'Content-Type': 'application/json',
          },
  ));
 
  
  Future<List<Noticia>> getNoticias() async {
    try {
      // Realiza la solicitud GET a la API
      final response = await _dioNew.get(ApiConstantes.noticiasUrl);

      // Maneja el código de estado HTTP
      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;
        return noticiasJson.map((json) => Noticia.fromJson(json)).toList();
      } else {
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Edita una noticia en la API de CrudCrud
  Future<void> editarNoticia(String id, Noticia noticia) async {
    try {
      final url = '${ApiConstantes.noticiasUrl}/$id';
      
      // Convertir el objeto Noticia a JSON utilizando el método generado
      Map<String, dynamic> noticiaJson = noticia.toJson();
    
      final response = await _dioNew.put(
        url,
        data: noticiaJson,
      );

      if (response.statusCode != 200) {
          throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Crea una nueva noticia en la API de CrudCrud
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      // Convertir el objeto Noticia a JSON utilizando el método generado
      Map<String, dynamic> noticiaJson = noticia.toJson();
      
      final response = await _dioNew.post(
        ApiConstantes.noticiasUrl,
        data: noticiaJson,
      );

      if (response.statusCode != 201) {
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Elimina una noticia de la API de CrudCrud
  Future<void> eliminarNoticia(String id) async {
    try {
      final url = '${ApiConstantes.noticiasUrl}/$id';
      final response = await _dioNew.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
          throw ApiException('Error desconocido', statusCode: response.statusCode);
        }
      } on DioException catch (e) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
        throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
      } catch (e) {
        throw ApiException('Error inesperado: $e');
    }
  }
}



