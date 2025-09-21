// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/quiz/quiz_bloc.dart';
import 'presentation/bloc/admin/admin_bloc.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/quiz_page.dart';
import 'presentation/pages/admin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => QuizBloc()..add(LoadModules())),
        BlocProvider(create: (context) => AdminBloc()),
      ],
      child: MaterialApp(
        title: 'Quiz App',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/quiz': (context) => const QuizPage(),
          '/admin': (context) => const AdminPage(),
        },
      ),
    );
  }
}

// pubspec.yaml
/*
name: quiz_app
description: A Flutter quiz application for interview preparation.

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=2.19.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
*/

// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Quiz App';
  static const String courseCode = 'G2EZTE';
  
  // Colors
  static const int primaryDark = 0xFF1A2332;
  static const int secondaryDark = 0xFF2A3441;
  static const int accentCyan = 0xFF00BCD4;
  
  // Quiz Constants
  static const int maxQuestionsPerModule = 20;
  static const int passingScore = 70; // percentage
}

// lib/core/utils/validators.dart
class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }
  
  static String? validateQuestion(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La pregunta es requerida';
    }
    if (value.trim().length < 10) {
      return 'La pregunta debe tener al menos 10 caracteres';
    }
    return null;
  }
  
  static String? validateOption(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La opción es requerida';
    }
    if (value.trim().length < 2) {
      return 'La opción debe tener al menos 2 caracteres';
    }
    return null;
  }
}

// lib/data/repositories/quiz_repository.dart
import '../models/models.dart';

abstract class QuizRepository {
  Future<List<QuizModule>> getModules();
  Future<List<Question>> getQuestionsByModule(String moduleId);
  Future<void> addQuestion(Question question);
  Future<void> deleteQuestion(String questionId);
}

class MockQuizRepository implements QuizRepository {
  // Storage para la sesión actual
  static final Map<String, List<Question>> _sessionQuestions = {};
  
  @override
  Future<List<QuizModule>> getModules() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
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
  }

  @override
  Future<List<Question>> getQuestionsByModule(String moduleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Si hay preguntas en la sesión, las devolvemos
    if (_sessionQuestions.containsKey(moduleId)) {
      return _sessionQuestions[moduleId]!;
    }
    
    // Preguntas por defecto
    final defaultQuestions = _getDefaultQuestions(moduleId);
    _sessionQuestions[moduleId] = defaultQuestions;
    
    return defaultQuestions;
  }

  @override
  Future<void> addQuestion(Question question) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (!_sessionQuestions.containsKey(question.moduleId)) {
      _sessionQuestions[question.moduleId] = [];
    }
    
    _sessionQuestions[question.moduleId]!.add(question);
  }

  @override
  Future<void> deleteQuestion(String questionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    for (final moduleQuestions in _sessionQuestions.values) {
      moduleQuestions.removeWhere((q) => q.id == questionId);
    }
  }

  List<Question> _getDefaultQuestions(String moduleId) {
    switch (moduleId) {
      case '1': // Fundamentos y Prompting
        return [
          Question(
            id: '1_1',
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
            id: '1_2',
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
          Question(
            id: '1_3',
            moduleId: moduleId,
            questionText: '¿Qué elemento es fundamental en un prompt bien estructurado?',
            options: [
              'Extensión mínima de 100 palabras',
              'Contexto y objetivo claro',
              'Uso de jerga técnica',
              'Formato en mayúsculas'
            ],
            correctAnswerIndex: 1,
          ),
        ];
      
      case '2': // Análisis y Síntesis de Datos
        return [
          Question(
            id: '2_1',
            moduleId: moduleId,
            questionText: '¿Cuál es el primer paso en el análisis de datos con IA?',
            options: [
              'Crear visualizaciones',
              'Definir objetivos claros',
              'Ejecutar algoritmos',
              'Presentar resultados'
            ],
            correctAnswerIndex: 1,
          ),
          Question(
            id: '2_2',
            moduleId: moduleId,
            questionText: '¿Qué tipo de datos es más útil para entrenar modelos de IA?',
            options: [
              'Datos incompletos',
              'Datos limpios y estructurados',
              'Datos muy antiguos',
              'Datos sin etiquetar'
            ],
            correctAnswerIndex: 1,
          ),
        ];
      
      default:
        return [
          Question(
            id: '${moduleId}_1',
            moduleId: moduleId,
            questionText: 'Pregunta de ejemplo para el módulo',
            options: [
              'Opción A',
              'Opción B correcta',
              'Opción C',
              'Opción D'
            ],
            correctAnswerIndex: 1,
          ),
        ];
    }
  }
  
  // Método para limpiar la sesión (útil para testing)
  static void clearSession() {
    _sessionQuestions.clear();
  }
}

// lib/presentation/widgets/responsive_layout.dart
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 768) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}