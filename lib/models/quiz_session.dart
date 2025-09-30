import 'package:equatable/equatable.dart';

class QuizSession extends Equatable {
  final String userName;
  final String moduleId;
  final List<String> questionIds;
  final Map<String, int?> answers; // questionId -> selectedOptionIndex
  final int currentQuestionIndex;
  final int score;

  const QuizSession({
    required this.userName,
    required this.moduleId,
    required this.questionIds,
    required this.answers,
    required this.currentQuestionIndex,
    required this.score,
  });

  bool get isCompleted => currentQuestionIndex >= questionIds.length;

  int? getAnswerForQuestion(String questionId) => answers[questionId];

  bool hasAnsweredQuestion(String questionId) => answers.containsKey(questionId);

  QuizSession copyWith({
    String? userName,
    String? moduleId,
    List<String>? questionIds,
    Map<String, int?>? answers,
    int? currentQuestionIndex,
    int? score,
  }) {
    return QuizSession(
      userName: userName ?? this.userName,
      moduleId: moduleId ?? this.moduleId,
      questionIds: questionIds ?? this.questionIds,
      answers: answers ?? this.answers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [userName, moduleId, questionIds, answers, currentQuestionIndex, score];
}
