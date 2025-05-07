import 'package:equatable/equatable.dart';

abstract class CategoriaEvent extends Equatable {
   @override
   List<Object?> get props => [];
}

// Evento para cargar categorías
class CategoriaInitEvent extends CategoriaEvent {}

// Evento para crear una nueva categoría
class CategoriaCreateEvent extends CategoriaEvent {
  final String nombre;
  final String descripcion;
  final String imagenUrl;

  CategoriaCreateEvent({
    required this.nombre, 
    required this.descripcion, 
    this.imagenUrl = '',
  });

  @override
  List<Object?> get props => [nombre, descripcion, imagenUrl];
}

// Evento para actualizar una categoría existente
class CategoriaUpdateEvent extends CategoriaEvent {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagenUrl;

  CategoriaUpdateEvent({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
  });

  @override
  List<Object?> get props => [id, nombre, descripcion, imagenUrl];
}

// Evento para eliminar una categoría
class CategoriaDeleteEvent extends CategoriaEvent {
  final String id;

  CategoriaDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}