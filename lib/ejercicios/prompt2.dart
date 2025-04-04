import 'package:flutter/material.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _contador = 0;

  void _incrementarContador() {
    setState(() {
      _contador++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi App')),
       body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.green,
            padding: EdgeInsets.all(20),
            child: Text('Hola, Flutter', style: TextStyle(fontSize: 24)),
          ),
          Text('Veces presionado: $_contador', style: TextStyle(color: Colors.blue)),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _incrementarContador,
            child: Text('Toca aquí'),
          ),
        ],
      ),
       )
    );
  }
}
