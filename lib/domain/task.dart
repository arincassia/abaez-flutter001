class Task {
  final String titulo;
  final String tipo;
  final String descripcion; 
  final DateTime fechaLimite; 
  final List<String> pasos; 

  Task({
    required this.titulo,
    required this.tipo,
    required this.descripcion,
    required this.fechaLimite,
    this.pasos = const [],
  });
}