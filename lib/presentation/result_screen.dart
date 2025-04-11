import 'package:abaez/constans.dart';
import 'package:flutter/material.dart';
import 'package:abaez/presentation/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestions;

  const ResultScreen({super.key, required this.finalScore, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    const double spacingHeight = 20.0;
    final String scoreText = '${AppConstants.finalScore}$finalScore/$totalQuestions';
    final String feedbackMessage = finalScore > (totalQuestions / 2)
        ? '¡Buen trabajo!'
        : '¡Sigue practicando!';
    
    final Color buttonColor = finalScore > (totalQuestions / 2)
        ? Colors.blue
        : Colors.green;

    const TextStyle scoreTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              scoreText,
              style: scoreTextStyle,
            ),
            const SizedBox(height: spacingHeight),
            Text(
              feedbackMessage,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
              ),
              child: const Text(AppConstants.playAgain, 
                style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
 }