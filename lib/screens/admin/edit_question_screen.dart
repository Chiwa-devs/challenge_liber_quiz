import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:challenge_liber_quiz/blocs/admin_bloc.dart';
import 'package:challenge_liber_quiz/blocs/admin_event.dart';
import 'package:challenge_liber_quiz/blocs/admin_state.dart';
import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';

class EditQuestionScreen extends StatefulWidget {
  final Question question;

  const EditQuestionScreen({super.key, required this.question});

  @override
  State<EditQuestionScreen> createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _option1Controller;
  late TextEditingController _option2Controller;
  late TextEditingController _option3Controller;
  late TextEditingController _option4Controller;

  String? _selectedModuleId;
  int? _correctOptionIndex;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.questionText);
    _option1Controller = TextEditingController(text: widget.question.options[0]);
    _option2Controller = TextEditingController(text: widget.question.options[1]);
    _option3Controller = TextEditingController(text: widget.question.options[2]);
    _option4Controller = TextEditingController(text: widget.question.options[3]);
    _selectedModuleId = widget.question.moduleId;
    _correctOptionIndex = widget.question.correctOptionIndex;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pregunta'),
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
                return _buildForm(context, state.modules);
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

  Widget _buildForm(BuildContext context, List<Module> modules) {
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Module selection
                const Text(
                  'Seleccionar Módulo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Elige un módulo',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona un módulo';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Question text
                const Text(
                  'Pregunta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: 'Escribe la pregunta aquí...',
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
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa la pregunta';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Options
                const Text(
                  'Opciones de Respuesta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                _buildOptionField('Opción 1', _option1Controller, 0),
                const SizedBox(height: 12),
                _buildOptionField('Opción 2', _option2Controller, 1),
                const SizedBox(height: 12),
                _buildOptionField('Opción 3', _option3Controller, 2),
                const SizedBox(height: 12),
                _buildOptionField('Opción 4', _option4Controller, 3),

                const SizedBox(height: 24),

                // Correct answer selection
                const Text(
                  'Respuesta Correcta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildCorrectOptionRadio(0, 'Opción 1'),
                    const SizedBox(width: 16),
                    _buildCorrectOptionRadio(1, 'Opción 2'),
                    const SizedBox(width: 16),
                    _buildCorrectOptionRadio(2, 'Opción 3'),
                    const SizedBox(width: 16),
                    _buildCorrectOptionRadio(3, 'Opción 4'),
                  ],
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BlocConsumer<AdminBloc, AdminState>(
                        listener: (context, state) {
                          if (state is QuestionAdded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pregunta actualizada exitosamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(context).pop();
                          } else if (state is AdminError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${state.message}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is AdminLoading;
                          final isFormValid = _formKey.currentState?.validate() == true &&
                              _selectedModuleId != null &&
                              _correctOptionIndex != null;

                          return ElevatedButton(
                            onPressed: isLoading || !isFormValid ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0175C2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Guardar Cambios',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(String label, TextEditingController controller, int index) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor ingresa esta opción';
        }
        return null;
      },
    );
  }

  Widget _buildCorrectOptionRadio(int value, String label) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _correctOptionIndex = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _correctOptionIndex == value
                ? const Color(0xFF0175C2).withValues(alpha: 0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _correctOptionIndex == value
                  ? const Color(0xFF0175C2)
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: _correctOptionIndex == value
                  ? const Color(0xFF0175C2)
                  : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedModuleId != null && _correctOptionIndex != null) {
      final options = [
        _option1Controller.text.trim(),
        _option2Controller.text.trim(),
        _option3Controller.text.trim(),
        _option4Controller.text.trim(),
      ];

      final updatedQuestion = widget.question.copyWith(
        moduleId: _selectedModuleId!,
        questionText: _questionController.text.trim(),
        options: options,
        correctOptionIndex: _correctOptionIndex!,
      );

      context.read<AdminBloc>().add(UpdateQuestion(updatedQuestion));
    }
  }
}
