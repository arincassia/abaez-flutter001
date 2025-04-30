import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/contador_bloc.dart'; 
import 'package:abaez/bloc/state/contador_state.dart'; 

// Widget principal
class ContadorPage extends StatelessWidget {
  const ContadorPage({super.key}); // Agregado el parámetro key

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContadorBloc(),
      child: BlocBuilder<ContadorBloc, ContadorState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Demo'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Has pulsado el botón esta cantidad de veces:',
                  ),
                  Text(
                    '${state.contador}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Centra los botones horizontalmente
              children: [
                FloatingActionButton(
                  onPressed: () {
                    context.read<ContadorBloc>().add(IncrementarContador());
                  },
                  tooltip: 'Incrementar',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 8), // Espaciado entre los botones
                FloatingActionButton(
                  onPressed: () {
                    context.read<ContadorBloc>().add(DecrementarContador());
                  },
                  tooltip: 'Decrementar',
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 8), // Espaciado entre los botones
                FloatingActionButton(
                  onPressed: () {
                    context.read<ContadorBloc>().add(ResetearContador());
                  },
                  tooltip: 'Resetear',
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}