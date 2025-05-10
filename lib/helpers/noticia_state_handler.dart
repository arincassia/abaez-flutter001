import 'package:abaez/domain/noticia.dart';
import 'package:flutter/material.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_state.dart';
import 'package:abaez/helpers/noticia_list_helper.dart';

class NoticiaStateHandler {
  static Widget handleState(
    BuildContext context, 
    NoticiasState state, {
    required Function(Noticia) onEdit,
    required Function(Noticia) onDelete,
    required Function(Noticia) onComment,
    required Function(Noticia) onReport,
  }) {
    return switch (state) {
      NoticiasLoading() => const Center(child: CircularProgressIndicator()),
      NoticiasLoaded() => NoticiaListHelper.buildNoticiaList(
          state.noticiasList,
          onEdit: onEdit,
          onDelete: onDelete,
          onComment: onComment,
          onReport: onReport,
        ),
      NoticiasError() => const Center(
          child: Text('Error cargando noticias', style: TextStyle(color: Colors.red))),
      _ => const SizedBox.shrink(),
    };
  }
}