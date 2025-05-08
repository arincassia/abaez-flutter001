import 'package:json_annotation/json_annotation.dart';
part 'comentario.g.dart';

@JsonSerializable(
  explicitToJson: true, // Para manejar correctamente subcomentarios anidados
  includeIfNull: false, // Omitir campos nulos al convertir a JSON
  anyMap: true, // Más tolerancia con tipos de mapas
)
class Comentario {
  @JsonKey(name: '_id', includeToJson: false)
  final String? id; // Aquí lo hacemos opcional
  final String noticiaId;
  final String texto;
  final String fecha;
  final String autor;
  @JsonKey(defaultValue: 0) // Valor por defecto si falta
  final int likes;
  @JsonKey(defaultValue: 0) // Valor por defecto si falta
  final int dislikes;
  @JsonKey(defaultValue: []) // Lista vacía por defecto
  final List<Comentario>? subcomentarios;
  @JsonKey(defaultValue: false) // Valor por defecto
  final bool? isSubComentario; // Indica si es un subcomentario o no

  Comentario({
    this.id, // Ya no es required
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
    this.subcomentarios,
    this.isSubComentario,
  });
  // Método para convertir un JSON de la API a un objeto Category
  factory Comentario.fromJson(Map<String, dynamic> json) =>
      _$ComentarioFromJson(json);

  // Método para convertir el objeto Category a JSON para enviar a la API
  Map<String, dynamic> toJson() => _$ComentarioToJson(this);

  // Agregar esta extensión dentro de la clase Comentario
  String get safeId =>
      id ?? 'comentario-${DateTime.now().millisecondsSinceEpoch}';

  // Método para clonar un comentario con valores modificados
  Comentario copyWith({
    String? id,
    String? noticiaId,
    String? texto,
    String? fecha,
    String? autor,
    int? likes,
    int? dislikes,
    List<Comentario>? subcomentarios,
    bool? isSubComentario,
  }) {
    return Comentario(
      id: id ?? this.id,
      noticiaId: noticiaId ?? this.noticiaId,
      texto: texto ?? this.texto,
      fecha: fecha ?? this.fecha,
      autor: autor ?? this.autor,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      subcomentarios: subcomentarios ?? this.subcomentarios,
      isSubComentario: isSubComentario ?? this.isSubComentario,
    );
  }
}
