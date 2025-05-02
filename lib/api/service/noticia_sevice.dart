import 'dart:async';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/error_helper.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:abaez/constants.dart';

class NoticiaService {
  final Dio _dioNew = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds), // Tiempo de conexión
    receiveTimeout: const Duration(seconds:CategoriaConstantes.timeoutSeconds), // Tiempo de recepción
  ));
 
  
  Future<List<Noticia>> getNoticias() async {
  try {
    // Realiza la solicitud GET a la API
    final response = await _dioNew.get(ApiConstantes.noticiasUrl);

    // Maneja el código de estado HTTP
    if (response.statusCode == 200) {
      final List<dynamic> noticiasJson = response.data;
      return noticiasJson.map((json) {
        return Noticia(
          id: json['_id'] ?? '',
          titulo: json['titulo'] ?? 'Sin título',
          descripcion: json['descripcion'] ?? 'Sin descripción',
          fuente: json['fuente'] ?? 'Fuente desconocida',
          publicadaEl: DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
          imageUrl: json['urlImagen'] ?? '',
          categoriaId: json['categoriaId'] ?? CategoriaConstantes.defaultCategoriaId,
         );
        }).toList();
      } else {
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioError catch (e) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }


  /// Edita una noticia en la API de CrudCrud
Future<void> editarNoticia(String id, Map<String, dynamic> noticia) async {
  try {
    final url = '${ApiConstantes.noticiasUrl}/$id';
    final response = await _dioNew.put(
      url,
      data: noticia,
    );

    if (response.statusCode != 200) {
        throw ApiException('Error desconocido', statusCode: response.statusCode);
      }
    } on DioError catch (e) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Crea una nueva noticia en la API de CrudCrud
  Future<void> crearNoticia(Map<String, dynamic> noticia) async {
  try {
    final response = await _dioNew.post(
      ApiConstantes.noticiasUrl,
      data: noticia,
    );

    if (response.statusCode != 201) {
      throw Exception('Error desconocido: ${response.statusCode}');
    }
  } on DioError catch (e) {
   ErrorHelper.getErrorMessageAndColor(e.response?.statusCode); // Llama a la función centralizada para manejar el error
  } catch (e) {
    throw Exception('Error inesperado: $e');
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
    } on DioError catch (e) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.response?.statusCode);
      throw ApiException(errorData['message'], statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }
}

  
