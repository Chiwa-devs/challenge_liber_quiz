import 'package:equatable/equatable.dart';
import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminDataLoaded extends AdminState {
  final List<Module> modules;
  final List<Question> questions;

  const AdminDataLoaded(this.modules, this.questions);

  @override
  List<Object?> get props => [modules, questions];
}

class QuestionAdded extends AdminState {
  final Question question;

  const QuestionAdded(this.question);

  @override
  List<Object?> get props => [question];
}

class QuestionDeleted extends AdminState {
  final String questionId;

  const QuestionDeleted(this.questionId);

  @override
  List<Object?> get props => [questionId];
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
