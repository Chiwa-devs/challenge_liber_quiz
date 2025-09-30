import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';

/// Simple in-memory implementation for web (sqflite unsupported on web).
class DatabaseService {
  final List<Module> _modules = [
    const Module(
      id: '1',
      name: 'Fundamentos y Prompting',
      description: 'Conceptos básicos de programación y prompting efectivo',
      icon: '🧠',
      questionCount: 5,
    ),
    const Module(
      id: '2',
      name: 'Estructuras de Datos',
      description: 'Arrays, listas, mapas y algoritmos básicos',
      icon: '📊',
      questionCount: 5,
    ),
    const Module(
      id: '3',
      name: 'Algoritmos de Ordenamiento',
      description: 'Diferentes algoritmos de ordenamiento y su eficiencia',
      icon: '🔢',
      questionCount: 4,
    ),
    const Module(
      id: '4',
      name: 'Programación Orientada a Objetos',
      description: 'Conceptos fundamentales de POO',
      icon: '🏗️',
      questionCount: 4,
    ),
    const Module(
      id: '5',
      name: 'Bases de Datos',
      description: 'Conceptos básicos de bases de datos y SQL',
      icon: '💾',
      questionCount: 4,
    ),
  ];

  final List<Question> _questions = [
    Question(
      id: '1',
      moduleId: '1',
      questionText: '¿Cuál es el propósito principal del prompting en el desarrollo con IA?',
      options: ['Escribir código más rápido', 'Comunicar efectivamente con modelos de IA', 'Debuggear errores automáticamente', 'Crear interfaces gráficas'],
      correctOptionIndex: 1,
      explanation: 'El prompting efectivo permite comunicarse claramente con modelos de IA para obtener mejores resultados.',
    ),
    Question(
      id: '2',
      moduleId: '1',
      questionText: '¿Qué elemento NO es parte de un buen prompt?',
      options: ['Contexto claro', 'Instrucciones específicas', 'Código fuente completo', 'Ejemplos de salida esperada'],
      correctOptionIndex: 2,
      explanation: 'Un buen prompt debe ser conciso. Incluir código fuente completo puede confundir al modelo.',
    ),
    Question(
      id: '3',
      moduleId: '1',
      questionText: '¿Cuál es la mejor práctica para estructurar un prompt complejo?',
      options: ['Escribirlo todo en una sola línea', 'Dividirlo en secciones con encabezados claros', 'Usar tantos detalles técnicos como sea posible', 'Incluir siempre el historial completo de la conversación'],
      correctOptionIndex: 1,
      explanation: 'Dividir el prompt en secciones ayuda al modelo a entender mejor la estructura y responder de manera más organizada.',
    ),
    Question(
      id: '4',
      moduleId: '1',
      questionText: '¿Qué tipo de información es más útil incluir en un prompt para obtener código específico?',
      options: ['Solo el lenguaje de programación', 'El contexto del problema y ejemplos de entrada/salida', 'La biografía del desarrollador', 'El historial de versiones del proyecto'],
      correctOptionIndex: 1,
      explanation: 'Proporcionar contexto del problema y ejemplos ayuda al modelo a generar código más preciso y útil.',
    ),
    Question(
      id: '5',
      moduleId: '1',
      questionText: '¿Por qué es importante ser específico en los prompts?',
      options: ['Para confundir al modelo', 'Para obtener respuestas más precisas y útiles', 'Para hacer el prompt más largo', 'Para incluir más palabras clave'],
      correctOptionIndex: 1,
      explanation: 'La especificidad ayuda al modelo a entender exactamente lo que necesitas, generando respuestas más precisas.',
    ),
  ];

  Future<List<Module>> getModules() async => List<Module>.from(_modules);

  Future<Module> getModuleById(String id) async => _modules.firstWhere((m) => m.id == id);

  Future<List<Question>> getQuestionsByModule(String moduleId) async => _questions.where((q) => q.moduleId == moduleId).toList();

  Future<Question> getQuestionById(String id) async => _questions.firstWhere((q) => q.id == id);

  Future<List<Question>> getAllQuestions() async => List<Question>.from(_questions);

  Future<void> addQuestion(Question question) async {
    _questions.add(question);
    final module = _modules.firstWhere((m) => m.id == question.moduleId);
    final updated = Module(
      id: module.id,
      name: module.name,
      description: module.description,
      icon: module.icon,
      questionCount: module.questionCount + 1,
    );
    _modules[_modules.indexWhere((m) => m.id == module.id)] = updated;
  }

  Future<void> updateQuestion(Question question) async {
    final idx = _questions.indexWhere((q) => q.id == question.id);
    if (idx >= 0) _questions[idx] = question;
  }

  Future<void> deleteQuestion(String questionId) async {
    final q = _questions.firstWhere((x) => x.id == questionId);
    _questions.removeWhere((x) => x.id == questionId);
    final module = _modules.firstWhere((m) => m.id == q.moduleId);
    final updated = Module(
      id: module.id,
      name: module.name,
      description: module.description,
      icon: module.icon,
      questionCount: module.questionCount - 1,
    );
    _modules[_modules.indexWhere((m) => m.id == module.id)] = updated;
  }

  Future<void> clearDatabase() async {
    // reset to defaults
  }
}
