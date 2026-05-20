import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/student_provider.dart';
import '../theme/app_theme.dart';
import '../theme/app_routes.dart';
import '../widgets/app_drawer.dart';

class RegisterStudentScreen extends StatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _firstNameCtrl  = TextEditingController();
  final _lastNameCtrl   = TextEditingController();
  DateTime? _selectedDate;
  bool _isSaving = false;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now  = DateTime.now();
    final date = await showDatePicker(
      context:         context,
      initialDate:     _selectedDate ?? DateTime(2005),
      firstDate:       DateTime(1990),
      lastDate:        now,
      helpText:        'Selecciona fecha de nacimiento',
      cancelText:      'Cancelar',
      confirmText:     'Confirmar',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary:    AppTheme.primary,
            onPrimary:  Colors.white,
            surface:    AppTheme.surfaceVariant,
            onSurface:  AppTheme.onSurface,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha de nacimiento'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    context.read<StudentProvider>().addStudent(
      firstName: _firstNameCtrl.text.trim(),
      lastName:  _lastNameCtrl.text.trim(),
      birthDate: _selectedDate!,
    );

    setState(() => _isSaving = false);

    // Feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppTheme.success),
            const SizedBox(width: 10),
            Text(
              '${_firstNameCtrl.text.trim()} registrado correctamente',
            ),
          ],
        ),
      ),
    );

    // Limpiar formulario
    _formKey.currentState!.reset();
    _firstNameCtrl.clear();
    _lastNameCtrl.clear();
    setState(() => _selectedDate = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Alumno'),
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.registerStudent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header informativo ─────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding:    const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:        AppTheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_add_outlined,
                        color: AppTheme.primary,
                        size:  24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nuevo Alumno',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'Completa el formulario para registrar un alumno',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Formulario ─────────────────────────────────────────────────
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Nombre(s)
                  _FieldLabel(label: 'Nombre(s)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller:     _firstNameCtrl,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText:   'Ej. María Fernanda',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (v.trim().length < 2) {
                        return 'Ingresa al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Apellidos
                  _FieldLabel(label: 'Apellidos'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller:     _lastNameCtrl,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText:   'Ej. García López',
                      prefixIcon: Icon(Icons.drive_file_rename_outline_rounded),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Los apellidos son obligatorios';
                      }
                      if (v.trim().length < 2) {
                        return 'Ingresa al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Fecha de nacimiento
                  _FieldLabel(label: 'Fecha de Nacimiento'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap:        _pickDate,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color:        AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                        border:       Border.all(
                          color: _selectedDate != null
                              ? AppTheme.primary
                              : AppTheme.divider,
                          width: _selectedDate != null ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: _selectedDate != null
                                ? AppTheme.primary
                                : AppTheme.onSurfaceDim,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate != null
                                ? _dateFormat.format(_selectedDate!)
                                : 'Seleccionar fecha',
                            style: TextStyle(
                              color: _selectedDate != null
                                  ? AppTheme.onSurface
                                  : AppTheme.onSurfaceDim,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          if (_selectedDate != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color:        AppTheme.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Cambiar',
                                style: TextStyle(
                                  color:    AppTheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Botón Grabar ───────────────────────────────────────
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox(
                              width:  20,
                              height: 20,
                              child:  CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color:       Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(_isSaving ? 'Guardando...' : 'Grabar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppTheme.onSurfaceDim,
        fontSize: 13,
      ),
    );
  }
}