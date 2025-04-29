import 'package:abaez/api/service/categoria_service.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/exceptions/api_exception.dart';

class CategoriaRepository {
  final CategoriaService _categoriaService = CategoriaService();
  CategoriaRepository();

  // Obtener todas las categorías desde la API
  Future<List<Categoria>> listarCategoriasDesdeAPI() async {
    try {
      final categorias = await _categoriaService.listarCategoriasDesdeAPI();

      // Validaciones de los campos, que no estén vacíos
      for (final categoria in categorias) {
        if (categoria.nombre.isEmpty) {
          throw ApiException('El nombre de la categoría no puede estar vacío.');
        }
        if (categoria.descripcion.isEmpty) {
          throw ApiException('La descripción de la categoría no puede estar vacía.');
        }
      }

      // Ordenar las categorías alfabéticamente por nombre
      categorias.sort((a, b) => a.nombre.compareTo(b.nombre));

      return categorias;
    } on ApiException catch (e) {
      // Propaga la excepción personalizada con un mensaje adicional si es necesario
      throw ApiException('Error al listar categorías: ${e.message}', statusCode: e.statusCode);
    } catch (e) {
      // Manejo de otros errores no relacionados con la API
      throw Exception('Error inesperado: $e');
    }
  }

  // Crear una nueva categoría
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      await _categoriaService.crearCategoria(categoria);
    } catch (e) {
      throw Exception('Error al crear la categoría: $e');
    }
  }

  // Editar una categoría existente
  Future<void> editarCategoria(Categoria categoria) async {
    try {
      await _categoriaService.editarCategoria(categoria); // Llama al método del servicio
    } catch (e) {
      throw Exception('Error al editar la categoría: $e');
    }
  }

  // Eliminar una categoría por ID
  Future<void> eliminarCategoria(String id) async {
    try {
      await _categoriaService.eliminarCategoria(id); // Llama al método del servicio
    } catch (e) {
      throw Exception('Error al eliminar la categoría: $e');
    }
  }

  // Obtener una categoría por ID
  Future<Categoria> obtenerCategoriaPorId(String categoriaId) async {
    try {
      final categoria = await _categoriaService.obtenerCategoriaPorId(categoriaId);
      if (categoria.id.isEmpty) {
        throw Exception('Categoría no encontrada');
      }
      return categoria;
    } catch (e) {
      throw Exception('Error al obtener la categoría: $e');
    }
  }
}