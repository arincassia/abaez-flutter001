import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:intl/intl.dart';
import 'package:abaez/domain/comentario.dart';

class ComentariosScreen extends StatelessWidget {
  final String noticiaId;

  const ComentariosScreen({super.key, required this.noticiaId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value:
          context.read<ComentarioBloc>()
            ..add(LoadComentarios(noticiaId: noticiaId)),
      child: _ComentariosScreenContent(noticiaId: noticiaId),
    );
  }
}

class _ComentariosScreenContent extends StatefulWidget {
  final String noticiaId;

  const _ComentariosScreenContent({required this.noticiaId});

  @override
  State<_ComentariosScreenContent> createState() =>
      _ComentariosScreenContentState();
}

class _ComentariosScreenContentState extends State<_ComentariosScreenContent> {
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _busquedaController = TextEditingController();
  bool _ordenAscendente = true;

  // Para manejar subcomentarios
  String? _respondingToId;
  String? _respondingToAutor;

  @override
  void dispose() {
    _comentarioController.dispose();
    _busquedaController.dispose();
    super.dispose();
  }

  // Método para cancelar la respuesta a un comentario
  void _cancelarRespuesta() {
    setState(() {
      _respondingToId = null;
      _respondingToAutor = null;
      _comentarioController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Botón de ordenamiento
          Tooltip(
            message:
                _ordenAscendente
                    ? 'Ordenar por más recientes'
                    : 'Ordenar por más antiguos',
            child: IconButton(
              onPressed: () {
                setState(() {
                  _ordenAscendente = !_ordenAscendente;
                });
                // Disparar evento de ordenamiento
                context.read<ComentarioBloc>().add(
                  OrdenarComentarios(ascendente: _ordenAscendente),
                );
              },
              icon: Icon(
                _ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra de búsqueda
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
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _busquedaController,
                        builder: (context, value, child) {
                          return value.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: 'Limpiar búsqueda',
                                onPressed: () {
                                  _busquedaController.clear();
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
                    if (_busquedaController.text.isEmpty) {
                      context.read<ComentarioBloc>().add(
                        LoadComentarios(noticiaId: widget.noticiaId),
                      );
                    } else {
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
              ],
            ),
            const SizedBox(height: 16),

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
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: comentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = comentarios[index];
                        return _buildComentarioCard(context, comentario);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                    );
                  } else if (state is ComentarioError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error al cargar comentarios',
                            style: TextStyle(color: Colors.red[700]),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ComentarioBloc>().add(
                                LoadComentarios(noticiaId: widget.noticiaId),
                              );
                            },
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),

            // Formulario para agregar comentarios
            const Divider(),
            if (_respondingToId != null)
              // Mostrar a quién se está respondiendo
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Respondiendo a ${_respondingToAutor}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: _cancelarRespuesta,
                      tooltip: 'Cancelar respuesta',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            TextField(
              controller: _comentarioController,
              decoration: InputDecoration(
                hintText:
                    _respondingToId == null
                        ? 'Escribe tu comentario'
                        : 'Escribe tu respuesta...',
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (_comentarioController.text.trim().isEmpty) {
                  SnackBarHelper.showSnackBar(
                    context,
                    'El comentario no puede estar vacío',
                    statusCode: 400,
                  );
                  return;
                }

                String fechaFormateada = DateTime.now().toIso8601String();

                if (_respondingToId == null) {
                  // Agregar comentario normal
                  context.read<ComentarioBloc>().add(
                    AddComentario(
                      noticiaId: widget.noticiaId,
                      texto: _comentarioController.text,
                      autor: 'Usuario anónimo',
                      fecha: fechaFormateada,
                    ),
                  );
                } else {
                  // Agregar subcomentario
                  context.read<ComentarioBloc>().add(
                    AddSubcomentario(
                      comentarioId: _respondingToId!,
                      noticiaId: widget.noticiaId, // Añadir esto
                      texto: _comentarioController.text,
                      autor: 'Usuario anónimo',
                    ),
                  );

                  // Limpiar el estado de respuesta
                  setState(() {
                    _respondingToId = null;
                    _respondingToAutor = null;
                  });
                }

                // Actualizar contador y limpiar campo
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
              icon: const Icon(Icons.send),
              label: Text(
                _respondingToId == null
                    ? 'Publicar comentario'
                    : 'Enviar respuesta',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir un comentario y sus subcomentarios
  Widget _buildComentarioCard(BuildContext context, Comentario comentario) {
    final fecha = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(DateTime.parse(comentario.fecha));

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comentario principal
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comentario.autor,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(comentario.texto),
                const SizedBox(height: 8),
                Text(
                  fecha,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Botón para dar like
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
                            comentarioId: comentario.id,
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
                    // Botón para dar dislike
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
                    const Spacer(),
                    // Botón para responder
                    TextButton.icon(
                      icon: const Icon(Icons.reply, size: 16),
                      label: const Text('Responder'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        // Configurar el estado para responder a este comentario
                        setState(() {
                          _respondingToId = comentario.id;
                          _respondingToAutor = comentario.autor;
                        });

                        // Opcional: desplazarse al campo de texto
                        // Requiere un ScrollController y un GlobalKey
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Subcomentarios, si existen
          if (comentario.subcomentarios != null &&
              comentario.subcomentarios!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comentario.subcomentarios!.length,
                itemBuilder: (context, index) {
                  final subcomentario = comentario.subcomentarios![index];
                  final fechaSubcomentario = DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(DateTime.parse(subcomentario.fecha));

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              subcomentario.autor,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(subcomentario.texto),
                        const SizedBox(height: 4),
                        Text(
                          fechaSubcomentario,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Botones de like/dislike para subcomentarios
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.thumb_up_sharp,
                                size: 14,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                context.read<ComentarioBloc>().add(
                                  AddReaccion(
                                    noticiaId: widget.noticiaId,
                                    comentarioId: subcomentario.id,
                                    tipoReaccion: 'like',
                                  ),
                                );
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              subcomentario.likes.toString(),
                              style: const TextStyle(fontSize: 11),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(
                                Icons.thumb_down_sharp,
                                size: 14,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context.read<ComentarioBloc>().add(
                                  AddReaccion(
                                    noticiaId: widget.noticiaId,
                                    comentarioId: subcomentario.id,
                                    tipoReaccion: 'dislike',
                                  ),
                                );
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              subcomentario.dislikes.toString(),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
