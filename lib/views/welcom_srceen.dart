import 'package:abaez/views/contador.dart';
import 'package:flutter/material.dart';
import 'package:abaez/presentation/task_screen.dart';

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
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 174, 206),
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
              leading: Icon(Icons.list),
              title: Text('Lista de Tareas'),
              onTap: () {
               Navigator.pop(context); 
               Navigator.push(
               context,
              MaterialPageRoute(
              builder: (context) => TaskScreen(),
              ),
              );
                },
            ),
             ListTile(
              leading: Icon(Icons.list),
              title: Text('Contador'),
              onTap: () {
               Navigator.pop(context); 
               Navigator.push(
               context,
              MaterialPageRoute(
              builder: (context) => MyAppContador(),
              ),
              );
                },
            ),
              ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar'),
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
  