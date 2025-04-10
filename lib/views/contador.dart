import 'package:flutter/material.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Advertencia'),
          content: const Text('Esto es una advertencia importante.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Has presionado el botón esta cantidad de veces:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (_counter > 0)
              const Text(
                'Contador en positivo',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            if (_counter < 0)
              const Text(
                'Contador en negativo',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            if (_counter == 0)
              const Text(
                'Contador en cero',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showWarningDialog(context);
              },
              child: const Text('Mostrar Advertencia'),
            ),
            
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _resetCounter,
            tooltip: 'Reset',
            heroTag: 'ResetButton',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            heroTag: 'DecrementButton',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            heroTag: 'incrementButton',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}