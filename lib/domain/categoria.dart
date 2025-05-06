import 'package:json_annotation/json_annotation.dart';
part 'categoria.g.dart';


// category.dart
@JsonSerializable()
class Categoria {
  @JsonKey(name: '_id', includeToJson: false)
  final String id;
  final String nombre; 
  final String descripcion; 
  final String? imagenUrl; 

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.imagenUrl,
  });

  // Método para convertir un JSON de la API a un objeto Category
  factory Categoria.fromJson(Map<String, dynamic> json) => _$CategoriaFromJson(json);

  // Método para convertir el objeto Category a JSON para enviar a la API
  Map<String, dynamic> toJson() => _$CategoriaToJson(this);
}
