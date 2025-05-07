import 'package:json_annotation/json_annotation.dart';
part 'noticia.g.dart';

@JsonSerializable()
class Noticia {
  @JsonKey(name: '_id', defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String titulo;
  @JsonKey(name: 'descripcion', defaultValue: '')
  final String contenido;
  @JsonKey(defaultValue: '')
  final String fuente;
  @JsonKey(fromJson: _parseDateTime)
  final DateTime publicadaEl;
  @JsonKey(name: 'urlImagen')
  final String? imagenUrl; // Nuevo campo para la URL de la imagen
  @JsonKey(defaultValue: '')
  final String? categoriaId; // ID de la categoría asociada

  Noticia({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.fuente,
    required this.publicadaEl,
    this.imagenUrl, // Campo opcional
    this.categoriaId, // ID de la categoría asociada
  });

/*factory Noticia.fromJson(Map<String, dynamic> json) {
    try {
      return Noticia(
        id: json['_id'] ?? '', // Usar `_id` como identificador
        titulo: json['titulo'] ?? '',
        contenido: json['descripcion'] ?? '', // Mapear `descripcion` a `contenido`
        fuente: json['fuente'] ?? '',
        publicadaEl: json['publicadaEl'] != null
            ? DateTime.parse(json['publicadaEl'])
            : DateTime.now(), 
        imagenUrl: json['urlImagen'], // Mapear `urlImagen` a `imagenUrl`
        categoriaId: json['categoriaId'] ?? '', // ID de la categoría asociada
      );
    } catch (e) {
      throw Exception('Error al mapear Noticia: $e');
    }
  }*/

  factory Noticia.fromJson(Map<String, dynamic> json) => _$NoticiaFromJson(json);

  Map<String, dynamic> toJson() => _$NoticiaToJson(this);

  // Método para manejar la conversión de fechas
  static DateTime _parseDateTime(String? date) {
    try {
      return date != null ? DateTime.parse(date) : DateTime.now();
    } catch (_) {
      return DateTime.now();
    }
  }
}
