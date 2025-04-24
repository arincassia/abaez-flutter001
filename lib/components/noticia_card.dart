import 'package:flutter/material.dart';
import 'package:abaez/constans.dart';
import 'package:abaez/domain/noticia.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final int index;
  final VoidCallback onEdit;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.index,
    required this.onEdit,
  });

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
                      const SizedBox(width: 8),
                      const Icon(Icons.star_border, size: 20),
                      const SizedBox(width: 9),
                      const Icon(Icons.share, size: 20),
                   
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            onEdit(); // Llama al callback para abrir el modal de edición
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Editar'),
                          ),
                        ],
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
}