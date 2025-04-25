import 'package:flutter/material.dart';
import 'package:abaez/constantes/constants.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/api/service/categoria_service.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String categoriaNombre;

  final CategoriaService categoriaService;

  NoticiaCard({
    super.key,
    required this.noticia,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.categoriaNombre,
  }) : categoriaService = CategoriaService();

  Future<String> _obtenerNombreCategoria(String categoriaId) async {
    try {
      final categoria = await categoriaService.obtenerCategoriaPorId(categoriaId);
      return categoria.nombre;
    } catch (e) {
      return 'Sin categoría';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.espaciadoAlto,
        horizontal: 16,
      ),
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noticia.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      noticia.fuente,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      noticia.contenido,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppConstants.publicadaEl} ${_formatDate(noticia.publicadaEl)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<String>(
                    future: _obtenerNombreCategoria(noticia.categoriaId ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text(
                            'Cargando categoría...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text(
                            'Error al cargar categoría',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          );
                        }
                        final categoriaNombre = snapshot.data ?? 'Sin categoría';
                        return Text(
                          'Categoría: $categoriaNombre',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: noticia.imagenUrl != null
                        ? Image.network(
                            noticia.imagenUrl!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Editar',
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Eliminar',
                        onPressed: () => _confirmDelete(context),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Noticia'),
          content: const Text('¿Estás seguro de que deseas eliminar esta noticia?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                onDelete(); // Llama al callback para manejar la eliminación
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}