class Preferencia {
  final List<String> categoriasSeleccionadas;
  String? id;

  Preferencia({required this.categoriasSeleccionadas, this.id});

  factory Preferencia.empty() {
    return Preferencia(categoriasSeleccionadas: []);
  }

  Preferencia copyWith({List<String>? categoriasSeleccionadas}) {
    return Preferencia(
      categoriasSeleccionadas: categoriasSeleccionadas ?? this.categoriasSeleccionadas,
    );
  }

  // Método para convertir objeto Preferencia a Map<String, dynamic> (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'categoriasSeleccionadas': categoriasSeleccionadas,
    };
  }

  // Constructor factory para crear un objeto Preferencia desde Map<String, dynamic> (desde JSON)
  factory Preferencia.fromJson(Map<String, dynamic> json) {
    return Preferencia(
      categoriasSeleccionadas: json['categoriasSeleccionadas'] != null
          ? List<String>.from(json['categoriasSeleccionadas'])
          : [],
      id: json['id'] as String?,
    );
  }
}
