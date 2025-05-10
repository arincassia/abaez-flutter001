import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:abaez/domain/comentario.dart';
import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';

class SubcommentCard extends StatelessWidget {
  final Comentario subcomentario;
  final String noticiaId;

  const SubcommentCard({
    super.key,
    required this.subcomentario,
    required this.noticiaId,
  });

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat(
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
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subcomentario.texto, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            fecha,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          // Botones de reacción (like/dislike)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.thumb_up_sharp,
                  size: 16,
                  color: Colors.green,
                ),
                onPressed: () => _handleReaction(context, 'like'),
              ),
              Text(
                subcomentario.likes.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.thumb_down_sharp,
                  size: 16,
                  color: Colors.red,
                ),
                onPressed: () => _handleReaction(context, 'dislike'),
              ),
              Text(
                subcomentario.dislikes.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleReaction(BuildContext context, String tipoReaccion) {
    context.read<ComentarioBloc>().add(
      AddReaccion(
        noticiaId: noticiaId,
        comentarioId: subcomentario.idSubComentario ?? '',
        tipoReaccion: tipoReaccion,
      ),
    );
  }
}
