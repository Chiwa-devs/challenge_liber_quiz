import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String moduleId;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;

  const Question({
    required this.id,
    required this.moduleId,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
  });

  @override
  List<Object?> get props => [id, moduleId, questionText, options, correctOptionIndex];

  Question copyWith({
    String? id,
    String? moduleId,
    String? questionText,
    List<String>? options,
    int? correctOptionIndex,
    String? explanation,
  }) {
    return Question(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      explanation: explanation ?? this.explanation,
    );
  }
}
