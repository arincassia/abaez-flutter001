import 'package:flutter/material.dart';

class NoticiaCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String fuente;
  final String publicadaEl;
  final String imageUrl;
  final String categoriaId;
  final VoidCallback onEdit; // Callback para editar
  final VoidCallback onDelete; // Callback para eliminar

  const NoticiaCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
    required this.categoriaId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Borde redondeado
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenido textual (Título, descripción, fuente, etc.)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descripcion,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fuente,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    publicadaEl,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Categoría: $categoriaId',
                    style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Espacio entre el texto y la imagen
            // Imagen y botones
            Column(
              children: [
                // Imagen
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    width: 140,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Botones debajo de la imagen
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: onEdit, // Llama al callback de edición
                      tooltip: 'Editar noticia',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete, // Llama al callback de eliminación
                      tooltip: 'Eliminar noticia',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}