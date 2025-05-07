import 'package:equatable/equatable.dart';
import 'package:abaez/domain/categoria.dart';
 
abstract class CategoriaState extends Equatable {
  @override
  List<Object?> get props => [];
}
 
class CategoriaInitial extends CategoriaState {
  @override
  List<Object> get props => [];
}
 
class CategoriaError extends CategoriaState {
  final String message;
 
  CategoriaError(this.message);
 
  @override
  List<Object> get props => [message];
}
 
class CategoriaLoading extends CategoriaState {}
 
class CategoriaLoaded extends CategoriaState {
  final List<Categoria> categorias;
  final DateTime timestamp;

  CategoriaLoaded(this.categorias, this.timestamp);

  @override
  List<Object> get props => [categorias, timestamp];
}

// Estados para operaciones específicas
class CategoriaCreating extends CategoriaState {}

class CategoriaCreated extends CategoriaState {
  final Categoria categoria;
  
  CategoriaCreated(this.categoria);
  
  @override
  List<Object> get props => [categoria];
}

class CategoriaUpdating extends CategoriaState {}

class CategoriaUpdated extends CategoriaState {
  final Categoria categoria;
  
  CategoriaUpdated(this.categoria);
  
  @override
  List<Object> get props => [categoria];
}

class CategoriaDeleting extends CategoriaState {}

class CategoriaDeleted extends CategoriaState {
  final String id;
  
  CategoriaDeleted(this.id);
  
  @override
  List<Object> get props => [id];
}