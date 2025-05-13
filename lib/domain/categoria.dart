import 'package:json_annotation/json_annotation.dart'; 
part 'categoria.g.dart'; 

@JsonSerializable()
// category.dart
class Categoria {
  @JsonKey(includeToJson: false)
  final String? id;
  final String nombre; 
  final String descripcion; 
  final String? imagenUrl; 

  Categoria({
    this.id,
    required this.nombre,
    required this.descripcion,
    this.imagenUrl,
  });


  factory Categoria.fromJson(Map<String, dynamic> json) => _$CategoriaFromJson(json); 
  
  Map<String, dynamic> toJson() => _$CategoriaToJson(this);
}
