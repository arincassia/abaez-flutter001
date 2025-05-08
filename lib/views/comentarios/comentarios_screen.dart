import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:intl/intl.dart';

class ComentariosScreen extends StatelessWidget {
  final String noticiaId;

  const ComentariosScreen({super.key, required this.noticiaId});

  @override
  Widget build(BuildContext context) {
    // Usar un BlocProvider.value para compartir la misma instancia del bloc
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

  @override
  void dispose() {
    _comentarioController.dispose();
    _busquedaController.dispose();
    super.dispose();
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
            message: _ordenAscendente
                ? 'Ordenar por más recientes'
                : 'Ordenar por más antiguos',
            child: IconButton(
              onPressed: () {
                setState(() {
                  _ordenAscendente = !_ordenAscendente;
                });
                // Disparar evento de ordenamiento
                context.read<ComentarioBloc>().add(
                  OrdenarComentarios(
                    ascendente: _ordenAscendente,
                  ),
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
                        final fecha = DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(DateTime.parse(comentario.fecha));

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
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
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
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
                          ),
                        );
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
              icon: const Icon(Icons.send),
              label: const Text('Publicar comentario'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}