import 'package:flutter/material.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/components/noticia_card.dart';
import 'package:abaez/constants.dart';

class NoticiaListHelper {
  static Widget buildNoticiaList(
    List<Noticia> noticias, {
    required Function(Noticia) onEdit,
    required Function(Noticia) onDelete,
    required Function(Noticia) onComment,
    required Function(Noticia) onReport,
  }) {
    if (noticias.isEmpty) {
      return const Center(child: Text(NoticiaConstantes.listaVacia));
    }

    return ListView.separated(
      itemCount: noticias.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.grey, height: 1),
      itemBuilder: (context, index) => NoticiaCard(
        noticia: noticias[index],
        onEdit: () => onEdit(noticias[index]),
        onDelete: () => onDelete(noticias[index]),
        onComment: () => onComment(noticias[index]),
        onReport: () => onReport(noticias[index]),
      ),
    );
  }
}