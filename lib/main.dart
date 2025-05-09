import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importa flutter_bloc
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:abaez/bloc/preferencia/preferencia_bloc.dart';
import 'package:abaez/bloc/preferencia/preferencia_event.dart';
import 'package:abaez/di/locator.dart';

import 'package:abaez/views/login_screen.dart';
import 'package:abaez/bloc/contador/contador_bloc.dart'; // Importa el BLoC del contador

Future<void> main() async {
  // Carga las variables de entorno
  await dotenv.load(fileName: '.env');
  await initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ContadorBloc()),
        BlocProvider(create: (context) => PreferenciaBloc()..add(const CargarPreferencias())),
        BlocProvider(create: (context) => ComentarioBloc()),      
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 254, 70, 85)),        ),
        home: const LoginScreen(), // Pantalla inicial
      ),
    );
  }
}