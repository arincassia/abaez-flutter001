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

  AddComentario({
    required this.noticiaId,
    required this.texto,
  });

  @override
  List<Object?> get props => [noticiaId, texto];
}
