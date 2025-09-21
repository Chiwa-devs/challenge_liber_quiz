// lib/presentation/bloc/admin/admin_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminInitial()) {
    on<LoadQuestionsForModule>(_onLoadQuestionsForModule);
    on<AddQuestion>(_onAddQuestion);
    on<DeleteQuestion>(_onDeleteQuestion);
  }

  void _onLoadQuestionsForModule(LoadQuestionsForModule event, Emitter<AdminState> emit) {
    emit(AdminLoading());
    
    // Mock data - en producción vendría del repository
    final questions = _getMockQuestionsForModule(event.moduleId);
    emit(QuestionsLoaded(questions: questions));
  }

  void _onAddQuestion(AddQuestion event, Emitter<AdminState> emit) {
    emit(AdminLoading());
    
    // Validaciones
    if (event.question.questionText.trim().isEmpty) {
      emit(AdminError(message: 'La pregunta es requerida'));
      return;
    }
    
    if (event.question.options.any((option) => option.trim().isEmpty)) {
      emit(AdminError(message: 'Todas las opciones son requeridas'));
      return;
    }
    
    // Simular guardado exitoso
    emit(QuestionAdded(message: 'Pregunta añadida exitosamente'));
  }

  void _onDeleteQuestion(DeleteQuestion event, Emitter<AdminState> emit) {
    emit(AdminLoading());
    
    // Simular eliminación exitosa
    emit(QuestionDeleted(message: 'Pregunta eliminada exitosamente'));
  }

  List<Question> _getMockQuestionsForModule(String moduleId) {
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
      Question(
        id: '2',
        moduleId: moduleId,
        questionText: '¿Cuál es la mejor práctica para escribir prompts efectivos?',
        options: [
          'Ser muy breve',
          'Usar palabras técnicas',
          'Ser específico y claro',
          'Usar solo mayúsculas'
        ],
        correctAnswerIndex: 2,
      ),
    ];
  }
}

// admin_event.dart
part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestionsForModule extends AdminEvent {
  final String moduleId;

  const LoadQuestionsForModule({required this.moduleId});

  @override
  List<Object> get props => [moduleId];
}

class AddQuestion extends AdminEvent {
  final Question question;

  const AddQuestion({required this.question});

  @override
  List<Object> get props => [question];
}

class DeleteQuestion extends AdminEvent {
  final String questionId;

  const DeleteQuestion({required this.questionId});

  @override
  List<Object> get props => [questionId];
}

// admin_state.dart
part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class QuestionsLoaded extends AdminState {
  final List<Question> questions;

  const QuestionsLoaded({required this.questions});

  @override
  List<Object> get props => [questions];
}

class QuestionAdded extends AdminState {
  final String message;

  const QuestionAdded({required this.message});

  @override
  List<Object> get props => [message];
}

class QuestionDeleted extends AdminState {
  final String message;

  const QuestionDeleted({required this.message});

  @override
  List<Object> get props => [message];
}

class AdminError extends AdminState {
  final String message;

  const AdminError({required this.message});

  @override
  List<Object> get props => [message];
}

// lib/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2332),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Ingresa tu nombre',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginRequested(username: _nameController.text),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/quiz/quiz_bloc.dart';
import '../widgets/module_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2332),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocBuilder<QuizBloc, QuizState>(
            builder: (context, quizState) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, authState),
                    const SizedBox(height: 32),
                    const Text(
                      'Selecciona un Módulo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _buildModulesGrid(context, quizState),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthState authState) {
    final username = authState is AuthSuccess ? authState.username : 'Usuario';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, $username!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'Curso: Admin',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
              ),
              child: const Text('Guía de Estudio'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
              ),
              child: const Text('Ver Ranking'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Admin'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModulesGrid(BuildContext context, QuizState state) {
    if (state is QuizLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state is ModulesLoaded) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: state.modules.length,
        itemBuilder: (context, index) {
          final module = state.modules[index];
          return ModuleCard(
            module: module,
            onTap: () {
              context.read<QuizBloc>().add(StartQuiz(moduleId: module.id));
              Navigator.pushNamed(context, '/quiz');
            },
          );
        },
      );
    }
    
    return const Center(
      child: Text(
        'Error al cargar los módulos',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}