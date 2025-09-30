import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';

abstract class QuizRepository {
  Future<List<Module>> getModules();
  Future<Module> getModuleById(String id);
  Future<List<Question>> getQuestionsByModule(String moduleId);
  Future<Question> getQuestionById(String id);
  Future<List<Question>> getAllQuestions();
  Future<void> addQuestion(Question question);
  Future<void> updateQuestion(Question question);
  Future<void> deleteQuestion(String questionId);
}
