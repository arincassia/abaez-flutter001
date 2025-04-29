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
  List<Object?> get props => [message];
}

class CategoriaLoading extends CategoriaState {

}

class CategoriaLoaded extends CategoriaState {
  final List<Categoria> categorias;
  final DateTime lastUpdated;

  CategoriaLoaded(this.categorias, this.lastUpdated);

  @override
  List<Object?> get props => [categorias, lastUpdated];
}