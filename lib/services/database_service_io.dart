import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:challenge_liber_quiz/models/module.dart';
import 'package:challenge_liber_quiz/models/question.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'quiz_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Crear tabla de módulos
        await db.execute('''
          CREATE TABLE modules (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            icon TEXT NOT NULL,
            questionCount INTEGER NOT NULL
          )
        ''');

        // Crear tabla de preguntas
        await db.execute('''
          CREATE TABLE questions (
            id TEXT PRIMARY KEY,
            moduleId TEXT NOT NULL,
            questionText TEXT NOT NULL,
            options TEXT NOT NULL,
            correctOptionIndex INTEGER NOT NULL,
            explanation TEXT,
            FOREIGN KEY (moduleId) REFERENCES modules (id) ON DELETE CASCADE
          )
        ''');

        // Insertar datos iniciales
        await _insertInitialData(db);
      },
    );
  }

  Future<void> _insertInitialData(Database db) async {
    final modules = [
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

    for (var module in modules) {
      await db.insert('modules', {
        'id': module.id,
        'name': module.name,
        'description': module.description,
        'icon': module.icon,
        'questionCount': module.questionCount,
      });
    }

    final questions = [
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

    for (var question in questions) {
      await db.insert('questions', {
        'id': question.id,
        'moduleId': question.moduleId,
        'questionText': question.questionText,
        'options': question.options.join(','),
        'correctOptionIndex': question.correctOptionIndex,
        'explanation': question.explanation ?? '',
      });
    }
  }

  // Métodos para módulos
  Future<List<Module>> getModules() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('modules');
    return List.generate(maps.length, (i) {
      return Module(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        icon: maps[i]['icon'],
        questionCount: maps[i]['questionCount'],
      );
    });
  }

  Future<Module> getModuleById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'modules',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Module(
      id: maps[0]['id'],
      name: maps[0]['name'],
      description: maps[0]['description'],
      icon: maps[0]['icon'],
      questionCount: maps[0]['questionCount'],
    );
  }

  Future<void> updateModuleQuestionCount(String moduleId, int newCount) async {
    final db = await database;
    await db.update(
      'modules',
      {'questionCount': newCount},
      where: 'id = ?',
      whereArgs: [moduleId],
    );
  }

  // Métodos para preguntas
  Future<List<Question>> getQuestionsByModule(String moduleId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'questions',
      where: 'moduleId = ?',
      whereArgs: [moduleId],
    );

    return List.generate(maps.length, (i) {
      return Question.fromStringOptions(
        id: maps[i]['id'],
        moduleId: maps[i]['moduleId'],
        questionText: maps[i]['questionText'],
        optionsString: maps[i]['options'],
        correctOptionIndex: maps[i]['correctOptionIndex'],
        explanation: maps[i]['explanation'].isEmpty ? null : maps[i]['explanation'],
      );
    });
  }

  Future<Question> getQuestionById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'questions',
      where: 'id = ?',
      whereArgs: [id],
    );

    return Question.fromStringOptions(
      id: maps[0]['id'],
      moduleId: maps[0]['moduleId'],
      questionText: maps[0]['questionText'],
      optionsString: maps[0]['options'],
      correctOptionIndex: maps[0]['correctOptionIndex'],
      explanation: maps[0]['explanation'].isEmpty ? null : maps[0]['explanation'],
    );
  }

  Future<List<Question>> getAllQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');

    return List.generate(maps.length, (i) {
      return Question.fromStringOptions(
        id: maps[i]['id'],
        moduleId: maps[i]['moduleId'],
        questionText: maps[i]['questionText'],
        optionsString: maps[i]['options'],
        correctOptionIndex: maps[i]['correctOptionIndex'],
        explanation: maps[i]['explanation'].isEmpty ? null : maps[i]['explanation'],
      );
    });
  }

  Future<void> addQuestion(Question question) async {
    final db = await database;

    // Insertar la pregunta
    await db.insert('questions', {
      'id': question.id,
      'moduleId': question.moduleId,
      'questionText': question.questionText,
      'options': question.options.join(','), // Convertir lista a string
      'correctOptionIndex': question.correctOptionIndex,
      'explanation': question.explanation ?? '',
    });

    // Actualizar el contador de preguntas del módulo
    await _updateModuleQuestionCount(question.moduleId);
  }

  Future<void> updateQuestion(Question question) async {
    final db = await database;
    await db.update(
      'questions',
      {
        'moduleId': question.moduleId,
        'questionText': question.questionText,
        'options': question.options.join(','), // Convertir lista a string
        'correctOptionIndex': question.correctOptionIndex,
        'explanation': question.explanation ?? '',
      },
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<void> deleteQuestion(String questionId) async {
    final db = await database;

    // Obtener el moduleId antes de eliminar para actualizar el contador
    final question = await getQuestionById(questionId);

    // Eliminar la pregunta
    await db.delete(
      'questions',
      where: 'id = ?',
      whereArgs: [questionId],
    );

    // Actualizar el contador de preguntas del módulo
    await _updateModuleQuestionCount(question.moduleId);
  }

  Future<void> _updateModuleQuestionCount(String moduleId) async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM questions WHERE moduleId = ?', [moduleId])
    ) ?? 0;

    await db.update(
      'modules',
      {'questionCount': count},
      where: 'id = ?',
      whereArgs: [moduleId],
    );
  }

  // Método para limpiar la base de datos (útil para desarrollo)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('questions');
    await db.delete('modules');
    await _insertInitialData(db);
  }
}
