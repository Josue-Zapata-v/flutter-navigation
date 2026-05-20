# 📱 StudentApp Flutter

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-6.1.1-7B61FF?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green?style=for-the-badge)
![Theme](https://img.shields.io/badge/Theme-Dark-1A1A2E?style=for-the-badge)

**Aplicación móvil multiplataforma de gestión de alumnos.**  
Proyecto académico desarrollado en Flutter con dark theme, navegación nombrada y estado reactivo con Provider.

[Características](#-características) · [Pantallas](#-pantallas) · [Estructura](#-estructura-del-proyecto) · [Instalación](#-instalación) · [Componentes Flutter](#-componentes-flutter-utilizados)

</div>

---

## 📋 Descripción

**StudentApp** es una aplicación Flutter que demuestra el uso correcto de:

- **Navegación nombrada** con rutas centralizadas y guard de autenticación
- **Estado reactivo** con el patrón Provider (`ChangeNotifier`)
- **Persistencia en sesión** — lista de alumnos en memoria durante la sesión activa
- **Dark theme global** estilo Google Classroom / Moodle
- **Arquitectura modular** con separación clara de responsabilidades (SRP)

> **Credenciales por defecto:** Usuario: `admin` · Contraseña: `1234`

---

## ✨ Características

| Funcionalidad | Descripción |
|---|---|
| 🔐 **Login** | Autenticación con usuario hardcodeado, animación de entrada, validación de formulario |
| 🏠 **Dashboard** | Estadísticas, accesos rápidos, información del sistema |
| 👤 **Perfil** | Datos del usuario autenticado con avatar de iniciales |
| ➕ **Registrar Alumno** | Formulario con validación, DatePicker nativo, feedback visual |
| 📋 **Listar Alumnos** | Lista reactiva con tarjetas, edad calculada, eliminar con confirmación |
| ❓ **FAQ** | Preguntas frecuentes expandibles con `ExpansionTile` |
| 🗂️ **Menú Lateral** | Drawer con 6 opciones, resaltado de ruta activa, logout con confirmación |

---

## 📱 Pantallas

```
Login ──────────► Home (Dashboard)
                      │
                      ├── Menú Lateral (Drawer)
                      │       ├── Inicio        → HomeScreen
                      │       ├── Perfil        → ProfileScreen
                      │       ├── Reg. Alumno   → RegisterStudentScreen
                      │       ├── Listar        → ListStudentsScreen
                      │       ├── FAQ           → FaqScreen
                      │       └── Cerrar Sesión → LoginScreen (limpia pila)
                      │
                      └── Accesos Rápidos (mismo destino que Drawer)
```

---

## 🗂️ Estructura del Proyecto

```
student_app/
│
├── pubspec.yaml                        # Dependencias del proyecto
│
└── lib/
    │
    ├── main.dart                       # Entry point, MultiProvider, onGenerateRoute
    │
    ├── models/                         # Clases de datos puras — sin lógica de UI
    │   ├── student.dart                # Modelo Student (id, nombre, apellido, fecha nac., edad calculada)
    │   ├── user_profile.dart           # Modelo UserProfile (username, nombres, rol)
    │   ├── faq_item.dart               # Modelo FaqItem (question, answer)
    │   └── faq_data.dart               # Lista estática de 7 preguntas frecuentes
    │
    ├── providers/                      # Estado global reactivo con ChangeNotifier
    │   ├── auth_provider.dart          # Login / logout / usuario autenticado / guard
    │   └── student_provider.dart       # CRUD de alumnos en memoria durante la sesión
    │
    ├── screens/                        # Una pantalla = un archivo
    │   ├── login_screen.dart           # Pantalla de inicio de sesión con animación
    │   ├── home_screen.dart            # Dashboard principal con stats y accesos rápidos
    │   ├── profile_screen.dart         # Perfil del usuario autenticado
    │   ├── register_student_screen.dart # Formulario de registro con DatePicker
    │   ├── list_students_screen.dart   # Lista reactiva de alumnos registrados
    │   └── faq_screen.dart             # Preguntas frecuentes con ExpansionTile
    │
    ├── widgets/                        # Componentes reutilizables entre pantallas
    │   └── app_drawer.dart             # Menú lateral compartido por todas las screens auth
    │
    └── theme/                          # Configuración visual centralizada
        ├── app_theme.dart              # ThemeData dark completo (colores, tipografía, botones)
        └── app_routes.dart             # Constantes de rutas nombradas
```

### ¿Por qué esta estructura?

| Carpeta | Principio | Razón |
|---|---|---|
| `models/` | SRP | Clases de datos puras sin dependencias de Flutter UI |
| `providers/` | SRP + Reactivo | Estado global aislado, testeable de forma independiente |
| `screens/` | SRP | Una pantalla por archivo, fácil de localizar y mantener |
| `widgets/` | DRY | Reutilización — `AppDrawer` instanciado en 5 pantallas distintas |
| `theme/` | DRY + SRP | Un solo lugar para cambiar colores, fuentes y rutas de toda la app |

---

## 🚀 Instalación

### Prerequisitos

- Flutter SDK `^3.x`
- Dart SDK `^3.9.2`
- Android Studio / VS Code con extensión Flutter
- Emulador Android o dispositivo físico

### Pasos

```bash
# 1. Clonar o descomprimir el proyecto
cd student_app

# 2. Instalar dependencias
flutter pub get

# 3. Verificar entorno
flutter doctor

# 4. Ejecutar
flutter run
```

### Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1    # Gestión de estado reactivo
  intl: ^0.19.0       # Formateo de fechas (dd/MM/yyyy)
  cupertino_icons: ^1.0.8
```

---

## 🔐 Autenticación

La app cuenta con un usuario administrador por defecto hardcodeado en `AuthProvider`:

```dart
// lib/providers/auth_provider.dart
static const String _defaultUsername = 'admin';
static const String _defaultPassword = '1234';

static const UserProfile _defaultUser = UserProfile(
  username:  'admin',
  firstName: 'Josue',
  lastName:  'Zapata Villegas',
  role:      'Administrador',
);
```

> ⚠️ No existe pantalla de registro. El acceso es exclusivamente con estas credenciales.

---

## 🧭 Navegación

El sistema de navegación usa **rutas nombradas** con guard de autenticación centralizado en `main.dart`:

```dart
// lib/theme/app_routes.dart
class AppRoutes {
  static const String login           = '/';
  static const String home            = '/home';
  static const String profile         = '/profile';
  static const String registerStudent = '/register-student';
  static const String listStudents    = '/list-students';
  static const String faq             = '/faq';
}
```

```dart
// lib/main.dart — Guard de autenticación
Route<dynamic>? _generateRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) {
      if (settings.name == AppRoutes.login) return const LoginScreen();

      // Guard: redirige al login si no hay sesión activa
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (!auth.isAuthenticated) return const LoginScreen();

      switch (settings.name) {
        case AppRoutes.home:            return const HomeScreen();
        case AppRoutes.profile:         return const ProfileScreen();
        case AppRoutes.registerStudent: return const RegisterStudentScreen();
        case AppRoutes.listStudents:    return const ListStudentsScreen();
        case AppRoutes.faq:             return const FaqScreen();
        default:                        return const HomeScreen();
      }
    },
  );
}
```

### Tipos de navegación usados

```dart
// Reemplaza la pantalla actual — el Atrás no regresa al menú
Navigator.of(context).pushReplacementNamed(AppRoutes.home);

