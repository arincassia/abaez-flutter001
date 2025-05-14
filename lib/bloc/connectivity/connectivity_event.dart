import 'package:equatable/equatable.dart';

/// Eventos para el BLoC de conectividad
abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
  
  @override
  List<Object> get props => [];
}

/// Evento que se dispara cuando cambia el estado de la conectividad
class ConnectivityStatusChanged extends ConnectivityEvent {
  final dynamic connectivityResult;
  
  const ConnectivityStatusChanged(this.connectivityResult);
  
  @override
  List<Object> get props => [connectivityResult.hashCode];
}

/// Evento para verificar manualmente el estado de la conectividad
class CheckConnectivity extends ConnectivityEvent {}
