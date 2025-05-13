import 'package:dart_mappable/dart_mappable.dart';

part 'comentario.mapper.dart';

<<<<<<< HEAD
@MappableClass()
class Comentario with ComentarioMappable {
  @MappableField(key: '_id')
=======
@JsonSerializable()
class Comentario {
  @JsonKey(includeToJson: false)
>>>>>>> 7984797d4ded942d2f345d900c7ce49d4b0760a8
  final String? id; // Cambiado a nullable
  final String noticiaId;//
  final String texto;//
  final String fecha;//
  final String autor;//
  final int likes;//
  final int dislikes;//
  final List<Comentario>? subcomentarios;
  final bool isSubComentario;
  final String? idSubComentario; // idNoticia es opcional

  const Comentario({
    this.id, // id ahora es opcional
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
    this.subcomentarios,
    this.isSubComentario = false, // Valor por defecto
    this.idSubComentario, // idSubComentario es opcional
  });

  // // Método de fábrica para crear a partir de un Map (JSON)
  // factory Comentario.fromMap(Map<String, dynamic> map) =>
  //     ComentarioMapper.fromMap(map);

  // // Método para convertir a Map (JSON)
  // Map<String, dynamic> toMap() => ComentarioMapper.toMap(this);
}
