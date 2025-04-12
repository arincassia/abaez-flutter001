import 'package:abaez/domain/question.dart';
class QuestionRepository {

  Future<List<Question>> getQuestions() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      Question(
        questionText: '¿Cuál es la capital de Francia?',
        answerOptions: ['Madrid', 'París', 'Roma'],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: '¿Cuál es la capital de España?',
        answerOptions: ['Madrid', 'Barcelona', 'Valencia'],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: '¿Cuál es la capital de Italia?',
        answerOptions: ['Roma', 'Milán', 'Nápoles'],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: '¿Qué planeta es conocido como el planeta rojo?',
        answerOptions: ['Júpiter', 'Marte', 'Venus'],
        correctAnswerIndex: 2,
      ),
    ];
  }

}
