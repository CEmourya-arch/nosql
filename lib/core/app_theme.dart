import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static const double borderRadius = 8.0;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.zinc950,
      canvasColor: AppColors.zinc950,
      dividerColor: AppColors.zinc800,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.zinc100,
        secondary: AppColors.rose500,
        surface: AppColors.zinc900,
        background: AppColors.zinc950,
        onPrimary: AppColors.zinc950,
        onSecondary: AppColors.zinc50,
        onSurface: AppColors.zinc100,
        onBackground: AppColors.zinc100,
        outline: AppColors.zinc800,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.zinc100,
        displayColor: AppColors.zinc100,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.zinc950,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.zinc400, size: 20),
      ),
      cardTheme: CardThemeData(
        color: AppColors.zinc900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: AppColors.zinc800),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.zinc800),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.zinc800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.zinc700),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.mist50,
      canvasColor: AppColors.mist50,
      dividerColor: AppColors.mist200,
      colorScheme: const ColorScheme.light(
        primary: AppColors.mist950,
        secondary: AppColors.rose500,
        surface: AppColors.mist100,
        background: AppColors.mist50,
        onPrimary: AppColors.mist50,
        onSecondary: AppColors.mist50,
        onSurface: AppColors.mist950,
        onBackground: AppColors.mist950,
        outline: AppColors.mist300,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: AppColors.mist950,
        displayColor: AppColors.mist950,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.mist50,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.mist700, size: 20),
      ),
      cardTheme: CardThemeData(
        color: AppColors.mist100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: AppColors.mist300),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.mist300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.mist300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.mist400),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
