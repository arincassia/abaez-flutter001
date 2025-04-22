import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/domain/noticia.dart';


class NoticiaService {
  final NoticiaRepository _noticiaRepository;

  NoticiaService(this._noticiaRepository);

 
 Future<List<Noticia>> fetchNoticias({
  required int page,
  required int pageSize,
  required bool ordenarPorFecha,
}) async {
  final noticiasJson = await _noticiaRepository.obtenerNoticias(
    page: page,
    pageSize: pageSize,
    ordenarPorFecha: ordenarPorFecha,
  );

  return noticiasJson.map((json) => Noticia.fromJson(json)).toList();
}
Future<List<Noticia>> listarNoticiasDesdeAPI() async {
  try {
    final noticias = await _noticiaRepository.listarNoticiasDesdeAPI();

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
    throw Exception('Error al listar noticias desde la API: $e');
  }
}

Future<void> crearNoticia(Noticia noticia) async {
  try {
    await _noticiaRepository.crearNoticia(noticia);
  } catch (e) {
    throw Exception('Error al crear la noticia: $e');
  }
}
}