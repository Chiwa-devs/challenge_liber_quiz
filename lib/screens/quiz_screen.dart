import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:challenge_liber_quiz/blocs/quiz_bloc.dart';
import 'package:challenge_liber_quiz/blocs/quiz_event.dart';
import 'package:challenge_liber_quiz/blocs/quiz_state.dart';
import 'package:challenge_liber_quiz/screens/quiz_completed_screen.dart';
import 'package:challenge_liber_quiz/models/question.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: BlocConsumer<QuizBloc, QuizState>(
            listener: (context, state) {
              if (state is QuizCompleted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => QuizCompletedScreen(
                      session: state.session,
                      totalQuestions: state.totalQuestions,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is QuizInProgress) {
                return Column(
                  children: [
                    // Header with progress and score
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Progress bar
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (state.session.currentQuestionIndex + 1) / state.session.questionIds.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pregunta ${state.session.currentQuestionIndex + 1} de ${state.session.questionIds.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Puntuación: ${state.session.score}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Question content
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: QuizQuestionWidget(
                          session: state.session,
                          question: state.currentQuestion,
                          showResult: state.showResult,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class QuizQuestionWidget extends StatefulWidget {
  final dynamic session; // QuizSession
  final Question question;
  final bool showResult;

  const QuizQuestionWidget({
    super.key,
    required this.session,
    required this.question,
    required this.showResult,
  });

  @override
  State<QuizQuestionWidget> createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget> {
  int? selectedOption;

  @override
  void didUpdateWidget(QuizQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      selectedOption = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.question.questionText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 32),

          // Answer options
          Expanded(
            child: ListView.builder(
              itemCount: widget.question.options.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AnswerOptionWidget(
                    option: widget.question.options[index],
                    optionIndex: index,
                    isSelected: selectedOption == index,
                    isCorrect: widget.showResult && index == widget.question.correctOptionIndex,
                    isIncorrect: widget.showResult && selectedOption == index && index != widget.question.correctOptionIndex,
                    isDisabled: widget.showResult,
                    onTap: widget.showResult ? null : () {
                      setState(() {
                        selectedOption = index;
                      });
                      context.read<QuizBloc>().add(AnswerQuestion(widget.question.id, index));
                    },
                  ),
                );
              },
            ),
          ),

          // Navigation buttons (only show if not showing result)
          if (!widget.showResult) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.session.currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<QuizBloc>().add(PreviousQuestion());
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF0175C2)),
                        foregroundColor: Color(0xFF0175C2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Anterior',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                if (widget.session.currentQuestionIndex > 0) const SizedBox(width: 16),
                Expanded(
                  flex: widget.session.currentQuestionIndex > 0 ? 1 : 1,
                  child: ElevatedButton(
                    onPressed: selectedOption == null ? null : () {
                      // Answer will be processed and next question will be shown automatically
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0175C2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Back to menu button (only show if showing result)
          if (widget.showResult) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.read<QuizBloc>().add(ResetQuiz());
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF0175C2)),
                  foregroundColor: Color(0xFF0175C2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Volver al Menú',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AnswerOptionWidget extends StatelessWidget {
  final String option;
  final int optionIndex;
  final bool isSelected;
  final bool isCorrect;
  final bool isIncorrect;
  final bool isDisabled;
  final VoidCallback? onTap;

  const AnswerOptionWidget({
    super.key,
    required this.option,
    required this.optionIndex,
    required this.isSelected,
    required this.isCorrect,
    required this.isIncorrect,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Colors.black87;

    if (isCorrect) {
      backgroundColor = Colors.green[50]!;
      borderColor = Colors.green;
      textColor = Colors.green[800]!;
    } else if (isIncorrect) {
      backgroundColor = Colors.red[50]!;
      borderColor = Colors.red;
      textColor = Colors.red[800]!;
    } else if (isSelected) {
      backgroundColor = const Color(0xFF0175C2).withValues(alpha: 0.1);
      borderColor = const Color(0xFF0175C2);
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected || isCorrect || isIncorrect ? borderColor : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: (isSelected || isCorrect || isIncorrect) ? borderColor.withValues(alpha: 0.1) : Colors.transparent,
                  ),
                  child: (isSelected || isCorrect || isIncorrect)
                      ? Center(
                          child: Icon(
                            isCorrect ? Icons.check : (isIncorrect ? Icons.close : Icons.circle),
                            size: 14,
                            color: borderColor,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: isSelected || isCorrect || isIncorrect ? FontWeight.w500 : FontWeight.normal,
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
}
