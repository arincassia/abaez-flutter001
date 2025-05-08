import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:intl/intl.dart';

class ComentariosDialog extends StatelessWidget {
  final String noticiaId;

  const ComentariosDialog({super.key, required this.noticiaId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value:
          context.read<ComentarioBloc>()
            ..add(LoadComentarios(noticiaId: noticiaId)),
      child: _ComentariosDialogContent(noticiaId: noticiaId),
    );
  }
}

class _ComentariosDialogContent extends StatefulWidget {
  final String noticiaId;

  const _ComentariosDialogContent({required this.noticiaId});

  @override
  State<_ComentariosDialogContent> createState() =>
      _ComentariosDialogContentState();
}

class _ComentariosDialogContentState extends State<_ComentariosDialogContent> {
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _busquedaController = TextEditingController();
  bool _ordenAscendente = true;

  @override
  void dispose() {
    _comentarioController.dispose();
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //aqui se pueden definir variables
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Comentarios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Cerrar',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _busquedaController,
                    decoration: InputDecoration(
                      hintText: 'Buscar en comentarios...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      // Usar ValueListenableBuilder para reaccionar a cambios en el texto
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _busquedaController,
                        builder: (context, value, child) {
                          return value.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: 'Limpiar búsqueda',
                                onPressed: () {
                                  // Limpiar el campo de búsqueda
                                  _busquedaController.clear();
                                  // Recargar todos los comentarios
                                  context.read<ComentarioBloc>().add(
                                    LoadComentarios(
                                      noticiaId: widget.noticiaId,
                                    ),
                                  );
                                },
                              )
                              : const SizedBox.shrink();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Emitir evento para filtrar comentarios
                    if (_busquedaController.text.isEmpty) {
                      // Si está vacío, cargar todos los comentarios
                      context.read<ComentarioBloc>().add(
                        LoadComentarios(noticiaId: widget.noticiaId),
                      );
                    } else {
                      // Si tiene texto, filtrar comentarios
                      context.read<ComentarioBloc>().add(
                        BuscarComentarios(
                          noticiaId: widget.noticiaId,
                          criterioBusqueda: _busquedaController.text,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Buscar'),
                ),
                const SizedBox(width: 8),
                // Botón de ordenamiento
                Tooltip(
                  message:
                      _ordenAscendente
                          ? 'Ordenar por más recientes'
                          : 'Ordenar por más antiguos',
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _ordenAscendente = !_ordenAscendente;
                      });
                      // Disparar evento de ordenamiento
                      context.read<ComentarioBloc>().add(
                        OrdenarComentarios(
                          ascendente: _ordenAscendente ? true : false,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.arrow_downward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),

            // Lista de comentarios
            Expanded(
              child: BlocConsumer<ComentarioBloc, ComentarioState>(
                listener: (context, state) {
                  if (state is ComentarioError) {
                    SnackBarHelper.showSnackBar(
                      context,
                      'Error: ${state.errorMessage}',
                      statusCode: 500,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ComentarioLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ComentarioLoaded) {
                    final comentarios = state.comentariosList;

                    if (comentarios.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay comentarios que coincidan con tu búsqueda',
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: comentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = comentarios[index];
                        final fecha = DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(DateTime.parse(comentario.fecha));

                        return ListTile(
                          title: Text(comentario.autor),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comentario.texto),
                              const SizedBox(height: 4),
                              Text(
                                fecha,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.thumb_up_sharp,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      context.read<ComentarioBloc>().add(
                                        AddReaccion(
                                          noticiaId: widget.noticiaId,
                                          comentarioId:
                                              comentario.id ??
                                              'default-id', // Proporciona un valor predeterminado
                                          tipoReaccion: 'like',
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    comentario.likes.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.thumb_down_sharp,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      context.read<ComentarioBloc>().add(
                                        AddReaccion(
                                          noticiaId: widget.noticiaId,
                                          comentarioId: comentario.id,
                                          tipoReaccion: 'dislike',
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    comentario.dislikes.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          dense: true,
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(),
                    );
                  } else if (state is ComentarioError) {
                    return const Center(
                      child: Text(
                        'Error al cargar comentarios',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),

            // Formulario para agregar comentarios
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Agregar comentario:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _comentarioController,
              decoration: const InputDecoration(
                hintText: 'Escribe tu comentario',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_comentarioController.text.trim().isEmpty) {
                  SnackBarHelper.showSnackBar(
                    context,
                    'El comentario no puede estar vacío',
                    statusCode: 400,
                  );
                  return;
                }
                DateTime fecha = DateTime.now();
                String fechaformateada = fecha.toIso8601String();

                // Usar la instancia global del bloc
                context.read<ComentarioBloc>().add(
                  AddComentario(
                    noticiaId: widget.noticiaId,
                    texto: _comentarioController.text,
                    autor: 'Usuario anónimo',
                    fecha: fechaformateada,
                  ),
                );

                context.read<ComentarioBloc>().add(
                  GetNumeroComentarios(noticiaId: widget.noticiaId),
                );

                _comentarioController.clear();

                SnackBarHelper.showSnackBar(
                  context,
                  'Comentario agregado con éxito',
                  statusCode: 200,
                );
              },
              child: const Text('Publicar comentario'),
            ),
          ],
        ),
      ),
    );
  }
}
