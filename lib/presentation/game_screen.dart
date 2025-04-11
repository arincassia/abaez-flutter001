import 'package:abaez/constans.dart';
import 'package:abaez/data/question_repository.dart';
import 'package:flutter/material.dart';
import 'package:abaez/api/service/question_service.dart';
import 'package:abaez/presentation/result_screen.dart';
import 'package:abaez/domain/question.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  int currentQuestionIndex = 0;
  int userScore = 0;
  List<Question> questionsList = [];
  String questionCounterText = '';
  int? selectedAnswerIndex; 
  bool? isCorrectAnswer; 
  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    final QuestionRepository repository = QuestionRepository();
    final questionService = QuestionService(repository);
    questionsList = await questionService.getQuestions();
    setState(() {
      questionCounterText =
          'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
    });
  }void handleAnswer(int selectedIndex) {
  setState(() {
    selectedAnswerIndex = selectedIndex;
    isCorrectAnswer = questionsList[currentQuestionIndex].correctAnswerIndex == selectedIndex;
    print('Selected Answer Index: $selectedAnswerIndex');
    print('Is Correct Answer: $isCorrectAnswer');
  });

  Future.delayed(const Duration(seconds: 1), () {
    if (!context.mounted) return;
    if (isCorrectAnswer == true) {
      userScore++;
    }

    if (currentQuestionIndex < questionsList.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isCorrectAnswer = null;
        questionCounterText =
            'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
      });
    } else {
      if (context.mounted){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(userScore: userScore),
        ),
      );
      }
    }
  });
}


  @override
  Widget build(BuildContext context) {
    print('Widget reconstruido');
    const double spacingHeight = 16.0; // Modificacion 2.1
    if (questionsList.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuestion = questionsList[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppConstants.titleApp),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionCounterText,
              style: const TextStyle(fontSize: 16, color: Colors.grey), //Modificacion 2.3
            ),
            const SizedBox(height: spacingHeight),
            Text(
              currentQuestion.questionText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
     Column(
  children: List.generate(
    currentQuestion.answerOptions.length,
    (index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: selectedAnswerIndex == null
            ? () => handleAnswer(index)
            : null, 
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (selectedAnswerIndex == index) {
                return isCorrectAnswer == true ? Colors.green : Colors.red;
              }
              return Colors.blue; 
            },
          ), //Modificacion 2.2
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: Text(
          currentQuestion.answerOptions[index],
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}