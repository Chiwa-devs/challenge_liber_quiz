// lib/presentation/bloc/auth/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) {
    if (event.username.trim().isNotEmpty) {
      emit(AuthSuccess(username: event.username.trim()));
    } else {
      emit(AuthFailure(message: 'El nombre es requerido'));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }
}

// auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;

  const LoginRequested({required this.username});

  @override
  List<Object> get props => [username];
}

class LogoutRequested extends AuthEvent {}

// auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final String username;

  const AuthSuccess({required this.username});

  @override
  List<Object> get props => [username];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// lib/presentation/bloc/quiz/quiz_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<LoadModules>(_onLoadModules);
    on<StartQuiz>(_onStartQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<NextQuestion>(_onNextQuestion);
    on<ResetQuiz>(_onResetQuiz);
  }

  void _onLoadModules(LoadModules event, Emitter<QuizState> emit) {
    emit(QuizLoading());
    
    // Datos mock - en producción vendrían de un repository
    final modules = [
      QuizModule(id: '1', name: 'Fundamentos y Prompting', icon: '📝', questionCount: 14),
      QuizModule(id: '2', name: 'Análisis y Síntesis de Datos', icon: '🔍', questionCount: 8),
      QuizModule(id: '3', name: 'IA como Copiloto de Marketing', icon: '📈', questionCount: 8),
      QuizModule(id: '4', name: 'Estrategia y Análisis Competitivo', icon: '⚡', questionCount: 8),
      QuizModule(id: '5', name: 'Planificación y Procesos', icon: '📅', questionCount: 8),
      QuizModule(id: '6', name: 'Presentación Ejecutiva', icon: '📊', questionCount: 8),
      QuizModule(id: '7', name: 'Ética y Seguridad', icon: '🛡️', questionCount: 4),
      QuizModule(id: '8', name: 'Creatividad con IA', icon: '🎨', questionCount: 4),
      QuizModule(id: '9', name: 'Prompting Avanzado', icon: '⚙️', questionCount: 4),
    ];
    
    emit(ModulesLoaded(modules: modules));
  }

  void _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) {
    emit(QuizLoading());
    
    // Mock questions - en producción vendrían del repository
    final questions = _getMockQuestions(event.moduleId);
    final module = _getModuleById(event.moduleId);
    
    if (questions.isNotEmpty && module != null) {
      final session = QuizSession(
        moduleId: event.moduleId,
        moduleName: module.name,
        questions: questions,
        userAnswers: [],
        currentQuestionIndex: 0,
        score: 0,
      );
      
      emit(QuizInProgress(session: session));
    } else {
      emit(QuizError(message: 'No se pudieron cargar las preguntas'));
    }
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final session = currentState.session;
      final currentQuestion = session.currentQuestion;
      
      if (currentQuestion != null) {
        final isCorrect = event.selectedAnswerIndex == currentQuestion.correctAnswerIndex;
        final userAnswer = UserAnswer(
          questionId: currentQuestion.id,
          selectedAnswerIndex: event.selectedAnswerIndex,
          isCorrect: isCorrect,
        );
        
        final updatedAnswers = [...session.userAnswers, userAnswer];
        final newScore = isCorrect ? session.score + 1 : session.score;
        
        final updatedSession = session.copyWith(
          userAnswers: updatedAnswers,
          score: newScore,
        );
        
        emit(QuestionAnswered(
          session: updatedSession,
          selectedAnswerIndex: event.selectedAnswerIndex,
          isCorrect: isCorrect,
        ));
      }
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is QuestionAnswered) {
      final currentState = state as QuestionAnswered;
      final session = currentState.session;
      
      final nextIndex = session.currentQuestionIndex + 1;
      
      if (nextIndex >= session.questions.length) {
        emit(QuizCompleted(session: session));
      } else {
        final updatedSession = session.copyWith(
          currentQuestionIndex: nextIndex,
        );
        emit(QuizInProgress(session: updatedSession));
      }
    }
  }

  void _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) {
    add(LoadModules());
  }

  List<Question> _getMockQuestions(String moduleId) {
    // Mock data - en producción esto vendría de un repository
    return [
      Question(
        id: '1',
        moduleId: moduleId,
        questionText: '¿Qué busca romper la IA al generar un gran volumen de ideas rápidamente?',
        options: [
          'El presupuesto del proyecto',
          'El sesgo del primer pensamiento',
          'La barrera del idioma',
          'Las reglas de la empresa'
        ],
        correctAnswerIndex: 1,
      ),
      // Agregar más preguntas aquí...
    ];
  }

  QuizModule? _getModuleById(String moduleId) {
    final modules = [
      QuizModule(id: '1', name: 'Fundamentos y Prompting', icon: '📝', questionCount: 14),
      // ... otros módulos
    ];
    
    try {
      return modules.firstWhere((module) => module.id == moduleId);
    } catch (e) {
      return null;
    }
  }
}

// quiz_event.dart
part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class LoadModules extends QuizEvent {}

class StartQuiz extends QuizEvent {
  final String moduleId;

  const StartQuiz({required this.moduleId});

  @override
  List<Object> get props => [moduleId];
}

class AnswerQuestion extends QuizEvent {
  final int selectedAnswerIndex;

  const AnswerQuestion({required this.selectedAnswerIndex});

  @override
  List<Object> get props => [selectedAnswerIndex];
}

class NextQuestion extends QuizEvent {}

class ResetQuiz extends QuizEvent {}

// quiz_state.dart
part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class ModulesLoaded extends QuizState {
  final List<QuizModule> modules;

  const ModulesLoaded({required this.modules});

  @override
  List<Object> get props => [modules];
}

class QuizInProgress extends QuizState {
  final QuizSession session;

  const QuizInProgress({required this.session});

  @override
  List<Object> get props => [session];
}

class QuestionAnswered extends QuizState {
  final QuizSession session;
  final int selectedAnswerIndex;
  final bool isCorrect;

  const QuestionAnswered({
    required this.session,
    required this.selectedAnswerIndex,
    required this.isCorrect,
  });

  @override
  List<Object> get props => [session, selectedAnswerIndex, isCorrect];
}

class QuizCompleted extends QuizState {
  final QuizSession session;

  const QuizCompleted({required this.session});

  @override
  List<Object> get props => [session];
}

class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});

  @override
  List<Object> get props => [message];
}