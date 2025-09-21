// lib/presentation/widgets/module_card.dart
import 'package:flutter/material.dart';
import '../../data/models/module.dart';

class ModuleCard extends StatelessWidget {
  final QuizModule module;
  final VoidCallback onTap;

  const ModuleCard({
    Key? key,
    required this.module,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2A3441),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                module.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 12),
              Text(
                module.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${module.questionCount} preguntas',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/presentation/pages/quiz_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quiz/quiz_bloc.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2332),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizCompleted) {
            _showCompletionDialog(context, state.session);
          }
        },
        builder: (context, state) {
          if (state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is QuizInProgress || state is QuestionAnswered) {
            final session = state is QuizInProgress 
                ? state.session 
                : (state as QuestionAnswered).session;
            final currentQuestion = session.currentQuestion;
            
            if (currentQuestion == null) {
              return const Center(
                child: Text(
                  'Error al cargar la pregunta',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            
            return _buildQuizContent(context, session, currentQuestion, state);
          }
          
          return const Center(
            child: Text(
              'Error al cargar el quiz',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, session, currentQuestion, QuizState state) {
    final isAnswered = state is QuestionAnswered;
    final selectedIndex = isAnswered ? state.selectedAnswerIndex : -1;
    final isCorrect = isAnswered ? state.isCorrect : false;
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(session),
            const SizedBox(height: 32),
            _buildProgressBar(session),
            const SizedBox(height: 32),
            _buildQuestion(currentQuestion.questionText),
            const SizedBox(height: 32),
            Expanded(
              child: _buildOptions(
                context, 
                currentQuestion.options, 
                selectedIndex, 
                currentQuestion.correctAnswerIndex,
                isAnswered,
              ),
            ),
            const SizedBox(height: 32),
            _buildBottomButtons(context, isAnswered),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(session) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.moduleName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            Text(
              'Pregunta ${session.currentQuestionIndex + 1} de ${session.questions.length}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Puntaje: ${session.score}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(session) {
    final progress = (session.currentQuestionIndex + 1) / session.questions.length;
    
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey[700],
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
      minHeight: 8,
    );
  }

  Widget _buildQuestion(String questionText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3441),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        questionText,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOptions(BuildContext context, List<String> options, int selectedIndex, 
                      int correctIndex, bool isAnswered) {
    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        
        Color? backgroundColor;
        Color textColor = Colors.white;
        
        if (isAnswered) {
          if (index == correctIndex) {
            backgroundColor = Colors.green;
            textColor = Colors.white;
          } else if (index == selectedIndex && index != correctIndex) {
            backgroundColor = Colors.red;
            textColor = Colors.white;
          }
        }
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAnswered ? null : () {
                context.read<QuizBloc>().add(
                  AnswerQuestion(selectedAnswerIndex: index),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? const Color(0xFF2A3441),
                foregroundColor: textColor,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                option,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButtons(BuildContext context, bool isAnswered) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Volver al Menú'),
        ),
        if (isAnswered)
          ElevatedButton(
            onPressed: () {
              context.read<QuizBloc>().add(NextQuestion());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Siguiente',
              style: TextStyle(color: Colors.black),
            ),
          ),
      ],
    );
  }

  void _showCompletionDialog(BuildContext context, session) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final percentage = (session.score / session.questions.length * 100).round();
        
        return AlertDialog(
          backgroundColor: const Color(0xFF2A3441),
          title: const Text(
            '¡Quiz Completado!',
            style: TextStyle(color: Colors.cyan),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Has completado el módulo: ${session.moduleName}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Puntuación: ${session.score}/${session.questions.length} ($percentage%)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                context.read<QuizBloc>().add(ResetQuiz());
              },
              child: const Text(
                'Volver al Menú',
                style: TextStyle(color: Colors.cyan),
              ),
            ),
          ],
        );
      },
    );
  }
}

// lib/presentation/pages/admin_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin/admin_bloc.dart';
import '../../data/models/models.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A2332),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2A3441),
          title: const Text('Administración'),
          bottom: const TabBar(
            indicatorColor: Colors.cyan,
            labelColor: Colors.cyan,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Añadir Pregunta'),
              Tab(text: 'Eliminar Preguntas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddQuestionTab(),
            DeleteQuestionTab(),
          ],
        ),
      ),
    );
  }
}

