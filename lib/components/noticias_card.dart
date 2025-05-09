//import 'package:abaez/components/reporte_dialog.dart'; // Añadir esta importación
import 'package:abaez/components/reporte_dialog.dart';
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
  final String categoriaNombre;
  final VoidCallback? onReport;

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
    this.onReport,
  });

  @override
  State<NoticiaCard> createState() => _NoticiaCardState();
}

class _NoticiaCardState extends State<NoticiaCard> {
  int _numeroComentarios = 0;
  bool _isLoading = true;
  bool _isReported = false; // Nuevo: para seguimiento de estado de reporte
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
        if(widget.id != null) {
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
  
  Widget _buildCardActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Botón existente de editar
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          tooltip: 'Editar',
          onPressed: widget.onEdit,
        ),
        // Botón existente de eliminar
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Eliminar',
          onPressed: widget.onDelete,
        ),
        // Columna que contiene el ícono de comentario y el contador
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.comment),
              tooltip: 'Ver comentarios',
              onPressed: widget.onComment,
            ),
            Text(
              '$_numeroComentarios comentarios',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        // Nuevo botón de reportar
        IconButton(
          icon: Icon(
            _isReported ? Icons.warning : Icons.warning_outlined,
            color: _isReported ? Colors.red : null,
          ),
          tooltip: 'Reportar noticia',
          onPressed: () async {
            if (widget.onReport != null) {
              widget.onReport!();
              setState(() {
                _isReported = true;
              });
            }
          },
        ),
      ],
    );
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
                      widget.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.fuente,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<String>(
                      future: _obtenerNombreCategoria(widget.categoriaId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                    child: widget.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 8),
                  // Reemplazar esta fila con nuestro método _buildCardActions()
                  _buildCardActions(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}