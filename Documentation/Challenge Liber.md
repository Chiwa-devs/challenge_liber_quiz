Hola Cristina, 

¿Cómo estás? Perdon por la demora, aca continuación te dejo el challenge que nos imaginamos,  puedes tardar lo que consideres, tiene 3 historias de usuarios grande, es una app que funciona y esta publica en: [https://preguntados-rubika.vercel.app/](https://preguntados-rubika.vercel.app/)  si necesitas verlo funcionar te dejo ahi la app. con el curso: G2EZTE  en screenshots es la. misma app. 

La idea es que lo analices, preguntanos lo que necesites, y cuando lo tengas poder presentarlo al equipo. 

Pongo a Nico en copia también para que esté al tanto, quedamos en contacto y atentos a cuando nos digas que presentas. (Es importante una estimación aunque luego no se cumpla es para medir el análisis de estimación que haces)

Saludos.  
\-------------------------------------------- Historias de Usuario \--------------------------------------------

### **Personas (Roles de Usuario)**

1. **Candidato:** La persona que usará la app para prepararse para su entrevista. Su objetivo es aprender y medir su conocimiento.  
2. **Administrador:** La persona que gestiona el contenido de la app (probablemente el entrevistador o alguien de RRHH). Su objetivo es mantener las preguntas actualizadas y relevantes.

---

### **Epic 1: Acceso y Navegación Principal**

#### **Historia de Usuario 1: Ingreso a la Aplicación**

* **Como** un Candidato,  
* **Quiero** ingresar mi nombre para acceder al menú principal,  
* **Para que** la aplicación me reconozca y pueda empezar a practicar.

**Criterios de Aceptación:**

* **Dado que** estoy en la pantalla de bienvenida,  
* **Cuando** ingreso mi nombre en el campo de texto y presiono "Entrar" (o un botón similar),  
* **Entonces** soy redirigido al panel principal de módulos.  
* **Dado que** estoy en la pantalla de bienvenida,  
* **Cuando** no he ingresado un nombre,  
* **Entonces** el botón para entrar está deshabilitado o muestra un mensaje de error si intento continuar.  
* **Dado que** he ingresado a la aplicación,  
* **Cuando** veo el panel principal,  
* **Entonces** se muestra un saludo personalizado, como "Hola, \[Mi Nombre\]\!".

#### **Historia de Usuario 2: Visualización de Módulos**

* **Como** un Candidato,  
* **Quiero** ver una lista de todos los módulos de estudio disponibles,  
* **Para que** pueda elegir en qué tema quiero enfocar mi práctica.

**Criterios de Aceptación:**

* **Dado que** he ingresado a la aplicación y estoy en el panel principal,  
* **Cuando** la pantalla carga,  
* **Entonces** veo una cuadrícula o lista de tarjetas, donde cada tarjeta representa un módulo.  
* **Dado que** estoy viendo las tarjetas de los módulos,  
* **Cuando** observo una tarjeta,  
* **Entonces** esta debe mostrar claramente el nombre del módulo, un ícono representativo y la cantidad de preguntas que contiene (ej: "14 preguntas").  
* **Dado que** estoy en el panel principal,  
* **Cuando** hago clic en el botón "Admin",  
* **Entonces** soy llevado a la sección de administración.

---

### **Epic 2: Realización de Cuestionarios (Modo Candidato)**

#### **Historia de Usuario 3: Iniciar y Responder un Cuestionario**

* **Como** un Candidato,  
* **Quiero** seleccionar un módulo y responder a sus preguntas una por una,  
* **Para que** pueda evaluar mi conocimiento en ese tema específico.

**Criterios de Aceptación:**

* **Dado que** estoy en el panel de módulos,  
* **Cuando** hago clic en una tarjeta de módulo (ej: "Fundamentos y Prompting"),  
* **Entonces** soy llevado a la primera pregunta de ese cuestionario.  
* **Dado que** estoy en la pantalla de una pregunta,  
* **Cuando** la veo,  
* **Entonces** se muestra el nombre del módulo, el contador de progreso ("Pregunta 1 de 14"), el texto de la pregunta y 4 opciones de respuesta.  
* **Dado que** estoy respondiendo una pregunta,  
* **Cuando** selecciono una de las opciones,  
* **Entonces** el sistema debe indicar visualmente si mi respuesta es correcta o incorrecta (por ejemplo, la opción se pinta de verde si es correcta o de rojo si es incorrecta).  
* **Dado que** he respondido una pregunta,  
* **Cuando** paso a la siguiente pregunta,  
* **Entonces** la barra de progreso superior se actualiza para reflejar mi avance.  
* **Dado que** estoy en una pregunta,  
* **Cuando** hago clic en "Volver al Menú",  
* **Entonces** salgo del cuestionario y regreso al panel de módulos principal.

#### **Historia de Usuario 4: Ver Puntuación**

* **Como** un Candidato,  
* **Quiero** ver mi puntuación mientras avanzo en el cuestionario,  
* **Para que** pueda saber cómo voy rindiendo en tiempo real.

**Criterios de Aceptación:**

* **Dado que** estoy respondiendo un cuestionario,  
* **Cuando** contesto una pregunta correctamente,  
* **Entonces** el contador de "Puntaje" en la esquina superior derecha se incrementa.  
* **Dado que** estoy respondiendo un cuestionario,  
* **Cuando** contesto una pregunta incorrectamente,  
* **Entonces** el contador de "Puntaje" no cambia.

---

### **Epic 3: Gestión de Preguntas (Modo Administrador)**

#### **Historia de Usuario 5: Añadir una Nueva Pregunta**

* **Como** un Administrador,  
* **Quiero** acceder a un formulario para añadir una nueva pregunta con sus opciones a un módulo existente,  
* **Para que** pueda mantener el banco de preguntas actualizado.

**Criterios de Aceptación:**

* **Dado que** estoy en la pantalla "Añadir Nueva Pregunta",  
* **Cuando** la veo,  
* **Entonces** se me presenta un menú desplegable para seleccionar el "Módulo", un campo de texto para la "Pregunta", y cuatro campos de texto para las "Opciones de Respuesta".  
* **Dado que** estoy en el formulario de nueva pregunta,  
* **Cuando** lleno todos los campos,  
* **Entonces** puedo seleccionar con un radio button cuál de las cuatro opciones es la correcta.  
* **Dado que** he completado todos los campos (módulo, pregunta, 4 opciones) y he marcado una respuesta como correcta,  
* **Cuando** hago clic en "Guardar Pregunta",  
* **Entonces** la pregunta se guarda en la base de datos asociada al módulo seleccionado y recibo un mensaje de confirmación.  
* **Dado que** no he completado todos los campos requeridos,  
* **Cuando** intento guardar,  
* **Entonces** el botón "Guardar Pregunta" está deshabilitado o muestra un error.  
* **Dado que** estoy en esta pantalla,  
* **Entonces** veo una nota que dice: "Nota: Las preguntas que añadas o elimines aquí se guardarán solo para esta sesión".

#### **Historia de Usuario 6: Eliminar una Pregunta Existente**

* **Como** un Administrador,  
* **Quiero** ver una lista de preguntas por módulo y poder eliminarlas,  
* **Para que** pueda quitar contenido obsoleto o incorrecto.

**Criterios de Aceptación:**

* **Dado que** estoy en la pantalla "Eliminar Preguntas Existentes",  
* **Cuando** selecciono un módulo del menú desplegable,  
* **Entonces** se carga debajo una lista con el texto de todas las preguntas de ese módulo.  
* **Dado que** veo la lista de preguntas,  
* **Cuando** observo un ítem de la lista,  
* **Entonces** este tiene un botón de "Eliminar" a su lado.  
* **Dado que** he decidido borrar una pregunta,  
* **Cuando** hago clic en el botón "Eliminar",  
* **Entonces** aparece un diálogo de confirmación (ej: "¿Estás seguro de que quieres eliminar esta pregunta?").  
* **Dado que** he confirmado la eliminación,  
* **Cuando** el sistema procesa la acción,  
* **Entonces** la pregunta se elimina de la lista en pantalla y de la base de datos, y recibo un mensaje de éxito.

