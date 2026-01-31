# SAMANET.

Visión del Proyecto
Plataforma centralizada Web y Móvil para la Universidad Metropolitana que permite a estudiantes y docentes publicar, buscar y gestionar el intercambio de recursos educativos. El sistema busca reducir la brecha de acceso al material académico y garantizar la trazabilidad de los intercambios (Solicitado, Aceptado, Entregado).

Estado del Proyecto
Fase Actual: Concepción (Hito 1)
Metodología: OpenUP

Tech Stack
Frontend: Flutter (Mobile & Web)
Backend: Firebase (Auth, Firestore, Storage)
Diseño UI/UX: Figma
Pagos/Donaciones: Integración externa (ej. PayPal)(Simulación)

Requerimientos Funcionales (Alcance Inicial)

Autenticación:
Registro e inicio de sesión con correo institucional.
Gestión de perfiles (Estudiante/Docente).

Gestión de Material:
Publicación de libros con fotos y estado de conservación. Búsqueda avanzada por carrera y materia.

Intercambios:
Solicitud de libros y flujo de aprobación.
Control de stock en tiempo real (Disponible/No disponible).
Feedback y calificación de usuarios.

```text
Estructura del Repositorio

proyecto-final/
├── android/
├── ios/
├── web/
├── linux/
├── macos/
├── windows/
├── build/
├── .dart_tool/
├── .idea/
└── lib/
    ├── pages/
    │   ├── loginpage.dart
    │   └── homepage.dart
    ├── widgets/
    │   └── barraSuperior.dart
    └── main.dart

main.dart
Punto de entrada de la aplicación Flutter.
Inicializa el widget principal (MaterialApp).
Define la configuración básica de la app (tema, pantalla inicial).
Controla la navegación inicial hacia la pantalla de login o home.
No contiene lógica de negocio ni integración con Firebase en esta fase.


pages/
Contiene las pantallas completas de la aplicación. Cada archivo representa una vista principal.

loginpage.dart
Pantalla de inicio de sesión.
Implementa únicamente la interfaz gráfica.
No existe autenticación real con Firebase Auth.
Funciona como prototipo visual del flujo de acceso al sistema.

homepage.dart
Pantalla principal posterior al login.
Representa el punto de entrada al sistema de intercambio.
No contiene lógica de publicación, búsqueda ni consumo de datos.
Está pensada como base para futuras funcionalidades del sistema.


widgets/
Contiene componentes reutilizables de la interfaz.

barraSuperior.dart
Widget personalizado para la barra superior.
Encapsula la lógica visual del AppBar.
Permite reutilización en múltiples pantallas.
Mejora la organización del código al separar UI común.
```

Equipo de Desarrollo:
Ballesteros Maria, Barreda Daniel, Urdaneta Daniela, Zarbo Giovanni
