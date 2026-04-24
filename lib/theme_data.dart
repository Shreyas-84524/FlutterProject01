import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final Color mainBackground;
  final Color secondaryBackground;
  final Color actionButtonColor;
  final Color clearButtonColor;
  final Color numberButtonColor;
  final Color textColor;

  const AppTheme({
    required this.name,
    required this.mainBackground,
    required this.secondaryBackground,
    required this.actionButtonColor,
    required this.clearButtonColor,
    required this.numberButtonColor,
    required this.textColor,
  });
}

// Global list of themes based on requested palettes
final List<AppTheme> appThemes = [
  const AppTheme(
    name: 'Yellow Theme',
    mainBackground: Color(0xFFFFFFFF), // Black
    secondaryBackground: Color(0xFFFEFDDF), // Cream
    actionButtonColor: Color(0xFFE87F24), // Orange
    clearButtonColor: Color(0xFFE87F24), // Orange
    numberButtonColor: Color(0xFFFFC81E), // Yellow
    textColor: Color(0xFF000000), // Black
  ),
  const AppTheme(
    name: 'Pookie Theme',
    mainBackground: Color(0xFFFFD1DC), // Pastel Pink
    secondaryBackground: Color(0xFFFFF0F5), // Lavender Blush
    actionButtonColor: Color(0xFFFF69B4), // Hot Pink
    clearButtonColor: Color(0xFFFF69B4), // Hot Pink
    numberButtonColor: Color(0xFFFFB6C1), // Light Pink
    textColor: Color(0xFF800020), // Burgundy
  ),
  const AppTheme(
    name: 'Night Theme',
    mainBackground: Color(0xFF1A1B26), // Deep Storm Blue
    secondaryBackground: Color(0xFF24283B), // Lighter Navy
    actionButtonColor: Color(0xFF0C4393), // Steel Blue
    clearButtonColor: Color(0xFFBB9AF7), // Soft Purple
    numberButtonColor: Color.fromARGB(255, 105, 155, 230), // Muted Blue/Grey
    textColor: Color(0xFFFFFFFF), // Ice Blue
  ),
  const AppTheme(
    name: 'Light Theme',
    mainBackground: Color(0xFFFFFFFF), // Pure White
    secondaryBackground: Color(0xFFFFECDF), // Orange Blush
    actionButtonColor: Color(0xFFFF7F1E), // Tangerine Orange
    clearButtonColor: Color(0xFFFF7F1E), // Tangerine Orange
    numberButtonColor: Color(0xFFF5F5F5), // Soft Grey
    textColor: Color(0xFF000000), // Jet Black
  ),
];

// Global active theme pointer
AppTheme currentTheme = appThemes[0];
