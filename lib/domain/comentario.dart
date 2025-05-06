class Comentario {
  final String id;
  final String noticiaId;
  final String texto;
  final DateTime fecha;
  final String autor;

  Comentario({
    required this.id,
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
  });

  // Método para convertir un JSON de la API a un objeto Comentario
  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['_id'] as String, // El ID lo asigna CrudCrud
      noticiaId: json['noticiaId'] as String,
      texto: json['texto'] as String,
      fecha: DateTime.tryParse(json['fecha']) ?? DateTime.now(),
      autor: json['autor'] as String,
    );
  }

  // Método para convertir el objeto Comentario a JSON para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      'noticiaId': noticiaId,
      'texto': texto,
      'fecha': fecha.toIso8601String(),
      'autor': autor,
    };
  }
}
