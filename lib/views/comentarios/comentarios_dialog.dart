import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentario/comentario_bloc.dart';
import 'package:abaez/bloc/comentario/comentario_event.dart';
import 'package:abaez/bloc/comentario/comentario_state.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';

class ComentariosDialog extends StatelessWidget {
  final String noticiaId;

  const ComentariosDialog({super.key, required this.noticiaId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ComentarioBloc>()..add(LoadComentarios(noticiaId)),
      child: _ComentariosDialogContent(noticiaId: noticiaId),
    );
  }
}

class _ComentariosDialogContent extends StatefulWidget {
  final String noticiaId;

  const _ComentariosDialogContent({Key? key, required this.noticiaId})
    : super(key: key);

  @override
  State<_ComentariosDialogContent> createState() => _ComentariosDialogContentState();
}

class _ComentariosDialogContentState extends State<_ComentariosDialogContent> {
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),

            // Lista de comentarios
            Expanded(
              child: BlocConsumer<ComentarioBloc, ComentarioState>(
                listener: (context, state) {
                  if (state is ComentarioError) {
                    SnackBarHelper.showSnackBar(
                      context, 
                      'Error: ${state.message}',
                      statusCode: 500
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ComentarioLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ComentarioLoaded) {
                    final comentarios = state.comentarios;

                    if (comentarios.isEmpty) {
                      return const Center(
                        child: Text('No hay comentarios para esta noticia'),
                      );
                    }

                    return ListView.separated(
                      itemCount: comentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = comentarios[index];
                        // Formatea la fecha para mostrarla de manera amigable
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
                            ],
                          ),
                          dense: true,
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(),
                    );
                  } else if (state is ComentarioError) {
                    return Center(
                      child: Text(
                        'Error al cargar comentarios',
                        style: const TextStyle(color: Colors.red),
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

                // Agregamos el comentario
                context.read<ComentarioBloc>().add(
                  AddComentario(
                    noticiaId: widget.noticiaId,
                    texto: _comentarioController.text,
                    autor:
                        'Usuario Anónimo', // En una app real, vendría del usuario logueado
                    fecha: DateTime.now().toIso8601String(),
                  ),
                );

                // Limpiamos el campo
                _comentarioController.clear();

                // Mostramos confirmación
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
