import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:challenge_liber_quiz/blocs/admin_bloc.dart';
import 'package:challenge_liber_quiz/blocs/admin_event.dart';
import 'package:challenge_liber_quiz/blocs/admin_state.dart';
import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';
import 'package:challenge_liber_quiz/screens/admin/edit_question_screen.dart';

class ManageQuestionsScreen extends StatefulWidget {
  const ManageQuestionsScreen({super.key});

  @override
  State<ManageQuestionsScreen> createState() => _ManageQuestionsScreenState();
}

class _ManageQuestionsScreenState extends State<ManageQuestionsScreen> {
  String? _selectedModuleId;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadAdminData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Preguntas'),
        backgroundColor: const Color(0xFF0175C2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0175C2),
              Color(0xFF005A9F),
            ],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<AdminBloc, AdminState>(
            builder: (context, state) {
              if (state is AdminLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else if (state is AdminDataLoaded) {
                return _buildContent(context, state.modules, state.questions);
              } else if (state is AdminError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdminBloc>().add(LoadAdminData());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0175C2),
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'Estado desconocido',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Module> modules, List<Question> questions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Module selection
              const Text(
                'Seleccionar Módulo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Elige un módulo para ver sus preguntas',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF0175C2), width: 2),
                  ),
                ),
                items: modules.map((module) {
                  return DropdownMenuItem(
                    value: module.id,
                    child: Text('${module.icon} ${module.name}'),
                  );
                }).toList(),
                initialValue: _selectedModuleId,
                onChanged: (value) {
                  setState(() {
                    _selectedModuleId = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Questions list
              if (_selectedModuleId != null) ...[
                Text(
                  'Preguntas del módulo seleccionado',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildQuestionsList(context, questions),
              ] else
                const Center(
                  child: Text(
                    'Selecciona un módulo para ver sus preguntas',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionsList(BuildContext context, List<Question> allQuestions) {
    final moduleQuestions = allQuestions
        .where((question) => question.moduleId == _selectedModuleId)
        .toList();

    if (moduleQuestions.isEmpty) {
      return const Center(
        child: Text(
          'No hay preguntas en este módulo',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: moduleQuestions.length,
      itemBuilder: (context, index) {
        final question = moduleQuestions[index];
        return _QuestionCard(
          question: question,
          onEdit: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditQuestionScreen(question: question),
              ),
            );
          },
          onDelete: () {
            _showDeleteConfirmationDialog(context, question);
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Question question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Eliminar Pregunta'),
          content: Text(
            '¿Estás seguro de que quieres eliminar esta pregunta?\n\n"${question.questionText}"',
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AdminBloc>().add(DeleteQuestion(question.id));
              },
            ),
          ],
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question question;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QuestionCard({
    required this.question,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF0175C2),
                      ),
                      tooltip: 'Editar pregunta',
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      tooltip: 'Eliminar pregunta',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isCorrect = index == question.correctOptionIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCorrect
                        ? Colors.green
                        : Colors.grey[300]!,
                    width: isCorrect ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 20,
                      color: isCorrect ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isCorrect ? Colors.green : Colors.black87,
                          fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
