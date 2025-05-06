import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:abaez/domain/comentario.dart';

@immutable
abstract class ComentarioState extends Equatable {
  const ComentarioState();
  
  @override
  List<Object?> get props => [];
}

class ComentarioInitial extends ComentarioState {}

class ComentarioLoading extends ComentarioState {}

class ComentarioLoaded extends ComentarioState {
  final List<Comentario> comentariosList;
  
  const ComentarioLoaded({required this.comentariosList});
  
  @override
  List<Object> get props => [comentariosList];
}

class ComentarioError extends ComentarioState {
  final String errorMessage;
  
  const ComentarioError({required this.errorMessage});
  
  @override
  List<Object> get props => [errorMessage];
}