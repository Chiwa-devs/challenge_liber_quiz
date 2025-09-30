import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:challenge_liber_quiz/blocs/admin_event.dart';
import 'package:challenge_liber_quiz/blocs/admin_state.dart';
import 'package:challenge_liber_quiz/repositories/quiz_repository.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final QuizRepository _repository;

  AdminBloc(this._repository) : super(AdminInitial()) {
    on<LoadAdminData>(_onLoadAdminData);
    on<AddQuestion>(_onAddQuestion);
    on<DeleteQuestion>(_onDeleteQuestion);
    on<UpdateQuestion>(_onUpdateQuestion);
  }

  Future<void> _onLoadAdminData(LoadAdminData event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final modules = await _repository.getModules();
      final questions = await _repository.getAllQuestions();

      emit(AdminDataLoaded(modules, questions));
    } catch (e) {
      emit(AdminError('Error loading admin data: $e'));
    }
  }

  Future<void> _onAddQuestion(AddQuestion event, Emitter<AdminState> emit) async {
    try {
      await _repository.addQuestion(event.question);
      emit(QuestionAdded(event.question));

      // Reload admin data to show updated list
      add(LoadAdminData());
    } catch (e) {
      emit(AdminError('Error adding question: $e'));
    }
  }

  Future<void> _onDeleteQuestion(DeleteQuestion event, Emitter<AdminState> emit) async {
    try {
      await _repository.deleteQuestion(event.questionId);
      emit(QuestionDeleted(event.questionId));

      // Reload admin data to show updated list
      add(LoadAdminData());
    } catch (e) {
      emit(AdminError('Error deleting question: $e'));
    }
  }

  Future<void> _onUpdateQuestion(UpdateQuestion event, Emitter<AdminState> emit) async {
    try {
      await _repository.updateQuestion(event.question);
      emit(QuestionAdded(event.question)); // Reuse same state

      // Reload admin data to show updated list
      add(LoadAdminData());
    } catch (e) {
      emit(AdminError('Error updating question: $e'));
    }
  }
}
