import 'package:equatable/equatable.dart';
import 'package:challenge_liber_quiz/models/question.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminData extends AdminEvent {}

class AddQuestion extends AdminEvent {
  final Question question;

  const AddQuestion(this.question);

  @override
  List<Object?> get props => [question];
}

class DeleteQuestion extends AdminEvent {
  final String questionId;

  const DeleteQuestion(this.questionId);

  @override
  List<Object?> get props => [questionId];
}

class UpdateQuestion extends AdminEvent {
  final Question question;

  const UpdateQuestion(this.question);

  @override
  List<Object?> get props => [question];
}
