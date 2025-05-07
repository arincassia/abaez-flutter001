import 'package:json_annotation/json_annotation.dart';
part 'noticia.g.dart';

@JsonSerializable()
class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String imageUrl;
  final String? categoriaId; // ID de la categoría asociada

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
    this.categoriaId, // Valor por defecto
  });
  factory Noticia.fromJson(Map<String, dynamic> json) => _$NoticiaFromJson(json);
  Map<String, dynamic> toJson() => _$NoticiaToJson(this); 
}
