import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:challenge_liber_quiz/blocs/quiz_event.dart';
import 'package:challenge_liber_quiz/blocs/quiz_state.dart';
import 'package:challenge_liber_quiz/models/quiz_session.dart';
import 'package:challenge_liber_quiz/repositories/quiz_repository.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;

  QuizBloc(this._repository) : super(QuizInitial()) {
    on<LoadModules>(_onLoadModules);
    on<SelectModule>(_onSelectModule);
    on<StartQuiz>(_onStartQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<FinishQuiz>(_onFinishQuiz);
    on<ResetQuiz>(_onResetQuiz);
  }

  Future<void> _onLoadModules(LoadModules event, Emitter<QuizState> emit) async {
    emit(ModulesLoading());
    try {
      final modules = await _repository.getModules();
      emit(ModulesLoaded(modules));
    } catch (e) {
      emit(QuizError('Error loading modules: $e'));
    }
  }

  Future<void> _onSelectModule(SelectModule event, Emitter<QuizState> emit) async {
    try {
      final module = await _repository.getModuleById(event.moduleId);
      emit(ModuleSelected(module));
    } catch (e) {
      emit(QuizError('Error selecting module: $e'));
    }
  }

  Future<void> _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) async {
    try {
      final questions = await _repository.getQuestionsByModule(event.moduleId);
      final session = QuizSession(
        userName: event.userName,
        moduleId: event.moduleId,
        questionIds: questions.map((q) => q.id).toList(),
        answers: {},
        currentQuestionIndex: 0,
        score: 0,
      );

      final currentQuestion = questions.first;
      emit(QuizInProgress(session, currentQuestion));
    } catch (e) {
      emit(QuizError('Error starting quiz: $e'));
    }
  }

  Future<void> _onAnswerQuestion(AnswerQuestion event, Emitter<QuizState> emit) async {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final session = currentState.session;
      final question = currentState.currentQuestion;

      // Check if answer is correct
      final isCorrect = question.correctOptionIndex == event.selectedOption;
      final newScore = isCorrect ? session.score + 1 : session.score;

      // Update session with answer
      final updatedAnswers = Map<String, int?>.from(session.answers);
      updatedAnswers[question.id] = event.selectedOption;

      final updatedSession = session.copyWith(
        answers: updatedAnswers,
        score: newScore,
      );

      // Show result briefly before moving to next question
      emit(QuizInProgress(updatedSession, question, showResult: true));

      // Auto-advance to next question after showing result
      await Future.delayed(const Duration(milliseconds: 1500));
      add(NextQuestion());
    }
  }

  Future<void> _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) async {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final session = currentState.session;

      if (session.currentQuestionIndex + 1 >= session.questionIds.length) {
        add(FinishQuiz());
        return;
      }

      try {
        final nextQuestionIndex = session.currentQuestionIndex + 1;
        final nextQuestionId = session.questionIds[nextQuestionIndex];
        final nextQuestion = await _repository.getQuestionById(nextQuestionId);

        final updatedSession = session.copyWith(currentQuestionIndex: nextQuestionIndex);
        emit(QuizInProgress(updatedSession, nextQuestion));
      } catch (e) {
        emit(QuizError('Error loading next question: $e'));
      }
    }
  }

  Future<void> _onPreviousQuestion(PreviousQuestion event, Emitter<QuizState> emit) async {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final session = currentState.session;

      if (session.currentQuestionIndex > 0) {
        try {
          final prevQuestionIndex = session.currentQuestionIndex - 1;
          final prevQuestionId = session.questionIds[prevQuestionIndex];
          final prevQuestion = await _repository.getQuestionById(prevQuestionId);

          final updatedSession = session.copyWith(currentQuestionIndex: prevQuestionIndex);
          emit(QuizInProgress(updatedSession, prevQuestion));
        } catch (e) {
          emit(QuizError('Error loading previous question: $e'));
        }
      }
    }
  }

  Future<void> _onFinishQuiz(FinishQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final session = currentState.session;
      final totalQuestions = session.questionIds.length;

      emit(QuizCompleted(session, totalQuestions));
    }
  }

  Future<void> _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) async {
    emit(QuizInitial());
  }
}
