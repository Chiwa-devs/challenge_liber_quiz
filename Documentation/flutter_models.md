// lib/data/models/question.dart
class Question {
  final String id;
  final String moduleId;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.moduleId,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      moduleId: json['moduleId'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'questionText': questionText,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}

// lib/data/models/module.dart
class QuizModule {
  final String id;
  final String name;
  final String icon;
  final int questionCount;

  QuizModule({
    required this.id,
    required this.name,
    required this.icon,
    required this.questionCount,
  });

  factory QuizModule.fromJson(Map<String, dynamic> json) {
    return QuizModule(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      questionCount: json['questionCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'questionCount': questionCount,
    };
  }
}

// lib/data/models/user_answer.dart
class UserAnswer {
  final String questionId;
  final int selectedAnswerIndex;
  final bool isCorrect;

  UserAnswer({
    required this.questionId,
    required this.selectedAnswerIndex,
    required this.isCorrect,
  });
}

// lib/data/models/quiz_session.dart
class QuizSession {
  final String moduleId;
  final String moduleName;
  final List<Question> questions;
  final List<UserAnswer> userAnswers;
  final int currentQuestionIndex;
  final int score;

  QuizSession({
    required this.moduleId,
    required this.moduleName,
    required this.questions,
    required this.userAnswers,
    required this.currentQuestionIndex,
    required this.score,
  });

  QuizSession copyWith({
    String? moduleId,
    String? moduleName,
    List<Question>? questions,
    List<UserAnswer>? userAnswers,
    int? currentQuestionIndex,
    int? score,
  }) {
    return QuizSession(
      moduleId: moduleId ?? this.moduleId,
      moduleName: moduleName ?? this.moduleName,
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
    );
  }

  bool get isCompleted => currentQuestionIndex >= questions.length;
  
  Question? get currentQuestion => 
    currentQuestionIndex < questions.length 
      ? questions[currentQuestionIndex] 
      : null;
}