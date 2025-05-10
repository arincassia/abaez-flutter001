import 'package:abaez/bloc/reporte/reporte_bloc.dart';
import 'package:abaez/bloc/reporte/reporte_event.dart';
import 'package:abaez/bloc/reporte/reporte_state.dart';
import 'package:abaez/data/reporte_repository.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
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
  });

  @override
  State<NoticiaCard> createState() => _NoticiaCardState();
}

class _NoticiaCardState extends State<NoticiaCard> {
  int _numeroComentarios = 0;
  bool _isLoading = true;
  final CategoriaService _categoriaService = CategoriaService();
  final ReporteRepository _reporteRepository = ReporteRepository();
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
    return BlocListener<ReporteBloc, ReporteState>(
      listener: (context, state) {
        if (state is ReporteSuccess) {}
      },
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<String>(
                        future: _obtenerNombreCategoria(widget.categoriaId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                          widget.imageUrl.isNotEmpty
                              ? Image.network(
                                widget.imageUrl,
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
                        Text(
                          '$_numeroComentarios',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment),
                          tooltip: 'Ver comentarios',
                          onPressed: widget.onComment,
                        ),
                        FutureBuilder<int>(
                          future: _reporteRepository.getReportesPorNoticia(
                            widget.id!,
                          ), // Future a esperar
                          builder: (context, snapshot) {
                            // Estados posibles del Future
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // Muestra spinner mientras carga
                            }

                            if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                              ); // Manejo de errores
                            }

                            return Text(
                              '${snapshot.data}',
                            ); // Muestra el valor cuando está cargado
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.flag, color: Colors.red),
                          tooltip: 'Reportar Noticia',
                          onPressed: () => _mostrarReporteModal(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Editar',
                          onPressed: widget.onEdit,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar',
                          onPressed: widget.onDelete,
                        ),

                        // Columna que contiene el ícono de comentario y el contador
                        /*Column(
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
                      ),*/
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarReporteModal(BuildContext context) {
    MotivoReporte? selectedMotivo;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Reportar Noticia',
                style:TextStyle(
                  fontWeight: FontWeight.bold
                )
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Seleccione el motivo del reporte:'),
                    const SizedBox(height: 10),
                    DropdownButton<MotivoReporte>(
                      value: selectedMotivo,
                      hint: const Text('Selecciona una opción'), // Texto cuando no hay selección
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(20.0), // Borde redondeado del menú desplegable

                      dropdownColor: const Color.fromARGB(255, 236, 199, 212), // Color del menú desplegado

                      onChanged: (MotivoReporte? newValue) {
                        setState(() {
                          selectedMotivo = newValue;
                        });
                      },
                      items:
                          MotivoReporte.values.map((MotivoReporte motivo) {
                            return DropdownMenuItem<MotivoReporte>(
                              value: motivo,
                            
                              child: Text(_mapMotivoToString(motivo)),
                            );
                          }).toList(),
                      
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    style:ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        WidgetStateColor.resolveWith((states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color.fromARGB(255, 82, 53, 67);
                          }
                          return const Color.fromARGB(255, 117, 80, 98);
                        }),
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        WidgetStateColor.resolveWith((states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.white;
                          }
                          return Colors.white;
                        }),
                      ),
                    ),
                    onPressed: () {
                      if (selectedMotivo != null && widget.id != null) {
                        Navigator.pop(context);

                        context.read<ReporteBloc>().add(
                          EnviarReporteEvent(
                            noticiaId: widget.id!,
                            motivo:
                                selectedMotivo!, // Enviamos el enum directamente
                          ),
                        );

                        SnackBarHelper.showSnackBar(
                          context,
                          'Reporte enviado exitosamente',
                          statusCode: 200,
                        );
                      }
                    },
                    child: const Text('Enviar Reporte'),
                  ),
                ],
              );
            },
          ),
    );
  }

  // Función para traducir los valores del enum
  String _mapMotivoToString(MotivoReporte motivo) {
    switch (motivo) {
      case MotivoReporte.noticiaInapropiada:
        return 'Contenido inapropiado';
      case MotivoReporte.informacionFalsa:
        return 'Información falsa';
      case MotivoReporte.otro:
        return 'Otro motivo';
    }
  }
}
