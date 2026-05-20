import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../theme/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey        = GlobalKey<FormState>();
  final _usernameCtrl   = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  bool  _obscurePassword = true;
  bool  _isLoading       = false;

  late final AnimationController _animController;
  late final Animation<double>    _fadeAnim;
  late final Animation<Offset>    _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController, curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final auth    = context.read<AuthProvider>();
    final success = auth.login(_usernameCtrl.text.trim(), _passwordCtrl.text);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Error al iniciar sesión'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Fondo con gradiente decorativo ──────────────────────────────
          Positioned(
            top:   -80,
            right: -80,
            child: Container(
              width:  260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left:   -60,
            child: Container(
              width:  200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withOpacity(0.06),
              ),
            ),
          ),

          // ── Contenido principal ──────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: size.width > 480 ? 420 : double.infinity,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 32),

                          // ── Logo / Ícono ───────────────────────────────
                          Center(
                            child: Container(
                              width:  80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.primaryVariant,
                                    AppTheme.primary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end:   Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:      AppTheme.primary.withOpacity(0.35),
                                    blurRadius: 20,
                                    offset:     const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size:  40,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Título ─────────────────────────────────────
                          Text(
                            'StudentApp',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  letterSpacing: -0.5,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Gestión de Alumnos',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 40),

                          // ── Formulario ─────────────────────────────────
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Username
                                TextFormField(
                                  controller:  _usernameCtrl,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText:   'Usuario',
                                    prefixIcon:  Icon(Icons.person_outline_rounded),
                                    hintText:    'Ingresa tu usuario',
                                  ),
                                  validator: (v) => (v == null || v.trim().isEmpty)
                                      ? 'Ingresa tu usuario'
                                      : null,
                                ),

                                const SizedBox(height: 16),

                                // Password
                                TextFormField(
                                  controller:     _passwordCtrl,
                                  obscureText:    _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submit(),
                                  decoration: InputDecoration(
                                    labelText:  'Contraseña',
                                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                                    hintText:   'Ingresa tu contraseña',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword,
                                      ),
                                    ),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Ingresa tu contraseña'
                                      : null,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Botón Ingresar ─────────────────────────────
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              child: _isLoading
                                  ? const SizedBox(
                                      width:  22,
                                      height: 22,
                                      child:  CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color:       Colors.white,
                                      ),
                                    )
                                  : const Text('Ingresar'),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Hint de credenciales ───────────────────────
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppTheme.primary,
                                  size:  18,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Usuario: admin  •  Contraseña: 1234',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppTheme.primary,
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}