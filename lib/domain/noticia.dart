class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String imageUrl;
  final String categoriaId; // ID de la categoría asociada

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
    required this.categoriaId,
  });

  // Método para convertir la instancia en un mapa
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl.toIso8601String(),
      'urlImagen': imageUrl,
      'categoriaId': categoriaId, // Añadido al mapa
    };
  }

  // Método para crear una instancia desde un mapa
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['_id'] ?? '',
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      fuente: json['fuente'] ?? 'Fuente desconocida',
      publicadaEl: DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
      imageUrl: json['urlImagen'] ?? '',
      categoriaId: json['categoriaId'] ?? 'sin_categoria', // Valor por defecto
    );
  }
}
