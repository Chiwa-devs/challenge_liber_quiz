# Guía de Implementación - Challenge Flutter Quiz

## 📋 Resumen del Proyecto

**Aplicación:** Sistema de cuestionarios para preparación de entrevistas  
**Tecnologías:** Flutter Web + flutter_bloc  
**Roles:** Candidato y Administrador  
**Tiempo Estimado:** 5-7 días (40-56 horas)

---

## 🎯 Objetivos del Challenge

### Epic 1: Acceso y Navegación Principal
- ✅ Pantalla de login con validación de nombre
- ✅ Panel principal con módulos de estudio
- ✅ Navegación entre secciones

### Epic 2: Realización de Cuestionarios (Modo Candidato)
- ✅ Selección de módulo y inicio de quiz
- ✅ Sistema de preguntas con opciones múltiples
- ✅ Feedback visual (correcto/incorrecto)
- ✅ Contador de puntuación en tiempo real
- ✅ Barra de progreso

### Epic 3: Gestión de Preguntas (Modo Administrador)
- ✅ Formulario para añadir nuevas preguntas
- ✅ Sistema para eliminar preguntas existentes
- ✅ Persistencia solo durante la sesión

---

## 📂 Estructura del Proyecto

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   └── utils/
│       └── validators.dart
├── data/
│   ├── models/
│   │   ├── question.dart
│   │   ├── module.dart
│   │   ├── user_answer.dart
│   │   └── quiz_session.dart
│   └── repositories/
│       └── quiz_repository.dart
├── presentation/
│   ├── bloc/
│   │   ├── auth/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── quiz/
│   │   │   ├── quiz_bloc.dart
│   │   │   ├── quiz_event.dart
│   │   │   └── quiz_state.dart
│   │   └── admin/
│   │       ├── admin_bloc.dart
│   │       ├── admin_event.dart
│   │       └── admin_state.dart
│   ├── pages/
│   │   ├── login_page.dart
│   │   ├── home_page.dart
│   │   ├── quiz_page.dart
│   │   └── admin_page.dart
│   └── widgets/
│       ├── module_card.dart
│       └── responsive_layout.dart
└── main.dart
```

---

## ⏱️ Plan de Implementación (5-7 días)

### 📅 Día 1: Configuración y Modelos (6-8 horas)
**Prioridad: Alta**

#### Tareas:
1. **Configurar proyecto Flutter Web** (1 hora)
   ```bash
   flutter create quiz_app
   cd quiz_app
   flutter config --enable-web
   ```

2. **Instalar dependencias** (0.5 horas)
   ```yaml
   dependencies:
     flutter_bloc: ^8.1.3
     equatable: ^2.0.5
   ```

3. **Crear modelos de datos** (2-3 horas)
   - [ ] `Question` model
   - [ ] `QuizModule` model
   - [ ] `UserAnswer` model
   - [ ] `QuizSession` model

4. **Implementar repository mock** (2-3 horas)
   - [ ] `QuizRepository` interface
   - [ ] `MockQuizRepository` implementation
   - [ ] Datos de prueba para módulos y preguntas

#### Entregable:
✅ Proyecto configurado con modelos básicos funcionando

---

### 📅 Día 2: Auth BLoC y Login (6-8 horas)
**Prioridad: Alta**

#### Tareas:
1. **Implementar AuthBloc** (2-3 horas)
   - [ ] States: `AuthInitial`, `AuthSuccess`, `AuthFailure`
   - [ ] Events: `LoginRequested`, `LogoutRequested`
   - [ ] Validación básica de nombre

2. **Crear LoginPage** (3-4 horas)
   - [ ] Interfaz de usuario con campo de texto
   - [ ] Validación y feedback de errores
   - [ ] Navegación al home tras login exitoso

3. **Configurar rutas principales** (1 hora)
   - [ ] Rutas en main.dart
   - [ ] Navegación básica

#### Entregable:
✅ Login funcional con validación y navegación

---

### 📅 Día 3: Home y Módulos (8-10 horas)
**Prioridad: Alta**

#### Tareas:
1. **Implementar QuizBloc básico** (3-4 horas)
   - [ ] States para cargar módulos
   - [ ] Events para inicializar
   - [ ] Lógica para obtener módulos del repository

2. **Crear HomePage** (4-5 horas)
   - [ ] Header con saludo personalizado
   - [ ] Grid de módulos responsivo
   - [ ] Botones de navegación (Admin, etc.)

3. **Implementar ModuleCard widget** (1-2 horas)
   - [ ] Diseño según mockups
   - [ ] Información del módulo (nombre, cantidad de preguntas)
   - [ ] Interacción para iniciar quiz

#### Entregable:
✅ Pantalla principal con módulos interactivos

---

### 📅 Día 4: Sistema de Quiz (10-12 horas)
**Prioridad: Crítica**

#### Tareas:
1. **Completar QuizBloc** (4-5 horas)
   - [ ] States: `QuizInProgress`, `QuestionAnswered`, `QuizCompleted`
   - [ ] Events: `StartQuiz`, `AnswerQuestion`, `NextQuestion`
   - [ ] Lógica de puntuación y progreso

2. **Crear QuizPage** (5-6 horas)
   - [ ] Header con progreso y puntaje
   - [ ] Visualización de preguntas
   - [ ] Opciones múltiples interactivas
   - [ ] Feedback visual (verde/rojo)
   - [ ] Barra de progreso

3. **Implementar navegación del quiz** (1-2 horas)
   - [ ] Botón "Volver al Menú"
   - [ ] Transición entre preguntas
   - [ ] Dialog de completación

#### Entregable:
✅ Sistema completo de quiz funcional

---

### 📅 Día 5: Panel de Administración (8-10 horas)
**Prioridad: Media-Alta**

#### Tareas:
1. **Implementar AdminBloc** (2-3 horas)
   - [ ] States para gestión de preguntas
   - [ ] Events para CRUD de preguntas
   - [ ] Validaciones

2. **Crear AdminPage con tabs** (3-4 horas)
   - [ ] Tab "Añadir Pregunta"
   - [ ] Tab "Eliminar Preguntas"
   - [ ] Navegación entre tabs

3. **Implementar formulario de nueva pregunta** (3-4 horas)
   - [ ] Dropdown de módulos
   - [ ] Campo de pregunta
   - [ ] 4 campos de opciones
   - [ ] Radio buttons para respuesta correcta
   - [ ] Validaciones y guardado

#### Entregable:
✅ Panel de administración funcional para añadir preguntas

---

### 📅 Día 6: Eliminar Preguntas y Refinamiento (6-8 horas)
**Prioridad: Media**

#### Tareas:
1. **Implementar eliminación de preguntas** (3-4 horas)
   - [ ] Lista de preguntas por módulo
   - [ ] Botones de eliminación
   - [ ] Confirmación antes de eliminar

2. **Mejorar UX/UI** (2-3 horas)
   - [ ] Animaciones suaves
   - [ ] Loading states
   - [ ] Mejores mensajes de error

3. **Testing básico** (1-2 horas)
   - [ ] Probar flujos principales
   - [ ] Verificar responsive design

#### Entregable:
✅ Funcionalidad completa de administración

---

### 📅 Día 7: Pulimiento y Testing (4-6 horas)
**Prioridad: Media**

#### Tareas:
1. **Optimizaciones finales** (2-3 horas)
   - [ ] Responsive design para diferentes pantallas
   - [ ] Optimización de rendimiento
   - [ ] Limpieza de código

2. **Testing integral** (2-3 horas)
   - [ ] Todos los flujos de usuario
   - [ ] Casos edge
   - [ ] Validación de criterios de aceptación

#### Entregable:
✅ Aplicación completa y pulida

---

## 🔧 Dependencias Clave

```yaml
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
```

---

## 📋 Criterios de Aceptación por Historia

### Historia 1: Ingreso a la Aplicación
- ✅ Campo de texto para nombre
- ✅ Botón "Entrar" habilitado solo con nombre válido
- ✅ Redirección al panel principal
- ✅ Saludo personalizado

### Historia 2: Visualización de Módulos
- ✅ Cuadrícula/lista de módulos
- ✅ Cada tarjeta muestra: nombre, ícono, cantidad de preguntas
- ✅ Botón "Admin" funcional

### Historia 3: Iniciar y Responder Cuestionario
- ✅ Navegación desde módulo a quiz
- ✅ Información: nombre módulo, progreso, puntaje
- ✅ Pregunta con 4 opciones
- ✅ Feedback visual (verde/rojo)
- ✅ Botón "Volver al Menú"

### Historia 4: Ver Puntuación
- ✅ Contador visible de puntaje
- ✅ Incremento por respuesta correcta
- ✅ Sin cambio por respuesta incorrecta

### Historia 5: Añadir Nueva Pregunta
- ✅ Dropdown para módulo
- ✅ Campo para pregunta
- ✅ 4 campos para opciones
- ✅ Radio buttons para respuesta correcta
- ✅ Validaciones y guardado
- ✅ Nota sobre persistencia de sesión

### Historia 6: Eliminar Pregunta Existente
- ✅ Dropdown para seleccionar módulo
- ✅ Lista de preguntas del módulo
- ✅ Botón eliminar por pregunta
- ✅ Confirmación antes de eliminar

---

## 🚀 Comandos de Desarrollo

```bash
# Ejecutar en modo web
flutter run -d chrome

# Build para producción web
flutter build web

# Análisis de código
flutter analyze

# Tests
flutter test
```

---

## 💡 Tips de Implementación

### Para BLoCs:
- Usar `equatable` para comparar states
- Implementar `copyWith` en modelos complejos
- Manejar loading states apropiadamente

### Para UI:
- Seguir el diseño de las imágenes proporcionadas
- Usar colores consistentes (`Color(0xFF1A2332)`, `Color(0xFF2A3441)`)
- Implementar responsive design para web

### Para Estado:
- Los datos se persisten solo durante la sesión
- Usar Map estático para simular persistencia temporal
- Limpiar estado al reiniciar la app

---

## 🎯 Resultado Esperado

Al final de los 5-7 días, tendrás una aplicación web completa que:

1. ✅ Permite login con nombre
2. ✅ Muestra módulos de estudio disponibles
3. ✅ Implementa sistema completo de quiz con feedback
4. ✅ Incluye panel de administración para gestionar preguntas
5. ✅ Cumple todos los criterios de aceptación especificados
6. ✅ Funciona correctamente en Flutter Web

**¡Éxito en tu challenge! 🚀**