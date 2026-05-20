import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../theme/app_routes.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;

    return Drawer(
      child: Column(
        children: [
          // ── Header del Drawer ────────────────────────────────────────────
          _DrawerHeader(
            fullName:  user?.fullName  ?? 'Usuario',
            role:      user?.role      ?? '',
            username:  user?.username  ?? '',
          ),

          const SizedBox(height: 8),

          // ── Opciones de navegación ────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon:        Icons.home_outlined,
                  label:       'Inicio',
                  route:       AppRoutes.home,
                  currentRoute: currentRoute,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Divider(height: 1),
                ),
                _DrawerItem(
                  icon:        Icons.person_outline_rounded,
                  label:       'Perfil',
                  route:       AppRoutes.profile,
                  currentRoute: currentRoute,
                ),
                _DrawerItem(
                  icon:        Icons.person_add_outlined,
                  label:       'Registrar Alumno',
                  route:       AppRoutes.registerStudent,
                  currentRoute: currentRoute,
                ),
                _DrawerItem(
                  icon:        Icons.people_outline_rounded,
                  label:       'Listar Alumnos',
                  route:       AppRoutes.listStudents,
                  currentRoute: currentRoute,
                ),
                _DrawerItem(
                  icon:        Icons.help_outline_rounded,
                  label:       'Preguntas Frecuentes',
                  route:       AppRoutes.faq,
                  currentRoute: currentRoute,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(),
                ),

                // ── Cerrar sesión ────────────────────────────────────────
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.error,
                  ),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      color:      AppTheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 2,
                  ),
                  onTap: () => _confirmLogout(context, auth),
                ),
              ],
            ),
          ),

          // ── Footer ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'StudentApp v1.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Diálogo de confirmación para logout ──────────────────────────────────
  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceVariant,
        title: const Text('Cerrar Sesión'),
        content: const Text(
          '¿Estás seguro que deseas cerrar la sesión actual?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop(true);
              auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (_) => false,
              );
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

// ── Subwidget: Header del drawer ─────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  final String fullName;
  final String role;
  final String username;

  const _DrawerHeader({
    required this.fullName,
    required this.role,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors:  [AppTheme.primaryVariant, AppTheme.primary],
          begin:   Alignment.topLeft,
          end:     Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar con iniciales
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              _initials(fullName),
              style: const TextStyle(
                color:      Colors.white,
                fontSize:   22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fullName,
            style: const TextStyle(
              color:      Colors.white,
              fontSize:   16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            role,
            style: TextStyle(
              color:    Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '@$username',
            style: TextStyle(
              color:    Colors.white.withOpacity(0.65),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ── Subwidget: Item del drawer ───────────────────────────────────────────────
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   route;
  final String   currentRoute;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.currentRoute,
  });

  bool get _isActive => currentRoute == route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected:          _isActive,
        selectedTileColor: AppTheme.primary.withOpacity(0.15),
        selectedColor:     AppTheme.primary,
        leading: Icon(
          icon,
          color: _isActive ? AppTheme.primary : AppTheme.onSurfaceDim,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: _isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        onTap: () {
          Navigator.of(context).pop(); // Cierra el drawer
          if (!_isActive) {
            Navigator.of(context).pushReplacementNamed(route);
          }
        },
      ),
    );
  }
}
