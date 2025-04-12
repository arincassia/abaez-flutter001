import 'package:flutter/material.dart';
import 'package:abaez/presentation/game_screen.dart'; 
import 'package:abaez/constans.dart';

class StartScreen extends StatelessWidget {

  const StartScreen({super.key}); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              AppConstants.welcomeMessage,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
              
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(), 
                  ),
                );
              },
              child: const Text(
                  AppConstants.startGame,
                  style: TextStyle(color: Colors.white),
                ),  
            ),
          ],
        ),
      ),
    );
  }
}
