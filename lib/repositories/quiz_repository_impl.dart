import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';
import 'package:challenge_liber_quiz/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  // Datos de prueba - en una implementación real esto vendría de una base de datos
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
    // Fundamentos y Prompting (5 preguntas)
    const Question(
      id: '1',
      moduleId: '1',
      questionText: '¿Cuál es el propósito principal del prompting en el desarrollo con IA?',
      options: [
        'Escribir código más rápido',
        'Comunicar efectivamente con modelos de IA',
        'Debuggear errores automáticamente',
        'Crear interfaces gráficas'
      ],
      correctOptionIndex: 1,
      explanation: 'El prompting efectivo permite comunicarse claramente con modelos de IA para obtener mejores resultados.',
    ),
    const Question(
      id: '2',
      moduleId: '1',
      questionText: '¿Qué elemento NO es parte de un buen prompt?',
      options: [
        'Contexto claro',
        'Instrucciones específicas',
        'Código fuente completo',
        'Ejemplos de salida esperada'
      ],
      correctOptionIndex: 2,
      explanation: 'Un buen prompt debe ser conciso. Incluir código fuente completo puede confundir al modelo.',
    ),
    const Question(
      id: '3',
      moduleId: '1',
      questionText: '¿Cuál es la mejor práctica para estructurar un prompt complejo?',
      options: [
        'Escribirlo todo en una sola línea',
        'Dividirlo en secciones con encabezados claros',
        'Usar tantos detalles técnicos como sea posible',
        'Incluir siempre el historial completo de la conversación'
      ],
      correctOptionIndex: 1,
      explanation: 'Dividir el prompt en secciones ayuda al modelo a entender mejor la estructura y responder de manera más organizada.',
    ),
    const Question(
      id: '4',
      moduleId: '1',
      questionText: '¿Qué tipo de información es más útil incluir en un prompt para obtener código específico?',
      options: [
        'Solo el lenguaje de programación',
        'El contexto del problema y ejemplos de entrada/salida',
        'La biografía del desarrollador',
        'El historial de versiones del proyecto'
      ],
      correctOptionIndex: 1,
      explanation: 'Proporcionar contexto del problema y ejemplos ayuda al modelo a generar código más preciso y útil.',
    ),
    const Question(
      id: '5',
      moduleId: '1',
      questionText: '¿Por qué es importante ser específico en los prompts?',
      options: [
        'Para confundir al modelo',
        'Para obtener respuestas más precisas y útiles',
        'Para hacer el prompt más largo',
        'Para incluir más palabras clave'
      ],
      correctOptionIndex: 1,
      explanation: 'La especificidad ayuda al modelo a entender exactamente lo que necesitas, generando respuestas más precisas.',
    ),

    // Estructuras de Datos (5 preguntas)
    const Question(
      id: '6',
      moduleId: '2',
      questionText: '¿Cuál es la diferencia principal entre una Lista y un Map en Dart?',
      options: [
        'La Lista almacena pares clave-valor, el Map almacena elementos ordenados',
        'La Lista almacena elementos ordenados por índice, el Map por claves',
        'No hay diferencia, son lo mismo',
        'La Lista es inmutable, el Map es mutable'
      ],
      correctOptionIndex: 1,
      explanation: 'Las listas almacenan elementos ordenados por índice, mientras que los mapas almacenan datos como pares clave-valor.',
    ),
    const Question(
      id: '7',
      moduleId: '2',
      questionText: '¿Cuál es la complejidad temporal de acceso a un elemento en un Array?',
      options: [
        'O(1)',
        'O(n)',
        'O(log n)',
        'O(n²)'
      ],
      correctOptionIndex: 0,
      explanation: 'El acceso a un elemento por índice en un array tiene complejidad O(1) - tiempo constante.',
    ),
    const Question(
      id: '8',
      moduleId: '2',
      questionText: '¿Qué estructura de datos es más eficiente para búsquedas frecuentes?',
      options: [
        'Lista enlazada',
        'Array',
        'HashMap',
        'Pila'
      ],
      correctOptionIndex: 2,
      explanation: 'Los HashMap ofrecen búsquedas en tiempo constante O(1) en promedio.',
    ),
    const Question(
      id: '9',
      moduleId: '2',
      questionText: '¿Cuál es la principal ventaja de una lista enlazada sobre un array?',
      options: [
        'Acceso más rápido por índice',
        'Inserción/eliminación eficiente en medio',
        'Menor uso de memoria',
        'Búsqueda más rápida'
      ],
      correctOptionIndex: 1,
      explanation: 'Las listas enlazadas permiten inserciones y eliminaciones eficientes en cualquier posición.',
    ),
    const Question(
      id: '10',
      moduleId: '2',
      questionText: '¿Qué algoritmo de búsqueda es más eficiente para arrays ordenados?',
      options: [
        'Búsqueda lineal',
        'Búsqueda binaria',
        'Búsqueda hash',
        'Búsqueda exponencial'
      ],
      correctOptionIndex: 1,
      explanation: 'La búsqueda binaria tiene complejidad O(log n) para arrays ordenados.',
    ),

    // Algoritmos de Ordenamiento (4 preguntas)
    const Question(
      id: '11',
      moduleId: '3',
      questionText: '¿Qué algoritmo de ordenamiento tiene mejor rendimiento promedio?',
      options: [
        'Bubble Sort',
        'Insertion Sort',
        'Quick Sort',
        'Selection Sort'
      ],
      correctOptionIndex: 2,
      explanation: 'Quick Sort tiene un rendimiento promedio de O(n log n), mejor que los otros algoritmos mencionados.',
    ),
    const Question(
      id: '12',
      moduleId: '3',
      questionText: '¿Cuál es el peor caso de Quick Sort?',
      options: [
        'O(n log n)',
        'O(n²)',
        'O(n)',
        'O(2^n)'
      ],
      correctOptionIndex: 1,
      explanation: 'Quick Sort tiene peor caso O(n²) cuando el pivote está mal elegido (array ya ordenado).',
    ),
    const Question(
      id: '13',
      moduleId: '3',
      questionText: '¿Qué algoritmo es estable y eficiente para listas pequeñas?',
      options: [
        'Merge Sort',
        'Insertion Sort',
        'Heap Sort',
        'Radix Sort'
      ],
      correctOptionIndex: 1,
      explanation: 'Insertion Sort es estable y muy eficiente para listas pequeñas o casi ordenadas.',
    ),
    const Question(
      id: '14',
      moduleId: '3',
      questionText: '¿Cuál algoritmo NO es un algoritmo de ordenamiento por comparación?',
      options: [
        'Quick Sort',
        'Merge Sort',
        'Counting Sort',
        'Heap Sort'
      ],
      correctOptionIndex: 2,
      explanation: 'Counting Sort no compara elementos directamente, cuenta ocurrencias para ordenar.',
    ),

    // Programación Orientada a Objetos (4 preguntas)
    const Question(
      id: '15',
      moduleId: '4',
      questionText: '¿Cuál es el pilar principal de la Programación Orientada a Objetos?',
      options: [
        'Herencia',
        'Abstracción',
        'Polimorfismo',
        'Encapsulamiento'
      ],
      correctOptionIndex: 1,
      explanation: 'La abstracción es el pilar fundamental que permite modelar objetos del mundo real en código.',
    ),
    const Question(
      id: '16',
      moduleId: '4',
      questionText: '¿Qué permite el polimorfismo en POO?',
      options: [
        'Crear múltiples clases',
        'Ocultar información',
        'Tratar objetos de diferentes tipos de manera uniforme',
        'Reutilizar código'
      ],
      correctOptionIndex: 2,
      explanation: 'El polimorfismo permite tratar objetos de diferentes clases de manera uniforme a través de interfaces comunes.',
    ),
    const Question(
      id: '17',
      moduleId: '4',
      questionText: '¿Cuál es la diferencia entre composición y herencia?',
      options: [
        'No hay diferencia',
        'La composición es "tiene-un", la herencia es "es-un"',
        'La composición es más lenta',
        'La herencia es más flexible'
      ],
      correctOptionIndex: 1,
      explanation: 'La composición representa relaciones "tiene-un", mientras que la herencia representa relaciones "es-un".',
    ),
    const Question(
      id: '18',
      moduleId: '4',
      questionText: '¿Qué beneficio principal ofrece el encapsulamiento?',
      options: [
        'Mejor rendimiento',
        'Ocultar la implementación interna',
        'Facilitar la herencia',
        'Permitir múltiples instancias'
      ],
      correctOptionIndex: 1,
      explanation: 'El encapsulamiento oculta la implementación interna y expone solo lo necesario mediante interfaces públicas.',
    ),

    // Bases de Datos (4 preguntas)
    const Question(
      id: '19',
      moduleId: '5',
      questionText: '¿Cuál es la función principal de una clave primaria?',
      options: [
        'Ordenar los datos',
        'Identificar de manera única cada fila',
        'Mejorar el rendimiento de consultas',
        'Crear relaciones entre tablas'
      ],
      correctOptionIndex: 1,
      explanation: 'La clave primaria identifica de manera única cada fila en una tabla de la base de datos.',
    ),
    const Question(
      id: '20',
      moduleId: '5',
      questionText: '¿Qué tipo de relación representa una cardinalidad muchos-a-muchos?',
      options: [
        'Una tabla con una clave foránea',
        'Dos tablas con claves foráneas',
        'Una tabla intermedia con claves foráneas',
        'Una tabla con clave primaria compuesta'
      ],
      correctOptionIndex: 2,
      explanation: 'Las relaciones muchos-a-muchos requieren una tabla intermedia que contenga las claves foráneas de ambas tablas.',
    ),
    const Question(
      id: '21',
      moduleId: '5',
      questionText: '¿Cuál comando SQL se usa para obtener datos de una tabla?',
      options: [
        'INSERT',
        'UPDATE',
        'SELECT',
        'DELETE'
      ],
      correctOptionIndex: 2,
      explanation: 'El comando SELECT se utiliza para recuperar datos de una o más tablas en la base de datos.',
    ),
    const Question(
      id: '22',
      moduleId: '5',
      questionText: '¿Qué es la normalización en bases de datos?',
      options: [
        'Eliminar datos duplicados',
        'Mejorar el rendimiento',
        'Proceso de organizar datos para reducir redundancia',
        'Crear índices automáticamente'
      ],
      correctOptionIndex: 2,
      explanation: 'La normalización es el proceso de organizar los datos en una base de datos para reducir la redundancia y mejorar la integridad.',
    ),
  ];

  @override
  Future<List<Module>> getModules() async {
    await _simulateDelay();
    return _modules;
  }

  @override
  Future<Module> getModuleById(String id) async {
    await _simulateDelay();
    return _modules.firstWhere((module) => module.id == id);
  }

  @override
  Future<List<Question>> getQuestionsByModule(String moduleId) async {
    await _simulateDelay();
    return _questions.where((question) => question.moduleId == moduleId).toList();
  }

  @override
  Future<Question> getQuestionById(String id) async {
    await _simulateDelay();
    return _questions.firstWhere((question) => question.id == id);
  }

  @override
  Future<List<Question>> getAllQuestions() async {
    await _simulateDelay();
    return _questions;
  }

  @override
  Future<void> addQuestion(Question question) async {
    await _simulateDelay();
    // In a real implementation, this would save to a database
    _questions.add(question);
  }

  @override
  Future<void> updateQuestion(Question question) async {
    await _simulateDelay();
    // In a real implementation, this would update in a database
    final index = _questions.indexWhere((q) => q.id == question.id);
    if (index != -1) {
      _questions[index] = question;
    }
  }

  @override
  Future<void> deleteQuestion(String questionId) async {
    await _simulateDelay();
    // In a real implementation, this would delete from a database
    _questions.removeWhere((question) => question.id == questionId);
  }

  Future<void> _simulateDelay() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
