import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A provider class to manage the theme mode
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// Light theme configuration
ThemeData lightTheme() {
  final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue, // Your primary seed color
    brightness: Brightness.light,
  );

  return ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.light().textTheme,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
    ),
  );
}