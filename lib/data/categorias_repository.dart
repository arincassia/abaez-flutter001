// services/categoria_service.dart
import 'package:abaez/api/service/categoria_service.dart'; // Importa tu repositorio
import 'package:abaez/domain/categoria.dart'; // Importa tu entidad Categoria
import 'package:abaez/data/base_repository.dart';


// Adaptador para CategoriaService que implementa BaseService
class CategoriaServiceAdapter extends BaseService<Categoria> {
  final CategoriaService _service = CategoriaService();
  
  @override
  Future<List<Categoria>> getAll() => _service.getCategorias();
  
  @override
  Future<void> create(dynamic data) => _service.crearCategoria(data);
  
  @override
  Future<void> update(String id, dynamic data) => _service.editarCategoria(id, data);
  
  @override
  Future<void> delete(String id) => _service.eliminarCategoria(id);
}

class CategoriaRepository extends BaseRepository<Categoria, CategoriaServiceAdapter> {
  CategoriaRepository() : super(CategoriaServiceAdapter(), 'Categoría');

    @override
  void validarEntidad(Categoria categoria) {
    // Implement validation logic for Categoria entities
    if (categoria.nombre == '' || categoria.nombre.isEmpty) {
      throw Exception('El nombre de la categoría no puede estar vacío');
    }
    if (categoria.descripcion == '' || categoria.descripcion.isEmpty) {
      throw Exception('La descripción de la categoría no puede estar vacía');
    }
    // Add any other validations specific to Categoria entities
  }

  // Métodos específicos para categorías que no están en la clase base irían aquí

  // Métodos con nombres más amigables que llaman a los métodos de la clase base
  Future<List<Categoria>> obtenerCategorias() => getAll();
  Future<void> crearCategoria(Map<String, dynamic> data) => create(data);
  Future<void> actualizarCategoria(String id, Map<String, dynamic> data) => update(id, data);
  Future<void> eliminarCategoria(String id) => delete(id);
}