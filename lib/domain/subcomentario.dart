import 'package:json_annotation/json_annotation.dart';
part 'subcomentario.g.dart';

@JsonSerializable()
class SubComentario {
  @JsonKey(name: '_id', includeToJson: false)
  final String id;
  final String noticiaId;
  final String texto;
  final String fecha;
  final String autor;
  final int likes;
  final int dislikes;
  
  
  SubComentario({
    required this.id,
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
  });
  // Método para convertir un JSON de la API a un objeto Category
  factory SubComentario.fromJson(Map<String, dynamic> json) =>
      _$SubComentarioFromJson(json);

  // Método para convertir el objeto Category a JSON para enviar a la API
  Map<String, dynamic> toJson() => _$SubComentarioToJson(this);
}
