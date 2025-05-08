import 'package:json_annotation/json_annotation.dart';
part 'comentario.g.dart';

@JsonSerializable()
class Comentario {
  @JsonKey(name: '_id', includeToJson: false)
  final String id;
  final String noticiaId;
  final String texto;
  final String fecha;
  final String autor;
  final int likes;
  final int dislikes;
  final List<Comentario>? subcomentarios;

  Comentario({
    required this.id,
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
    this.subcomentarios,
  });
  // Método para convertir un JSON de la API a un objeto Category
  factory Comentario.fromJson(Map<String, dynamic> json) =>
      _$ComentarioFromJson(json);

  // Método para convertir el objeto Category a JSON para enviar a la API
  Map<String, dynamic> toJson() => _$ComentarioToJson(this);
}
