import 'package:flutter/material.dart';
import 'package:abaez/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';
import 'package:abaez/helpers/category_helper.dart';
import 'package:abaez/bloc/reportes/reportes_bloc.dart';  // Añadir este import
import 'package:abaez/bloc/reportes/reportes_event.dart'; // Añadir este import
import 'package:abaez/bloc/reportes/reportes_state.dart'; // Añadir este import

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
  int numeroComentarios = 0;
  int numeroReportes = 0;
  String? _lastLoadedId;

  @override
  void initState() {
    super.initState();
    _cargarContadores();
  }

  @override
  void didUpdateWidget(NoticiaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recargar solo si cambió el ID de la noticia
    if (oldWidget.id != widget.id) {
      _cargarContadores();
    }
  }

  void _cargarContadores() {
    if (widget.id != null && widget.id != _lastLoadedId) {
      _lastLoadedId = widget.id;
      
      // Usar read en lugar de watch para evitar rebuilds innecesarios
      context.read<ComentarioBloc>().add(
        GetNumeroComentarios(noticiaId: widget.id!),
      );
      context.read<ReporteBloc>().add(
        ReporteGetCountEvent(noticiaId: widget.id!),
      );
    }
  }


      
  Future<String> _obtenerNombreCategoria(String categoriaId) async {
    // Usar el nuevo helper que implementa la caché de categorías
    return await CategoryHelper.getCategoryName(categoriaId);
  }

  @override
   Widget build(BuildContext context) {
    // Usar BlocListener para actualizar contadores sin reconstruir todo el widget
    return  MultiBlocListener(
      listeners: [
        BlocListener<ComentarioBloc, ComentarioState>(
          listenWhen: (previous, current) => 
            current is NumeroComentariosLoaded && current.noticiaId == widget.id,
          listener: (context, state) {
            if (state is NumeroComentariosLoaded && numeroComentarios != state.numeroComentarios) {
              setState(() {
                numeroComentarios = state.numeroComentarios;
              });
            }
          },
        ),
        BlocListener<ReporteBloc, ReporteState>(
          listenWhen: (previous, current) => 
            current is ReporteCountLoaded && current.noticiaId == widget.id,
          listener: (context, state) {
            if (state is ReporteCountLoaded && numeroReportes != state.numeroReportes) {
              setState(() {
                numeroReportes = state.numeroReportes;
              });
            }
          },
        ),
      ],
      child: Padding(
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
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.fuente,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${AppConstants.publicadaEl} ${widget.publicadaEl}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 1),
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
              const SizedBox(width: 2),
              SizedBox(
                width:
                    120, // Mantenemos el ancho para la columna de imagen y botones
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 24),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Fila de botones optimizada para evitar overflow
                    SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Botón de comentarios - optimizado
                          InkWell(
                            onTap: widget.onComment,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 15,
                                  child: Text(
                                    '$numeroComentarios',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.comment,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),

                          // Botón de reporte - optimizado
                          InkWell(
                            onTap: widget.onReport,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 15,
                                  child: Text(
                                    '$numeroReportes',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.flag,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                          
                          // Menú - optimizado
                          SizedBox(
                            width: 24,
                            child: PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                size: 18,
                              ),
                              padding: EdgeInsets.zero,
                              iconSize: 18,
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Editar',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Eliminar',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (String value) {
                                if (value == 'edit') {
                                  widget.onEdit();
                                } else if (value == 'delete') {
                                  widget.onDelete();
                                }
                              },
                           ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );

  }
}
