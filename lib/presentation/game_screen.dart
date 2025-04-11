import 'package:flutter/material.dart';
import 'package:abaez/constans.dart';
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.titleApp),
      ),
      body: const Center(
        child:  Text(
          'Aquí van las preguntas del juego',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}