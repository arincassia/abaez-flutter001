import 'package:equatable/equatable.dart';

abstract class ComentarioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento para cargar comentarios de una noticia específica
class LoadComentarios extends ComentarioEvent {
  final String noticiaId;

  LoadComentarios({required this.noticiaId});

  @override
  List<Object?> get props => [noticiaId];
}

// Evento para agregar un comentario
class AddComentario extends ComentarioEvent {
  final String noticiaId;
  final String texto;
  final String fecha;
  final String autor;

  AddComentario({
    required this.noticiaId,
    required this.texto,
    required this.autor,
    required this.fecha,
  });

  @override
  List<Object?> get props => [noticiaId, texto];
}

// Evento para obtener el número de comentarios de una noticia
class GetNumeroComentarios extends ComentarioEvent {
  final String noticiaId;

  GetNumeroComentarios({required this.noticiaId});

  @override
  List<Object?> get props => [noticiaId];
}
// Evento para agregar una reacción (like o dislike)
class AddReaccion extends ComentarioEvent {
  final String noticiaId;
  final String comentarioId;
  final String tipoReaccion; // 'like' o 'dislike'

  AddReaccion({
    required this.noticiaId,
    required this.comentarioId,
    required this.tipoReaccion,
  });

  @override
  List<Object?> get props => [noticiaId, comentarioId, tipoReaccion];
}

