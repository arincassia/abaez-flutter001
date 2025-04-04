import 'package:flutter/material.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PantallaCambioColor(),
    );
  }
}

class PantallaCambioColor extends StatefulWidget {
  @override
  _PantallaCambioColorState createState() => _PantallaCambioColorState();
}

class _PantallaCambioColorState extends State<PantallaCambioColor> {
  List<Color> _colores = [Colors.blue, Colors.red, Colors.green];
  int _indiceColor = 0;

  void _cambiarColor() {
    setState(() {
      _indiceColor = (_indiceColor + 1) % _colores.length;
    });
  }
  
    void _resetearColor() {
    setState(() {
      _indiceColor = -1;
    });
  }
   

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Cambio de Color')),
    body: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  color: _indiceColor == -1 ? Colors.white : _colores[_indiceColor],
                  child: Center(
                    child: Text(
                      '¡Cambio de color!',
                      style: TextStyle(
                        fontSize: 30,
                        color: _indiceColor == -1 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _resetearColor,
                      child: Text('Reinicia color a blanco'),
                    ),
                    SizedBox(width: 10), 
                    ElevatedButton(
                      onPressed: _cambiarColor,
                      child: Text('Cambiar Color'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}