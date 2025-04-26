import 'package:abaez/api/service/noticia_sevice.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/exceptions/api_exception.dart';

class NoticiaRepository {
  final NoticiaService _noticiaService;

  NoticiaRepository(this._noticiaService);

  /// Obtiene una lista de noticias desde la API con paginación y ordenamiento
  Future<List<Noticia>> fetchNoticias({
    required int page,
    required int pageSize,
    required bool ordenarPorFecha,
  }) async {
    try {
      final noticiasJson = await _noticiaService.obtenerNoticias(
        page: page,
        pageSize: pageSize,
        ordenarPorFecha: ordenarPorFecha,
      );

      return noticiasJson.map((json) => Noticia.fromJson(json)).toList();
    } catch (e) {
      if (e.toString().contains('4')) {
        throw Exception('Error 4xx: El endpoint está inactivo o ha alcanzado su límite.');
      }
      throw Exception('Error al obtener noticias: $e');
    }
  }

  /// Lista todas las noticias desde la API y realiza validaciones
  Future<List<Noticia>> listarNoticiasDesdeAPI() async {
    try {
      final noticias = await _noticiaService.listarNoticiasDesdeAPI();

      // Validaciones de los campos, que no estén vacíos
      for (final noticia in noticias) {
        if (noticia.titulo.isEmpty) {
          throw Exception('El título de la noticia no puede estar vacío.');
        }
        if (noticia.contenido.isEmpty) {
          throw Exception('La descripción de la noticia no puede estar vacía.');
        }
        if (noticia.fuente.isEmpty) {
          throw Exception('La fuente de la noticia no puede estar vacía.');
        }
        if (noticia.publicadaEl.isAfter(DateTime.now())) {
          throw Exception('La fecha de publicación no puede estar en el futuro.');
        }
      }

      // Ordenar las noticias por fecha de publicación (más reciente primero)
      noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl));

      return noticias;
    } catch (e) {
      if (e is ApiException) {
        throw Exception('Error al listar noticias desde la API: ${e.message}');
      }
      else{
        throw Exception('Error inesperado: $e');
      }
    }
  }

  /// Crea una nueva noticia
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      await _noticiaService.crearNoticia(noticia);
    } catch (e) {
      if (e is ApiException) {
        throw Exception('Error al crear la noticia: ${e.message}');
      }
      else{
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Edita una noticia existente
  Future<void> editarNoticia(Noticia noticia) async {
    try {
      await _noticiaService.actualizarNoticia(noticia);
    } catch (e) {
      if (e is ApiException) {
      throw Exception('Error al editar la noticia: $e');
      }
      else{
        throw Exception('Error desconocido: $e');
      }
    }
    
  }

  /// Elimina una noticia
  Future<void> eliminarNoticia(Noticia noticia) async {
    try {
      await _noticiaService.eliminarNoticia(noticia);
    } catch (e) {
      if (e is ApiException) {
        throw Exception('Error al eliminar la noticia: ${e.message}');
      }
      else{
        throw Exception('Error desconocido: $e');
      }
     
    }
  }
}