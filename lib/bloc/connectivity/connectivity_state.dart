import 'package:equatable/equatable.dart';

/// Estados posibles para el BLoC de conectividad
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
  
  @override
  List<Object> get props => [];
}

/// Estado inicial antes de verificar la conectividad
class ConnectivityInitial extends ConnectivityState {}

/// Estado que indica que hay conexión a Internet
class ConnectivityConnected extends ConnectivityState {}

/// Estado que indica que no hay conexión a Internet
class ConnectivityDisconnected extends ConnectivityState {}
