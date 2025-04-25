
class Noticia {
  final String id;
  final String titulo;
  final String contenido;
  final String fuente;
  final DateTime publicadaEl;
  final String? imagenUrl; // Nuevo campo para la URL de la imagen
  final String categoriaId; // ID de la categoría asociada

  Noticia({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.fuente,
    required this.publicadaEl,
    this.imagenUrl, // Campo opcional
    required this.categoriaId, // ID de la categoría asociada
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
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
}
}
