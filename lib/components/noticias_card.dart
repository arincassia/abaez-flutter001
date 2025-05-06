import 'package:flutter/material.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/api/service/categoria_service.dart';

class NoticiaCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String fuente;
  final String publicadaEl;
  final String imageUrl;
  final String categoriaId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onComment;
  final String categoriaNombre;
  

  final CategoriaService categoriaService;

  NoticiaCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
    required this.categoriaId,
    required this.onEdit,
    required this.onDelete,
    required this.categoriaNombre,
    required this.onComment,
  }) : categoriaService = CategoriaService();

  Future<String> _obtenerNombreCategoria(String categoriaId) async {
    try {
      final categoria = await categoriaService.obtenerCategoriaPorId(
        categoriaId,
      );
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
                      titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fuente,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppConstants.publicadaEl} ${formatDate(publicadaEl)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<String>(
                      future: _obtenerNombreCategoria(categoriaId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Cargando categoría...',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text(
                            'Error al cargar categoría',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          );
                        }
                        final categoriaNombre =
                            snapshot.data ?? 'Sin categoría';
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
                    child:
                        imageUrl.isNotEmpty
                            ? Image.network(
                              imageUrl,
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
                        onPressed: onDelete,
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        tooltip: 'Ver comentarios',
                        onPressed: onComment,
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

  String formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty) {
        return 'Fecha desconocida';
      }

      final RegExp ddmmyyyyRegex = RegExp(r'^(\d{1,2})\/(\d{1,2})\/(\d{4})$');
      if (ddmmyyyyRegex.hasMatch(dateStr)) {
        final parts = dateStr.split('/');
        final day = int.parse(parts[0]).toString().padLeft(2, '0');
        final month = int.parse(parts[1]).toString().padLeft(2, '0');
        final year = parts[2];
        return '$day/$month/$year';
      }

      if (dateStr.contains('min') ||
          dateStr.endsWith('h') ||
          dateStr.endsWith('d')) {
        final now = DateTime.now();
        DateTime actualDate;

        if (dateStr.contains('-') && dateStr.contains('min')) {
          return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
        }

        final RegExp numericRegex = RegExp(r'(\d+)');
        final match = numericRegex.firstMatch(dateStr);

        if (match != null) {
          final value = int.tryParse(match.group(1) ?? '0') ?? 0;

          if (dateStr.endsWith('min')) {
            actualDate = now.subtract(Duration(minutes: value));
          } else if (dateStr.endsWith('h')) {
            actualDate = now.subtract(Duration(hours: value));
          } else if (dateStr.endsWith('d')) {
            actualDate = now.subtract(Duration(days: value));
          } else {
            actualDate = now;
          }

          return '${actualDate.day.toString().padLeft(2, '0')}/${actualDate.month.toString().padLeft(2, '0')}/${actualDate.year}';
        }
      }

      try {
        final date = DateTime.parse(dateStr);
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (_) {
        final dashParts = dateStr.split('-');
        if (dashParts.length == 3) {
          try {
            final year = int.parse(dashParts[0]);
            final month = int.parse(dashParts[1]);
            final day = int.parse(dashParts[2]);

            if (year >= 1900 &&
                year <= 2100 &&
                month >= 1 &&
                month <= 12 &&
                day >= 1 &&
                day <= 31) {
              return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
            }
          } catch (_) {}
        }
      }

      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }
}
