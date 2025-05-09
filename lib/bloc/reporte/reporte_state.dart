import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ReporteState extends Equatable {
  const ReporteState();
  
  @override
  List<Object?> get props => [];
}

class ReporteInitial extends ReporteState {}

class ReporteLoading extends ReporteState {}

class ReporteSuccess extends ReporteState {
  final String mensaje;
  
  const ReporteSuccess({required this.mensaje});
  
  @override
  List<Object?> get props => [mensaje];
}

class ReporteError extends ReporteState {
  final String errorMessage;
  final int? statusCode;
  
  const ReporteError({
    required this.errorMessage,
    this.statusCode,
  });
  
  @override
  List<Object?> get props => [errorMessage, statusCode];
}