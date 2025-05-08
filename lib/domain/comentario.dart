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

  Comentario({
    required this.id,
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
  });
  /*
  // Método para convertir un JSON de la API a un objeto Comentario
  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['_id'] as String, // El ID lo asigna CrudCrud
      noticiaId: json['noticiaId'] as String,
      texto: json['texto'] as String,
      fecha: json['fecha'] as String,
      autor: json['autor'] as String,
    );
  }

  // Método para convertir el objeto Comentario a JSON para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      'noticiaId': noticiaId,
      'texto': texto,
      'fecha': fecha,
      'autor': autor,
    };
  }*/

  // Método para convertir un JSON de la API a un objeto Category
  factory Comentario.fromJson(Map<String, dynamic> json) =>
      _$ComentarioFromJson(json);

  // Método para convertir el objeto Category a JSON para enviar a la API
  Map<String, dynamic> toJson() => _$ComentarioToJson(this);
}
