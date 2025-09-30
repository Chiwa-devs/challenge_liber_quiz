import 'package:equatable/equatable.dart';
import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';
import 'package:challenge_liber_quiz/models/quiz_session.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class ModulesLoading extends QuizState {}

class ModulesLoaded extends QuizState {
  final List<Module> modules;

  const ModulesLoaded(this.modules);

  @override
  List<Object?> get props => [modules];
}

class ModuleSelected extends QuizState {
  final Module module;

  const ModuleSelected(this.module);

  @override
  List<Object?> get props => [module];
}

class QuizInProgress extends QuizState {
  final QuizSession session;
  final Question currentQuestion;
  final bool showResult;

  const QuizInProgress(this.session, this.currentQuestion, {this.showResult = false});

  @override
  List<Object?> get props => [session, currentQuestion, showResult];
}

class QuizCompleted extends QuizState {
  final QuizSession session;
  final int totalQuestions;

  const QuizCompleted(this.session, this.totalQuestions);

  @override
  List<Object?> get props => [session, totalQuestions];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}
