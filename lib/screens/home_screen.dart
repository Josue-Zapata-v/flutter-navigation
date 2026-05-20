import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/student_provider.dart';
import '../theme/app_theme.dart';
import '../theme/app_routes.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth     = context.read<AuthProvider>();
    final students = context.watch<StudentProvider>();
    final user     = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius:          16,
              backgroundColor: AppTheme.primary.withOpacity(0.2),
              child: Text(
                _initials(user?.fullName ?? ''),
                style: const TextStyle(
                  color:      AppTheme.primary,
                  fontSize:   12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.home),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Saludo ────────────────────────────────────────────────────
            _WelcomeBanner(userName: user?.firstName ?? 'Usuario'),

            const SizedBox(height: 20),

            // ── Stats rápidas ─────────────────────────────────────────────
            _SectionTitle(title: 'Resumen', icon: Icons.bar_chart_rounded),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon:        Icons.people_alt_rounded,
                    label:       'Alumnos',
                    value:       '${students.studentCount}',
                    color:       AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon:        Icons.assignment_ind_rounded,
                    label:       'Rol',
                    value:       user?.role ?? '-',
                    color:       AppTheme.accent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Accesos rápidos ───────────────────────────────────────────
            _SectionTitle(title: 'Accesos Rápidos', icon: Icons.grid_view_rounded),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount:   2,
              shrinkWrap:       true,
              physics:          const NeverScrollableScrollPhysics(),
              mainAxisSpacing:  12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _QuickAccessCard(
                  icon:  Icons.person_add_outlined,
                  label: 'Registrar Alumno',
                  color: AppTheme.primary,
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.registerStudent),
                ),
                _QuickAccessCard(
                  icon:  Icons.people_outline_rounded,
                  label: 'Listar Alumnos',
                  color: AppTheme.accent,
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.listStudents),
                ),
                _QuickAccessCard(
                  icon:  Icons.person_outline_rounded,
                  label: 'Mi Perfil',
                  color: const Color(0xFF9C27B0),
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.profile),
                ),
                _QuickAccessCard(
                  icon:  Icons.help_outline_rounded,
                  label: 'Preguntas Frecuentes',
                  color: const Color(0xFFFF7043),
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.faq),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Info del sistema ──────────────────────────────────────────
            _SectionTitle(title: 'Sistema', icon: Icons.info_outline_rounded),
            const SizedBox(height: 12),
            _InfoCard(),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Subwidgets privados del Home
// ─────────────────────────────────────────────────────────────────────────────

class _WelcomeBanner extends StatelessWidget {
  final String userName;
  const _WelcomeBanner({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryVariant, AppTheme.primary],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:      AppTheme.primary.withOpacity(0.3),
            blurRadius: 16,
            offset:     const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido, $userName!',
                  style: const TextStyle(
                    color:      Colors.white,
                    fontSize:   18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestiona tus alumnos de forma fácil y rápida.',
                  style: TextStyle(
                    color:    Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.school_rounded, color: Colors.white, size: 40),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String   title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color    color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding:     const EdgeInsets.all(10),
              decoration:  BoxDecoration(
                color:        color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color,
                    ),
                  ),
                  Text(label, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:    const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color:        color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines:  2,
                overflow:  TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 11,
                  height:   1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(
              icon:  Icons.storage_rounded,
              label: 'Almacenamiento',
              value: 'Sesión en memoria',
            ),
            const Divider(height: 20),
            _InfoRow(
              icon:  Icons.flutter_dash,
              label: 'Plataforma',
              value: 'Flutter Dark',
            ),
            const Divider(height: 20),
            _InfoRow(
              icon:  Icons.verified_rounded,
              label: 'Versión',
              value: '1.0.0',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.onSurfaceDim, size: 18),
        const SizedBox(width: 10),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        )),
      ],
    );
  }
}
