import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFD96B4C);
  static const Color secondary = Color(0xFF2F7C73);
  static const Color tertiary = Color(0xFF263248);
  static const Color background = Color(0xFFF7F2EC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFBF7F1);
  static const Color surfaceVariant = Color(0xFFF1E7DC);
  static const Color outline = Color(0xFFE2D5C6);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1C1A16);
  static const Color onSurface = Color(0xFF1C1A16);
  static const Color onSurfaceVariant = Color(0xFF5C5147);
  static const Color error = Color(0xFFB42318);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color rating = Color(0xFFF2B84B);
  static const Color success = Color(0xFF1F8A70);
  static const Color warning = Color(0xFFF2B84B);
  static const Color info = Color(0xFF3B5B8A);
  static const Color shadow = Color(0x1A1C1A16);
}

class AppGradients {
  static const LinearGradient hero = LinearGradient(
    colors: [Color(0xFFFFF3E8), Color(0xFFF7F2EC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accent = LinearGradient(
    colors: [Color(0xFFF7C59F), Color(0xFFD96B4C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );
    final colorScheme = baseScheme.copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      background: AppColors.background,
      onBackground: AppColors.onBackground,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceVariant: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      error: AppColors.error,
      onError: AppColors.onError,
    );

    final baseText = GoogleFonts.manropeTextTheme();
    final displayText = GoogleFonts.frauncesTextTheme();
    final textTheme = baseText
        .copyWith(
          displayLarge: displayText.displayLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
          ),
          displayMedium: displayText.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
          displaySmall: displayText.displaySmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          headlineLarge: displayText.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
          headlineMedium: displayText.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          headlineSmall: displayText.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          titleLarge: displayText.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          titleMedium: displayText.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          titleSmall: displayText.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: baseText.bodyLarge?.copyWith(height: 1.4),
          bodyMedium: baseText.bodyMedium?.copyWith(height: 1.4),
          bodySmall: baseText.bodySmall?.copyWith(height: 1.4),
          labelLarge: baseText.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          labelMedium: baseText.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          labelSmall: baseText.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(
          bodyColor: AppColors.onBackground,
          displayColor: AppColors.onBackground,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.onBackground,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onBackground,
          side: const BorderSide(color: AppColors.outline, width: 1.2),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        side: const BorderSide(color: AppColors.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.tertiary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 24,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.onSurfaceVariant,
        textColor: AppColors.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
