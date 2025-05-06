import 'package:flutter/material.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/components/noticias_card.dart';

class NoticiaCardHelper {
  /// Construye un widget NoticiaCard directamente desde una instancia de Noticia
  static Widget buildNoticiaCard({
    required Noticia noticia,
    required VoidCallback onEdit, // Callback para editar
    required VoidCallback onDelete, // Callback para eliminar
  }) {
    /// Calcula el tiempo transcurrido desde la fecha de publicación
    String calcularTiempoTranscurrido(DateTime publicadaEl) {
      final ahora = DateTime.now();
      final diferencia = ahora.difference(publicadaEl);

      if (diferencia.inMinutes < 60) {
        return '${diferencia.inMinutes} min';
      } else if (diferencia.inHours < 24) {
        return '${diferencia.inHours} h';
      } else {
        return '${diferencia.inDays} d';
      }
    }

    final tiempoTranscurrido = calcularTiempoTranscurrido(noticia.publicadaEl);

    return NoticiaCard(
      titulo: noticia.titulo,
      descripcion: noticia.descripcion,
      fuente: noticia.fuente,
      publicadaEl: tiempoTranscurrido,
      imageUrl: noticia.imageUrl,
      categoriaId: noticia.categoriaId ?? '',
      categoriaNombre: '',
      onEdit: onEdit, // Callback para editar
      onDelete: onDelete, // Callback para eliminar
    );
  }
}