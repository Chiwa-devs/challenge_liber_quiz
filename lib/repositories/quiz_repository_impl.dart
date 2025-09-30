import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';
import 'package:challenge_liber_quiz/repositories/quiz_repository.dart';
import 'package:challenge_liber_quiz/services/database_service.dart';

class QuizRepositoryImpl implements QuizRepository {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Future<List<Module>> getModules() async {
    return await _databaseService.getModules();
  }

  @override
  Future<Module> getModuleById(String id) async {
    return await _databaseService.getModuleById(id);
  }

  @override
  Future<List<Question>> getQuestionsByModule(String moduleId) async {
    return await _databaseService.getQuestionsByModule(moduleId);
  }

  @override
  Future<Question> getQuestionById(String id) async {
    return await _databaseService.getQuestionById(id);
  }

  @override
  Future<List<Question>> getAllQuestions() async {
    return await _databaseService.getAllQuestions();
  }

  @override
  Future<void> addQuestion(Question question) async {
    await _databaseService.addQuestion(question);
  }

  @override
  Future<void> updateQuestion(Question question) async {
    await _databaseService.updateQuestion(question);
  }

  @override
  Future<void> deleteQuestion(String questionId) async {
    await _databaseService.deleteQuestion(questionId);
  }
}
