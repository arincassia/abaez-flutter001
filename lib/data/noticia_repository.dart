
import 'package:dio/dio.dart';
import 'package:abaez/constans.dart';
import 'package:abaez/domain/noticia.dart';

class NoticiaRepository {
  final Dio dio = Dio();

Future<List<Map<String, dynamic>>> obtenerNoticias({
  required int page,
  required int pageSize,
  required bool ordenarPorFecha,
}) async {
 try {
  final response = await Dio().get(
  AppConstants.newsurl,
  queryParameters: {
    'page': page,
    'pageSize': pageSize,
    'sortBy': ordenarPorFecha ? 'publishedAt' : 'source.name',
    'language': 'es',
    
  },
);

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(response.data['articles']);
  } else {
    throw Exception('Error al obtener noticias: ${response.statusCode}');
  }
} catch (e) {
  throw Exception('Error al conectar con la API: $e');
}
}

Future<List<Noticia>> listarNoticiasDesdeAPI() async {
  try {
    final response = await Dio().get(AppConstants.newsurl);
    print('Respuesta de la API: ${response.data}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener noticias: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al conectar con la API: $e');
    throw Exception('Error al conectar con la API: $e');
  }
}

Future<void> crearNoticia(Noticia noticia) async {
  try {
    final response = await Dio().post(
      AppConstants.newsurl,
      data: {
        'titulo': noticia.titulo,
        'descripcion': noticia.contenido,
        'fuente': noticia.fuente,
        'publicadaEl': noticia.publicadaEl.toIso8601String(),
        'urlImagen': noticia.imagenUrl,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear la noticia: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al conectar con la API: $e');
  }
}
}