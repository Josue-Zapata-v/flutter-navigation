import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../theme/app_routes.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.profile),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── Avatar grande ──────────────────────────────────────────────
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width:  110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryVariant, AppTheme.primary],
                        begin:  Alignment.topLeft,
                        end:    Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:      AppTheme.primary.withOpacity(0.35),
                          blurRadius: 20,
                          offset:     const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _initials(user?.fullName ?? ''),
                        style: const TextStyle(
                          color:      Colors.white,
                          fontSize:   36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Nombre y rol ───────────────────────────────────────────────
            Text(
              user?.fullName ?? '-',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color:        AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user?.role ?? '-',
                style: const TextStyle(
                  color:      AppTheme.primary,
                  fontSize:   13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Tarjeta de información ─────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon:  Icons.badge_outlined,
                      label: 'Nombre',
                      value: user?.firstName ?? '-',
                    ),
                    const Divider(indent: 56, endIndent: 16, height: 1),
                    _ProfileTile(
                      icon:  Icons.drive_file_rename_outline_rounded,
                      label: 'Apellido',
                      value: user?.lastName ?? '-',
                    ),
                    const Divider(indent: 56, endIndent: 16, height: 1),
                    _ProfileTile(
                      icon:  Icons.alternate_email_rounded,
                      label: 'Usuario',
                      value: '@${user?.username ?? '-'}',
                    ),
                    const Divider(indent: 56, endIndent: 16, height: 1),
                    _ProfileTile(
                      icon:  Icons.admin_panel_settings_outlined,
                      label: 'Rol',
                      value: user?.role ?? '-',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Info de sesión ─────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding:    const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:        AppTheme.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppTheme.success,
                        size:  22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sesión activa',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Sesión en memoria',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding:    const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:        AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}