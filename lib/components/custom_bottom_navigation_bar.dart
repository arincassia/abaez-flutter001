import 'package:flutter/material.dart';
import 'package:abaez/helpers/dialog_helper.dart';
import 'package:abaez/views/welcome_screen.dart';
import 'package:abaez/views/tarea_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
  });
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0: // Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen(username:  'Usuario',)),
        );
        break;
      case 1: // Añadir Tarea
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TareaScreen()),
        );
        break;
      case 2: // Salir
        DialogHelper.mostrarDialogoCerrarSesion(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tarea'),
        BottomNavigationBarItem(icon: Icon(Icons.close), label: 'Salir'),
      ],
    );
  }
}