// Limpia toda la pila — usado en logout por seguridad
Navigator.of(context).pushNamedAndRemoveUntil(
  AppRoutes.login, (_) => false,
);
```

---

## ⚡ Estado con Provider

El proyecto usa el patrón **Provider + ChangeNotifier** para gestionar estado reactivo:

```
MultiProvider (main.dart)
    ├── AuthProvider       → sesión del usuario (login/logout)
    └── StudentProvider    → lista de alumnos en memoria
```

```dart
// Suscribirse y reconstruir cuando cambia (en build)
final students = context.watch<StudentProvider>().students;

// Solo ejecutar una acción sin reconstruir (en callbacks)
context.read<StudentProvider>().addStudent(...);
```

### Flujo de datos

```
Usuario registra alumno
       │
       ▼
RegisterStudentScreen
  context.read<StudentProvider>().addStudent(...)
       │
       ▼
StudentProvider._students.add(newStudent)
  notifyListeners()
       │
       ▼
ListStudentsScreen se reconstruye automáticamente
  context.watch<StudentProvider>().students
```

---

## 🎨 Tema Global (Dark Theme)

Toda la paleta de colores y estilos se define en **un único archivo**:

```dart
// lib/theme/app_theme.dart
class AppTheme {
  static const Color primary        = Color(0xFF1A73E8); // Azul Google
  static const Color accent         = Color(0xFF00BCD4); // Cyan
  static const Color surface        = Color(0xFF1E1E2E); // Superficies
  static const Color background     = Color(0xFF12121C); // Fondo base
  static const Color surfaceVariant = Color(0xFF2A2A3E); // Tarjetas

