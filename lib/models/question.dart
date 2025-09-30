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

  // Método para convertir opciones a string para almacenamiento
  String get optionsAsString => options.join(',');

  // Factory method para crear desde string (útil para base de datos)
  factory Question.fromStringOptions({
    required String id,
    required String moduleId,
    required String questionText,
    required String optionsString,
    required int correctOptionIndex,
    String? explanation,
  }) {
    final options = optionsString.split(',');
    return Question(
      id: id,
      moduleId: moduleId,
      questionText: questionText,
      options: options,
      correctOptionIndex: correctOptionIndex,
      explanation: explanation,
    );
  }
}
