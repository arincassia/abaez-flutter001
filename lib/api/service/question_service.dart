import  'package:abaez/data/question_repository.dart';
import 'package:abaez/domain/question.dart';

class QuestionService {
  final QuestionRepository _repository;

  QuestionService(this._repository);

  final List<Question> questions = [];

  Future<List<Question>> getQuestions() async {
    final questions = await _repository.getQuestions();
    return questions;
  }
}