  static ThemeData get darkTheme => ThemeData(
    appBarTheme:          AppBarTheme(...),
    drawerTheme:          DrawerThemeData(...),
    cardTheme:            CardThemeData(...),
    inputDecorationTheme: InputDecorationTheme(...),
    elevatedButtonTheme:  ElevatedButtonThemeData(...),
    textTheme:            TextTheme(...),
  );
}
```

> Todos los widgets (`AppBar`, `Card`, `TextField`, `ElevatedButton`) heredan el estilo automáticamente sin necesidad de configurarlos pantalla por pantalla.

---

## 📚 Componentes Flutter Utilizados

### ✅ Conceptos Base

#### ListView y ListView.builder

```dart
// app_drawer.dart — lista scrolleable del menú
ListView(padding: EdgeInsets.zero, children: [...])

// list_students_screen.dart — lista eficiente y dinámica
ListView.builder(
  itemCount:   students.length,
  itemBuilder: (context, index) => _StudentCard(...),
)

// faq_screen.dart — preguntas frecuentes
ListView.builder(
  itemCount:   faqData.length,
  itemBuilder: (context, index) => _FaqTile(...),
)
```

> `ListView.builder` solo construye los widgets visibles en pantalla (lazy loading), ideal para listas que crecen en runtime.

---

#### ListTile

```dart
// app_drawer.dart — cada opción del menú lateral
ListTile(
  selected:          _isActive,
  selectedTileColor: AppTheme.primary.withOpacity(0.15),
  leading: Icon(icon),
  title:   Text(label),
  onTap:   () { Navigator.of(context).pushReplacementNamed(route); },
)

// profile_screen.dart — cada campo del perfil
ListTile(
  leading:  Container(child: Icon(...)),
  title:    Text(label),    // "Nombre", "Apellido"...
  subtitle: Text(value),    // "Josue", "Zapata Villegas"...
)
```

---

#### Listas — colecciones Dart

```dart
// models/faq_data.dart — lista estática de datos
const List<FaqItem> faqData = [
  FaqItem(question: '¿Cómo registro un alumno?', answer: '...'),
  ...
];

// providers/student_provider.dart — base de datos en memoria
final List<Student> _students = [...];

// Expuesta como inmutable al exterior
List<Student> get students => List.unmodifiable(_students);
```

---

#### Rutas Nombradas

```dart
// theme/app_routes.dart — constantes centralizadas
class AppRoutes {
  static const String login  = '/';
  static const String home   = '/home';
  // ...
}
```

---

#### Tema Global

```dart
// main.dart — aplicado una sola vez
MaterialApp(
  theme: AppTheme.darkTheme,
)
```

---

#### Cards

| Widget | Archivo | Uso |
|---|---|---|
| `_StatCard` | `home_screen.dart` | Estadísticas del dashboard |
| `_QuickAccessCard` | `home_screen.dart` | 4 accesos rápidos (con `InkWell`) |
| `_StudentCard` | `list_students_screen.dart` | Tarjeta por alumno en la lista |
| Header info | `register_student_screen.dart` | Descripción del formulario |
| Campos perfil | `profile_screen.dart` | Agrupación de campos con `Divider` |
| `_FaqTile` | `faq_screen.dart` | Envuelve el `ExpansionTile` |

---

### 🆕 Conceptos Nuevos Aprendidos

#### Provider — ChangeNotifier

```dart
class StudentProvider extends ChangeNotifier {
  final List<Student> _students = [];

