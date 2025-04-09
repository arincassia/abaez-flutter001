import 'package:abaez/views/login_screen.dart';
import 'package:flutter/material.dart';


void main() {
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
    //  home: const MyHomePage(title: 'Flutter Demo Alejandra Home Page '),
      home: LoginScreen(),
    );
  }
}


