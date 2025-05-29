import 'package:abaez/api/service/noticia_sevice.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/data/base_repository.dart';

// Adaptador para NoticiaService que implementa BaseService
class NoticiaServiceAdapter extends BaseService<Noticia> {
  final NoticiaService _service = NoticiaService();
  
  @override
  Future<List<Noticia>> getAll() => _service.getNoticias();
  
  @override
  Future<void> create(dynamic data) => _service.crearNoticia(data);
  
  @override
  Future<void> update(String id, dynamic data) => _service.editarNoticia(id, data);
  
  @override
  Future<void> delete(String id) => _service.eliminarNoticia(id);
}

class NoticiaRepository extends BaseRepository<Noticia, NoticiaServiceAdapter> {
  NoticiaRepository() : super(NoticiaServiceAdapter(), 'Noticia');
    @override
  void validarEntidad(Noticia noticia) {
    // Implement validation logic for Noticia entities
    if (noticia.titulo == '' || noticia.titulo.isEmpty) {
      throw Exception('El título de la noticia no puede estar vacío');
    }
    if (noticia.descripcion == '' || noticia.descripcion.isEmpty) {
      throw Exception('La descripción de la noticia no puede estar vacía');
    }
    if (noticia.fuente == '' || noticia.fuente.isEmpty) {
      throw Exception('La fuente de la noticia no puede estar vacía');
    }
    if (noticia.urlImagen == '' || noticia.urlImagen.isEmpty) {
      throw Exception('La URL de la imagen de la noticia no puede estar vacía');
    }
    
    // Add any other validations specific to Noticia entities
  }

  // Métodos con nombres específicos y validaciones adicionales
  Future<List<Noticia>> obtenerNoticias() => getAll();
  
  Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required DateTime publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    final noticia = Noticia(
      titulo: titulo,
      descripcion: descripcion,
      fuente: fuente,
      publicadaEl: publicadaEl,
      urlImagen: urlImagen,
      categoriaId: categoriaId,
    );
    await create(noticia);
  }
  
  Future<void> eliminarNoticia(String id) => delete(id);
  
  Future<void> actualizarNoticia({
    required String id,
    required String titulo,
    required String descripcion,
    required String fuente,
    required DateTime publicadaEl,
    required String urlImagen,
    required String categoriaId,
  }) async {
    if (titulo.isEmpty || descripcion.isEmpty || fuente.isEmpty) {
      throw ApiException(
        'Los campos título, descripción y fuente no pueden estar vacíos.',
      );
    }
    final noticia = Noticia(
      titulo: titulo,
      descripcion: descripcion,
      fuente: fuente,
      publicadaEl: publicadaEl,
      urlImagen: urlImagen,
      categoriaId: categoriaId,
    );
    await update(id, noticia);
  }
}