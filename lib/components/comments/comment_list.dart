import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_state.dart';
import 'package:abaez/domain/comentario.dart';
import 'package:abaez/components/comments/comment_card.dart';

class CommentList extends StatelessWidget {
  final String noticiaId;
  final Function(String, String) onResponderComentario;

  const CommentList({
    super.key,
    required this.noticiaId,
    required this.onResponderComentario,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComentarioBloc, ComentarioState>(
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
          return _buildList(context, state.comentariosList); // Pasar context aquí
        } else if (state is ComentarioError) {
          return _buildErrorState(context); // Pasar context aquí
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildList(BuildContext context, List<Comentario> comentarios) { // Recibir context
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
      itemBuilder: (context, index) => CommentCard(
        comentario: comentarios[index],
        noticiaId: noticiaId,
        onResponder: onResponderComentario,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 4),
    );
  }

  Widget _buildErrorState(BuildContext context) { // Recibir context como parámetro
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error al cargar comentarios',
            style: TextStyle(color: Colors.red[700]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.read<ComentarioBloc>()
              ..add(LoadComentarios(noticiaId: noticiaId)),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}