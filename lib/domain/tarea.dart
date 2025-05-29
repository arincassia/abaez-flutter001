import 'package:dart_mappable/dart_mappable.dart';
part 'tarea.mapper.dart';

@MappableClass()
class Tarea with TareaMappable{
  final String? id;
  final String usuario;
  final String titulo;
  final String tipo;
  final String? descripcion;
  final DateTime? fecha;
  final DateTime? fechaLimite; 
  final bool completado;

  Tarea({
    this.id,
    required this.usuario,
    required this.titulo,
    this.tipo = 'normal', 
    this.descripcion,
    this.fecha,
    this.fechaLimite,
    this.completado = false,
  });
}