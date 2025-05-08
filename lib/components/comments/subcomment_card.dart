import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abaez/domain/comentario.dart';

class SubcommentCard extends StatelessWidget {
  final Comentario subcomentario;

  const SubcommentCard({
    super.key,
    required this.subcomentario,
  });

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd/MM/yyyy HH:mm')
        .format(DateTime.parse(subcomentario.fecha));

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
          Text(
            subcomentario.texto,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            fecha,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}