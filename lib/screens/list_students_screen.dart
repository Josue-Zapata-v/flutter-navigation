import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/student_provider.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';
import '../theme/app_routes.dart';
import '../widgets/app_drawer.dart';

class ListStudentsScreen extends StatelessWidget {
  const ListStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = context.watch<StudentProvider>().students;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Alumnos'),
        actions: [
          // Contador de alumnos
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:        AppTheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${students.length} alumnos',
                  style: const TextStyle(
                    color:      AppTheme.primary,
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.listStudents),

      // ── FAB para ir a registrar ────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .pushReplacementNamed(AppRoutes.registerStudent),
        icon:            const Icon(Icons.person_add_outlined),
        label:           const Text('Nuevo'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),

      body: students.isEmpty
          ? _EmptyState()
          : ListView.builder(
              padding:     const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount:   students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return _StudentCard(
                  student:    student,
                  index:      index,
                  dateFormat: dateFormat,
                  onDelete:   () => _confirmDelete(context, student),
                );
              },
            ),
    );
  }

  void _confirmDelete(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceVariant,
        title:   const Text('Eliminar Alumno'),
        content: Text(
          '¿Deseas eliminar a ${student.fullName} del registro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child:     const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            onPressed: () {
              context.read<StudentProvider>().removeStudent(student.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${student.fullName} eliminado'),
                ),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de alumno ────────────────────────────────────────────────────────
class _StudentCard extends StatelessWidget {
  final Student    student;
  final int        index;
  final DateFormat dateFormat;
  final VoidCallback onDelete;

  const _StudentCard({
    required this.student,
    required this.index,
    required this.dateFormat,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Número / Avatar
              Container(
                width:       46,
                height:      46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryVariant, AppTheme.primary],
                    begin:  Alignment.topLeft,
                    end:    Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color:      Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize:   16,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Info del alumno
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size:  13,
                          color: AppTheme.onSurfaceDim,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(student.birthDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:        AppTheme.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${student.age} años',
                            style: const TextStyle(
                              color:    AppTheme.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Botón eliminar
              IconButton(
                icon:  const Icon(Icons.delete_outline_rounded),
                color: AppTheme.onSurfaceDim,
                onPressed: onDelete,
                tooltip: 'Eliminar alumno',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Estado vacío ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:    const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color:        AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size:  64,
                color: AppTheme.onSurfaceDim,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sin alumnos registrados',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Presiona el botón "Nuevo" para registrar tu primer alumno.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}