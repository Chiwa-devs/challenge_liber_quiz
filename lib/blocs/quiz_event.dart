import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadModules extends QuizEvent {}

class SelectModule extends QuizEvent {
  final String moduleId;

  const SelectModule(this.moduleId);

  @override
  List<Object?> get props => [moduleId];
}

class StartQuiz extends QuizEvent {
  final String userName;
  final String moduleId;

  const StartQuiz(this.userName, this.moduleId);

  @override
  List<Object?> get props => [userName, moduleId];
}

class AnswerQuestion extends QuizEvent {
  final String questionId;
  final int selectedOption;

  const AnswerQuestion(this.questionId, this.selectedOption);

  @override
  List<Object?> get props => [questionId, selectedOption];
}

class NextQuestion extends QuizEvent {}

class PreviousQuestion extends QuizEvent {}

class FinishQuiz extends QuizEvent {}

class ResetQuiz extends QuizEvent {}
