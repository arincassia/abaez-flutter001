import 'package:equatable/equatable.dart';
import 'package:abaez/domain/categoria.dart';

abstract class CategoriaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class CategoriaInitEvent extends CategoriaEvent {
}

class CategoriaAddEvent extends CategoriaEvent {
  final Categoria categoria;
  
  CategoriaAddEvent(this.categoria);
}

class CategoriaUpdateEvent extends CategoriaEvent {
  final Categoria categoria;
  
  CategoriaUpdateEvent(this.categoria);
}

class CategoriaDeleteEvent extends CategoriaEvent {
  final String id;
  
  CategoriaDeleteEvent(this.id);
}