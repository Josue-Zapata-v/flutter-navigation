import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/student_provider.dart';
import 'theme/app_theme.dart';
import 'theme/app_routes.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_student_screen.dart';
import 'screens/list_students_screen.dart';
import 'screens/faq_screen.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: MaterialApp(
        title:            'StudentApp',
        debugShowCheckedModeBanner: false,
        theme:            AppTheme.darkTheme,
        initialRoute:     AppRoutes.login,

        // ── Guard de navegación: protege rutas autenticadas ──────────────
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        // Rutas públicas (no requieren auth)
        if (settings.name == AppRoutes.login) {
          return const LoginScreen();
        }

        // Rutas protegidas: verificar autenticación
        final auth = Provider.of<AuthProvider>(context, listen: false);
        if (!auth.isAuthenticated) {
          return const LoginScreen();
        }

        switch (settings.name) {
          case AppRoutes.home:
            return const HomeScreen();
          case AppRoutes.profile:
            return const ProfileScreen();
          case AppRoutes.registerStudent:
            return const RegisterStudentScreen();
          case AppRoutes.listStudents:
            return const ListStudentsScreen();
          case AppRoutes.faq:
            return const FaqScreen();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}