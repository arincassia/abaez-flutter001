import 'package:dart_mappable/dart_mappable.dart';

part 'comentario.mapper.dart';

@MappableClass()
class Comentario with ComentarioMappable {
  final String? id;
  final String noticiaId;
  final String texto;
  final String fecha;
  final String autor;
  final int likes;
  final int dislikes;
  final List<Comentario>? subcomentarios;
  final bool isSubComentario;
  final String? idSubComentario;

  const Comentario({
    this.id,
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
    this.subcomentarios,
    this.isSubComentario = false,
    this.idSubComentario,
  });
}
