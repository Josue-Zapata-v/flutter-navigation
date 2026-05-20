import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  // ── Usuario por defecto hardcodeado ────────────────────────────────────────
  static const String _defaultUsername = 'admin';
  static const String _defaultPassword = '1234';

  static const UserProfile _defaultUser = UserProfile(
    username:  'admin',
    firstName: 'Josue',
    lastName:  'Zapata Villegas',
    role:      'Administrador',
  );

  bool _isAuthenticated = false;
  UserProfile? _currentUser;
  String? _errorMessage;

  // ── Getters ────────────────────────────────────────────────────────────────
  bool            get isAuthenticated => _isAuthenticated;
  UserProfile?    get currentUser     => _currentUser;
  String?         get errorMessage    => _errorMessage;

  // ── Login ──────────────────────────────────────────────────────────────────
  bool login(String username, String password) {
    _errorMessage = null;

    if (username == _defaultUsername && password == _defaultPassword) {
      _isAuthenticated = true;
      _currentUser     = _defaultUser;
      notifyListeners();
      return true;
    }

    _errorMessage = 'Usuario o contraseña incorrectos';
    notifyListeners();
    return false;
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  void logout() {
    _isAuthenticated = false;
    _currentUser     = null;
    _errorMessage    = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}