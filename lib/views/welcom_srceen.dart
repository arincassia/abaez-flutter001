import 'package:flutter/material.dart';
import 'package:abaez/views/tasks.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;

  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagina de bienvenida')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido/a, $username!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TasksScreen(), // Asegúrate de crear esta pantalla
                  ),
                );
                // Aquí puedes agregar la navegación a la pantalla de cotizaciones
                // Por ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => QuotesScreen()));
              },
              child: const Text('Lista de Tareas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