  void addStudent({...}) {
    _students.add(newStudent);
    notifyListeners(); // reconstruye todos los widgets suscritos
  }
}
```

---

#### Animaciones — AnimationController

```dart
// login_screen.dart
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _animController;

  @override
  void initState() {
    _animController = AnimationController(vsync: this, duration: 700.ms);
    _animController.forward();
  }
}

FadeTransition(
  opacity: _fadeAnim,
  child:   SlideTransition(position: _slideAnim, child: form),
)
```

---

#### Formularios — Form + GlobalKey + showDatePicker

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: TextFormField(
    validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
  ),
)

// Dispara todos los validators a la vez
_formKey.currentState!.validate();

// Selector de fecha nativo con dark theme
final date = await showDatePicker(
  context: context,
  initialDate: DateTime(2005),
  firstDate:   DateTime(1990),
  lastDate:    DateTime.now(),
);
```

---

#### Guard de Autenticación — onGenerateRoute

```dart
// Si no hay sesión, cualquier ruta protegida redirige al Login
if (!auth.isAuthenticated) return LoginScreen();
```

---

#### Widgets Avanzados

```dart
// ExpansionTile — preguntas frecuentes expandibles
ExpansionTile(
  title:    Text(question),
  children: [Text(answer)],
)

// ClipRRect — respeta bordes redondeados del Card al expandir
Card(child: ClipRRect(borderRadius: ..., child: ExpansionTile(...)))

// FloatingActionButton.extended — FAB con ícono y texto
FloatingActionButton.extended(icon: Icon(...), label: Text('Nuevo'))

// showDialog + AlertDialog — confirmaciones destructivas
showDialog(builder: (_) => AlertDialog(title: ..., actions: [...]))
```

---

#### Dart Avanzado

```dart
// async / await — UI no bloqueante
Future<void> _submit() async {
  setState(() => _isLoading = true);
  await Future.delayed(Duration(milliseconds: 600));
  if (!mounted) return;
  // ...
}

// intl / DateFormat — formato de fecha localizado
DateFormat('dd/MM/yyyy').format(student.birthDate); // "15/03/2005"

// List.unmodifiable — encapsulamiento del estado
List<Student> get students => List.unmodifiable(_students);
```

---

## 📁 Archivos Clave — Referencia Rápida

| Archivo | Responsabilidad |
|---|---|
| `main.dart` | Bootstrap, `MultiProvider`, `onGenerateRoute`, guard de auth |
| `app_theme.dart` | Paleta dark, `ThemeData` global completo |
| `app_routes.dart` | Constantes de rutas nombradas |
| `auth_provider.dart` | Estado de sesión, credenciales, login/logout |
| `student_provider.dart` | Lista de alumnos en memoria, add/remove |
| `app_drawer.dart` | Menú lateral reutilizable con resaltado de ruta activa |
| `login_screen.dart` | Login con animación, form validation, guard redirect |
| `home_screen.dart` | Dashboard con stats, accesos rápidos, banner bienvenida |
| `register_student_screen.dart` | Form con DatePicker, validación, feedback |
| `list_students_screen.dart` | Lista reactiva, FAB, eliminar con AlertDialog |
| `faq_screen.dart` | FAQ con ExpansionTile, ClipRRect |
| `profile_screen.dart` | Perfil del usuario con avatar de iniciales |

---

## 👤 Autor

**Josue Zapata Villegas**  
Estudiante de Desarrollo de Software — Instituto Tecsup, Lima, Perú  
Curso: Aplicaciones Móviles Multiplataforma · 2026

---

<div align="center">

Desarrollado con ❤️ y ☕ · Flutter Dark Theme · Provider · Tecsup 2026

</div>
