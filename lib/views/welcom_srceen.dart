
import 'package:abaez/views/contador.dart';
import 'package:flutter/material.dart';
import 'package:abaez/presentation/task_screen.dart';
import 'package:abaez/presentation/start_screen.dart';
import 'package:abaez/views/quote_screen.dart';
import 'package:abaez/views/noticias_screen.dart';
class WelcomeScreen extends StatelessWidget {
  final String username;

  const WelcomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagina de bienvenida'),
      ),
      drawer: Drawer( 
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 174, 206),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Lista de Tareas'),
              onTap: () {
               Navigator.pop(context); 
               Navigator.push(
               context,
              MaterialPageRoute(
              builder: (context) => const TaskScreen(),
              ),
              );
                },
            ),
             ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Contador'),
              onTap: () {
               Navigator.pop(context); 
               Navigator.push(
               context,
             MaterialPageRoute(
             builder: (context) => const MyHomePage(title: 'Contador'),
             ),
              );
                },
            ),
             ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('Juego de preguntas'),
              onTap: () {
               Navigator.pop(context); 
               Navigator.push(
               context,
             MaterialPageRoute(
             builder: (context) => const StartScreen(),
             ),
              );
                },
            ),
             ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Cotizaciones'),
              onTap: () {
               Navigator.pop(context); 
               Navigator.push(
               context,
             MaterialPageRoute(
             builder: (context) => const QuoteScreen(),
             ),
              );
                },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Noticias'),
              onTap: () {
               Navigator.pop(context); 
               Navigator.push(
               context,
             MaterialPageRoute(
             builder: (context) => const NoticiasScreen(),
             ),
              );
                },
            ),
              ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context); 
                },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido/a, $username!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
          ],
        ),
      ),
    );
  }
  }
  