import 'dart:async';
import 'package:abaez/bloc/connectivity/connectivity_event.dart';
import 'package:abaez/bloc/connectivity/connectivity_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/helpers/connectivity_service.dart';
import 'package:watch_it/watch_it.dart';


/// BLoC para gestionar el estado de la conectividad a Internet en la aplicación
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {  final ConnectivityService _connectivityService = di<ConnectivityService>();
  late StreamSubscription _connectivitySubscription;
  
  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityStatusChanged>(_onConnectivityStatusChanged);
    
    // Suscripción a cambios de conectividad
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (result) {        // En conectivity_plus 6.x, el resultado es una lista
        // Procesamos el resultado sea cual sea su tipo
        add(ConnectivityStatusChanged(result));
      }
    );
    
    // Verificación inicial
    add(CheckConnectivity());
  }
  
  Future<void> _onCheckConnectivity(
    CheckConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    final isConnected = await _connectivityService.hasInternetConnection();
    emit(isConnected ? ConnectivityConnected() : ConnectivityDisconnected());
  }
    void _onConnectivityStatusChanged(
    ConnectivityStatusChanged event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Utilizamos directamente el servicio para verificar la conectividad
    final isConnected = await _connectivityService.hasInternetConnection();
    emit(isConnected ? ConnectivityConnected() : ConnectivityDisconnected());
  }
  
  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
