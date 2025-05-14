import 'package:flutter/material.dart';
import 'package:abaez/components/connectivity_alert.dart';

/// Widget que envuelve la aplicación y muestra una alerta de conectividad cuando es necesario
class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Como ahora usamos SnackBar que se superpone en la pantalla,
    // ya no necesitamos colocar la alerta en una columna
    return Stack(
      children: [
        // Contenido principal de la aplicación
        child,
        
        // Widget invisible que escucha cambios de conectividad y muestra SnackBars
        const ConnectivityAlert(),
      ],
    );
  }
}
