import 'package:flutter/material.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/api/service/categoria_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';

class NoticiaCard extends StatefulWidget {
  final String? id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final String publicadaEl;
  final String imageUrl;
  final String categoriaId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onComment;
  final VoidCallback onReport;
  final String categoriaNombre;
  const NoticiaCard({
    super.key,
    this.id,
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
    required this.onReport,
  });

  @override
  State<NoticiaCard> createState() => _NoticiaCardState();
}

class _NoticiaCardState extends State<NoticiaCard> {
  int _numeroComentarios = 0;
  bool _isLoading = true;
  final CategoriaService _categoriaService = CategoriaService();

  @override
  void initState() {
    super.initState();
    // No cargamos aquí para evitar errores de contexto
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      // Cargar el número de comentarios solo la primera vez
      if (_isLoading) {
        if (widget.id != null) {
          // Solo cargar si el ID no es nulo
          context.read<ComentarioBloc>().add(
            GetNumeroComentarios(noticiaId: widget.id!),
          );
        }
        _isLoading = false;
      }

      // Observar cambios en el estado y actualizar si es necesario
      final state = context.watch<ComentarioBloc>().state;
      if (state is NumeroComentariosLoaded && state.noticiaId == widget.id) {
        // Solo actualizar si cambió el número para evitar rebuilds innecesarios
        if (_numeroComentarios != state.numeroComentarios) {
          setState(() {
            _numeroComentarios = state.numeroComentarios;
          });
        }
      }
    } catch (e) {
      debugPrint('Error al cargar comentarios: $e');
    }
  }

  Future<String> _obtenerNombreCategoria(String categoriaId) async {
    try {
      final categoria = await _categoriaService.obtenerCategoriaPorId(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Columna de texto - Esta se expande para ocupar el espacio disponible
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Reducido para dar más espacio
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.fuente,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        fontSize: 12, // Reducido para dar más espacio
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppConstants.publicadaEl} ${widget.publicadaEl}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<String>(
                      future: _obtenerNombreCategoria(widget.categoriaId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Cargando...',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          );
                        }
                        final categoriaNombre =
                            snapshot.data ?? 'Sin categoría';
                        return Text(
                          'Cat: $categoriaNombre',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Espacio adecuado entre contenido y botones
              const SizedBox(width: 4),
              // Columna de imagen y botones con ancho suficiente para iconos de tamaño normal
              SizedBox(
                width:
                    100, // Espacio suficiente para los iconos de tamaño normal
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Importante para minimizar altura
                  children: [
                    // Imagen con tamaño estándar
                    if (widget.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          width: 60, // Tamaño estándar para la imagen
                          height: 60, // Tamaño estándar para la imagen
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60, // Tamaño estándar
                              height: 60, // Tamaño estándar
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 24),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 8), // Espaciado vertical normal
                    // Fila horizontal de botones con espacio normal
                    Wrap(
                      spacing: -80,
                      runSpacing: 1,
                      alignment: WrapAlignment.start,
                      
                      children: [
                        
                       
                        _buildIconButton(
                          icon: Icons.delete,
                          color: Colors.red,
                          onPressed: widget.onDelete,
                          tooltip: 'Eliminar',
                        ),
                         _buildIconButton(
                          icon: Icons.edit,
                          color: Colors.blue,
                          onPressed: widget.onEdit,
                          tooltip: 'Editar',
                        ),
                        // Ícono de comentario + número en una fila
                        
                        _buildIconButton(
                          icon: Icons.report,
                          color: Colors.amber,
                          onPressed: widget.onReport,
                          tooltip: 'Reportar',
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_numeroComentarios',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            _buildIconButton(
                              icon: Icons.comment,
                              onPressed: widget.onComment,
                              tooltip: 'Ver',
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Contador de comentarios
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // Widget helper para crear botones de iconos de tamaño normal

  Widget _buildIconButton({
    required IconData icon,
    Color? color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return IconButton(
      icon: Icon(icon, size: 21, color: color),
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 22, // Tamaño estándar para botones
        minHeight: 22,
        maxWidth: 22, // Tamaño estándar para botones
        maxHeight: 22,
      ),
    );
  }
}
