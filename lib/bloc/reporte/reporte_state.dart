import 'package:equatable/equatable.dart';

abstract class ReporteState extends Equatable {
  const ReporteState();
  
  @override
  List<Object> get props => [];
}

class ReporteInitial extends ReporteState {}

class ReporteLoading extends ReporteState {}

class ReporteSuccess extends ReporteState {}

class ReporteError extends ReporteState {
  final String errorMessage;
  
  const ReporteError(this.errorMessage);
  
  @override
  List<Object> get props => [errorMessage];
}