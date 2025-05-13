import 'package:json_annotation/json_annotation.dart';

part 'comentario.g.dart';

@JsonSerializable()
class Comentario {
  @JsonKey(includeToJson: false)
  final String? id; // Cambiado a nullable
  final String noticiaId;//
  final String texto;//
  final String fecha;//
  final String autor;//
  final int likes;//
  final int dislikes;//
  final List<Comentario>? subcomentarios;
  @JsonKey(defaultValue: false)
  final bool isSubComentario; // Ahora es required con valor por defecto
  final String? idSubComentario; // idNoticia es opcional

  Comentario({
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

  factory Comentario.fromJson(Map<String, dynamic> json) =>
      _$ComentarioFromJson(json);

  Map<String, dynamic> toJson() => _$ComentarioToJson(this);
}
