import 'package:abaez/data/noticia_repository.dart';

class NoticiaService {
  final NoticiaRepository _noticiaRepository;

  NoticiaService(this._noticiaRepository);

 
  Future<List<Noticia>> getNoticias() async {

    final noticias = await _noticiaRepository.getNoticias();

     //Validaciones de los campos, que no esten vacios
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

   
    noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl));

    return noticias;
  }


  
  
  Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int numeroPagina,
    int tamanoPagina = 5,
  }) async {
    
    if (numeroPagina < 1) {
      throw Exception('El número de página debe ser mayor o igual a 1.');
    }
    if (tamanoPagina <= 0) {
      throw Exception('El tamaño de página debe ser mayor a 0.');
    }

   
    final noticias = await _noticiaRepository.getPaginatedNoticias(
      pageNumber: numeroPagina,
      pageSize: tamanoPagina,
    );

    //Validaciones de los campos, que no esten vacios
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

    noticias.sort((a, b) => b.publicadaEl.compareTo(a.publicadaEl));

    return noticias;
  }
}