import 'package:abaez/views/login_screen.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:abaez/bloc/page/contador_page.dart';
//import 'package:abaez/bloc/contador_bloc.dart';
/*import 'package:abaez/bloc/noticias_bloc.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/api/service/noticia_sevice.dart';
import 'package:abaez/bloc/event/noticias_event.dart';
import 'package:abaez/bloc/page/noticias_screen.dart';
*/
import 'package:abaez/di/locator.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await dotenv.load(fileName: '.env');
  await initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 254, 70, 85)),
      ),
      //home: const MyHomePage(title: 'Flutter Demo Alejandra Home Page '),
      home: const LoginScreen(),
      /*home: BlocProvider(
        create: (_) => ContadorBloc(),
        child: const ContadorPage(), // Cambiado a ContadorPage
      ),*/
      /*home: BlocProvider(
        create: (_) => NoticiasBloc(NoticiaRepository(NoticiaService()))..add(CargarNoticiasEvent()),
        child: const NoticiasScreen(), // Cambiado a NoticiasScreen
      ),
      */
    );
  }
}


