// category.dart
class Categoria {
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
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['_id'] as String, // El ID lo asigna CrudCrud
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      imagenUrl: json['imagenUrl'] as String?,
    );
  }

  // Método para convertir el objeto Category a JSON para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
    };
  }
}
