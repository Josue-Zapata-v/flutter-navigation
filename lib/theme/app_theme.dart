import 'package:flutter/material.dart';

class AppTheme {
  // ── Paleta de colores ──────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF1A73E8); // Azul Google
  static const Color primaryVariant = Color(0xFF1557B0);
  static const Color accent         = Color(0xFF00BCD4); // Cyan accent
  static const Color surface        = Color(0xFF1E1E2E); // Superficie oscura
  static const Color surfaceVariant = Color(0xFF2A2A3E); // Tarjetas / drawer
  static const Color background     = Color(0xFF12121C); // Fondo base
  static const Color onPrimary      = Color(0xFFFFFFFF);
  static const Color onSurface      = Color(0xFFE2E2E8);
  static const Color onSurfaceDim   = Color(0xFF9090A8);
  static const Color error          = Color(0xFFCF6679);
  static const Color success        = Color(0xFF4CAF50);
  static const Color divider        = Color(0xFF2E2E44);

  // ── Tema oscuro principal ──────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary:       primary,
      secondary:     accent,
      surface:       surface,
      background:    background,
      error:         error,
      onPrimary:     onPrimary,
      onSecondary:   onPrimary,
      onSurface:     onSurface,
      onBackground:  onSurface,
    ),

    scaffoldBackgroundColor: background,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor:  surface,
      foregroundColor:  onSurface,
      elevation:        0,
      centerTitle:      false,
      titleTextStyle: TextStyle(
        fontFamily:  'Roboto',
        fontSize:    20,
        fontWeight:  FontWeight.w600,
        color:       onSurface,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: onSurface),
    ),

    // Drawer
    drawerTheme: const DrawerThemeData(
      backgroundColor: surfaceVariant,
      elevation: 8,
    ),

    // Cards
    cardTheme: CardThemeData(
      color:       surfaceVariant,
      elevation:   2,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled:      true,
      fillColor:   surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:   BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:   const BorderSide(color: divider, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:   const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:   const BorderSide(color: error, width: 1),
      ),
      labelStyle: const TextStyle(color: onSurfaceDim),
      prefixIconColor: onSurfaceDim,
    ),

    // Elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation:       3,
        padding:         const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize:    15,
          fontWeight:  FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color:     divider,
      thickness: 1,
    ),

    // ListTile
    listTileTheme: const ListTileThemeData(
      textColor:  onSurface,
      iconColor:  onSurfaceDim,
      tileColor:  Colors.transparent,
    ),

    // ExpansionTile
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor:        primary,
      collapsedIconColor: onSurfaceDim,
      textColor:        primary,
      collapsedTextColor: onSurface,
      backgroundColor:  Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
    ),

    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceVariant,
      contentTextStyle: const TextStyle(color: onSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Typography
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: onSurface, fontSize: 28, fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: onSurface, fontSize: 22, fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: onSurface, fontSize: 18, fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: onSurface, fontSize: 16, fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(color: onSurface, fontSize: 15),
      bodyMedium: TextStyle(color: onSurfaceDim, fontSize: 14),
      labelLarge: TextStyle(
        color: onSurface, fontSize: 14, fontWeight: FontWeight.w600,
      ),
    ),
  );
}