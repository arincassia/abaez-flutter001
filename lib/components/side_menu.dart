import 'package:flutter/material.dart';
import 'package:abaez/helpers/dialog_helper.dart';
import 'package:abaez/views/contador.dart';
import 'package:abaez/views/noticias_screen.dart';
import 'package:abaez/views/quote_screen.dart';
import 'package:abaez/views/start_screen.dart';
import 'package:abaez/views/welcome_screen.dart';
import 'package:abaez/views/tarea_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 80, // To change the height of DrawerHeader
            child: DrawerHeader(
              decoration:  BoxDecoration(color: Color.fromARGB(255, 217, 162, 180)),
              margin: EdgeInsets.zero, // Elimina el margen predeterminado
              padding: EdgeInsets.symmetric(horizontal: 18.0), // Elimina el padding interno
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menú ',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
          ),
          ListTile(
  leading: const Icon(Icons.home),
  title: const Text('Inicio'),
  onTap: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(
          username: 'Usuario', // Add the required parameter here
        ),
      ),
    );
  },
),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Cotizaciones'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuoteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TareaScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper), // Ícono para la nueva opción
            title: const Text('Noticias'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NoticiaScreen()), // Navega a MiAppScreen
              );
            },
          ),      
         
          ListTile(
            leading: const Icon(Icons.numbers), // Ícono para el contador
            title: const Text('Contador'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Contador'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.stars), // Ícono para el contador
            title: const Text('Juego'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartScreen(),
                ),
              );
            },
          ),          
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              DialogHelper.mostrarDialogoCerrarSesion(context);
            },
          ),
        ],
      ),
    );
  }
}