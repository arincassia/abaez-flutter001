import 'package:abaez/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/snackbar_helper.dart';

/// Servicio para verificar la conectividad a Internet
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  /// Verifica si el dispositivo tiene conectividad a Internet
  /// Retorna true si hay conexión, false en caso contrario
  Future<bool> hasInternetConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      // En la versión 6.x de connectivity_plus, checkConnectivity devuelve una lista
      // Verificamos si hay al menos un resultado que no sea NONE
      return results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      debugPrint('❌ Error al verificar la conectividad: $e');
      return false;
    }
  }

  /// Verifica la conectividad y lanza una excepción si no hay conexión a Internet
  /// Esta función debe ser llamada antes de realizar cualquier solicitud a la API
  Future<void> checkConnectivity() async {
    if (!await hasInternetConnection()) {
      throw ApiException('Por favor, verifica tu conexión a internet.');
    }
  }
  /// Muestra un SnackBar con un mensaje de error de conectividad que permanece hasta que hay conexión
  void showConnectivityError(BuildContext context) {
    SnackBarHelper.showServerError(
      context, 
      ApiConstantes.errorNoInternet,
      duration: const Duration(days: 1) // Virtualmente infinito
    );
  }
}