class AddQuestionTab extends StatefulWidget {
  const AddQuestionTab({Key? key}) : super(key: key);

  @override
  State<AddQuestionTab> createState() => _AddQuestionTabState();
}

class _AddQuestionTabState extends State<AddQuestionTab> {
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  
  String _selectedModule = '1';
  int _correctAnswerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is QuestionAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          _clearForm();
        } else if (state is AdminError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Nota: Las preguntas que añadas o elimines aquí se guardarán solo para esta sesión.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            _buildModuleDropdown(),
            const SizedBox(height: 16),
            _buildQuestionField(),
            const SizedBox(height: 16),
            _buildOptionsFields(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Módulo',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedModule,
          dropdownColor: const Color(0xFF2A3441),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
          ),
          items: const [
            DropdownMenuItem(value: '1', child: Text('Fundamentos y Prompting')),
            DropdownMenuItem(value: '2', child: Text('Análisis y Síntesis de Datos')),
            DropdownMenuItem(value: '3', child: Text('IA como Copiloto de Marketing')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedModule = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildQuestionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pregunta',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _questionController,
          style: const TextStyle(color: Colors.white),
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Escribe la pregunta...',
            hintStyle: TextStyle(color: Colors.white54),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opciones de Respuesta',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...[
          _option1Controller,
          _option2Controller,
          _option3Controller,
          _option4Controller,
        ].asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Radio<int>(
                  value: index,
                  groupValue: _correctAnswerIndex,
                  activeColor: Colors.cyan,
                  onChanged: (value) {
                    setState(() {
                      _correctAnswerIndex = value!;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Opción ${index + 1}',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Guardar Pregunta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _saveQuestion() {
    final question = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      moduleId: _selectedModule,
      questionText: _questionController.text,
      options: [
        _option1Controller.text,
        _option2Controller.text,
        _option3Controller.text,
        _option4Controller.text,
      ],
      correctAnswerIndex: _correctAnswerIndex,
    );

    context.read<AdminBloc>().add(AddQuestion(question: question));
  }

  void _clearForm() {
    _questionController.clear();
    _option1Controller.clear();
    _option2Controller.clear();
    _option3Controller.clear();
    _option4Controller.clear();
    setState(() {
      _correctAnswerIndex = 0;
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    super.dispose();
  }
}

class DeleteQuestionTab extends StatefulWidget {
  const DeleteQuestionTab({Key? key}) : super(key: key);

  @override
  State<DeleteQuestionTab> createState() => _DeleteQuestionTabState();
}

class _DeleteQuestionTabState extends State<DeleteQuestionTab> {
  String _selectedModule = '1';

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadQuestionsForModule(moduleId: _selectedModule));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is QuestionDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<AdminBloc>().add(LoadQuestionsForModule(moduleId: _selectedModule));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModuleDropdown(),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  if (state is AdminLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is QuestionsLoaded) {
                    return _buildQuestionsList(state.questions);
                  }
                  
                  return const Center(
                    child: Text(
                      'Selecciona un módulo para ver las preguntas',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedModule,
      dropdownColor: const Color(0xFF2A3441),
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Selecciona un Módulo',
        labelStyle: TextStyle(color: Colors.cyan),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
      ),
      items: const [
        DropdownMenuItem(value: '1', child: Text('Fundamentos y Prompting')),
        DropdownMenuItem(value: '2', child: Text('Análisis y Síntesis de Datos')),
        DropdownMenuItem(value: '3', child: Text('IA como Copiloto de Marketing')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedModule = value!;
        });
        context.read<AdminBloc>().add(LoadQuestionsForModule(moduleId: value!));
      },
    );
  }

  Widget _buildQuestionsList(List<Question> questions) {
    if (questions.isEmpty) {
      return const Center(
        child: Text(
          'No hay preguntas en este módulo',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Card(
          color: const Color(0xFF2A3441),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              question.questionText,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(context, question),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Question question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A3441),
          title: const Text(
            'Confirmar Eliminación',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            '¿Estás seguro de que quieres eliminar esta pregunta?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AdminBloc>().add(DeleteQuestion(questionId: question.id));
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}