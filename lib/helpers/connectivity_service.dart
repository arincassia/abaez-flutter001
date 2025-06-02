import 'dart:async';

import 'package:abaez/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:abaez/exceptions/api_exception.dart';

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
 // ...existing code...
  
  /// Muestra un banner de conectividad en la parte superior de la pantalla
  /// que permanece visible hasta que se restablezca la conexión
  void showConnectivityError(BuildContext context) {
    // Verificar si el contexto sigue siendo válido
    if (!context.mounted) return;
    
    // Mostrar el banner de conectividad
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.red[100],
        leading: const Icon(Icons.wifi_off, color: Colors.red),
        content: const Text(
          ApiConstantes.errorNoInternet,
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Intentar verificar la conexión nuevamente
              
              if (await hasInternetConnection()) {
                // Si hay conexión, cerrar el banner
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              }
            },
            child: const Text('Reintentar'),
          ),
        ],
        padding: const EdgeInsets.all(16),
        elevation: 5,
      ),
    );
    
    // Configurar una verificación periódica de conexión para cerrar el banner automáticamente
    _startConnectivityCheck(context);
  }
  
  // Una referencia para cancelar el timer si es necesario
  Timer? _connectivityTimer;
  
  /// Inicia una verificación periódica de la conectividad
  void _startConnectivityCheck(BuildContext context) {
    // Cancelar cualquier timer existente
    _connectivityTimer?.cancel();
    
    // Crear un nuevo timer que verifica la conexión cada 5 segundos
    _connectivityTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (await hasInternetConnection()) {
        // Si hay conexión, cerrar el banner y detener el timer
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        }
        timer.cancel();
        _connectivityTimer = null;
      }
    });
  }
  
  /// Método para limpiar recursos cuando el servicio ya no es necesario
  void dispose() {
    _connectivityTimer?.cancel();
    _connectivityTimer = null;
  }
}
