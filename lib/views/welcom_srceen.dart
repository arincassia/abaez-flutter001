import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String username; // Declarar el nombre de usuario como parámetro

  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Bienvenida'),
      ),
      body: Center(
        child: Text(
          '¡Bienvenido/a, $username, a la aplicación!',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
