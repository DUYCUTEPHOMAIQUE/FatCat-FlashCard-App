import 'package:flutter/material.dart';

/// Định nghĩa light và dark theme cho toàn app.
/// Sử dụng Material3 ColorScheme.
class AppTheme {
  AppTheme._();

  // ── Seed colors ───────────────────────────────────────────────
  static const Color _lightSeed = Color(0xFFF2994A); // warm orange
  static const Color _darkSeed = Color(0xFFFF9800);

  // ── Light theme ───────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _lightSeed,
          brightness: Brightness.light,
          surface: const Color(0xFFF5F6F8),        // backgroundScreen
          onSurface: const Color(0xFF2C2C37),       // textPrimary
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6F8),
        cardColor: const Color(0xFFFEFEFE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F6F8),
          foregroundColor: Color(0xFF2C2C37),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFFF9800),
          unselectedItemColor: Color(0xFF9E9E9E),
        ),
        dividerColor: const Color(0xFFE0E0E0),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2C2C37)),
          ),
        ),
      );

  // ── Dark theme ────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _darkSeed,
          brightness: Brightness.dark,
          surface: const Color(0xFF1C1C1E),         // dark background
          onSurface: const Color(0xFFEAEAEA),        // dark text
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C1C1E),
          foregroundColor: Color(0xFFEAEAEA),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1C1C1E),
          selectedItemColor: Color(0xFFFF9800),
          unselectedItemColor: Color(0xFF757575),
        ),
        dividerColor: const Color(0xFF3A3A3A),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF555555)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
          ),
        ),
      );
}
