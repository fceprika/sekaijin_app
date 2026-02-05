import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Ink (text + primary UI)
  static const Color ink50 = Color(0xFFF3F6F9);
  static const Color ink100 = Color(0xFFE5EBF1);
  static const Color ink200 = Color(0xFFCFD9E4);
  static const Color ink300 = Color(0xFFAAB9C8);
  static const Color ink400 = Color(0xFF7D91A5);
  static const Color ink500 = Color(0xFF556A83);
  static const Color ink600 = Color(0xFF3E5167);
  static const Color ink700 = Color(0xFF2B3A4D);
  static const Color ink800 = Color(0xFF1C2736);
  static const Color ink900 = Color(0xFF0B1B2B);
  static const Color ink950 = Color(0xFF07111C);

  // Lagoon (brand accent)
  static const Color lagoon50 = Color(0xFFEFFAF8);
  static const Color lagoon100 = Color(0xFFD8F3EE);
  static const Color lagoon200 = Color(0xFFB0E7DD);
  static const Color lagoon300 = Color(0xFF7CD4C7);
  static const Color lagoon400 = Color(0xFF42B7AA);
  static const Color lagoon500 = Color(0xFF1A948C);
  static const Color lagoon600 = Color(0xFF0F766E);
  static const Color lagoon700 = Color(0xFF0B5B54);
  static const Color lagoon800 = Color(0xFF0B4943);
  static const Color lagoon900 = Color(0xFF083531);

  // Sand (warm backgrounds)
  static const Color sand50 = Color(0xFFFBF8F3);
  static const Color sand100 = Color(0xFFF6F2EA);
  static const Color sand200 = Color(0xFFEFE6D8);
  static const Color sand300 = Color(0xFFE0D1B8);
  static const Color sand400 = Color(0xFFCEB58F);
  static const Color sand500 = Color(0xFFB9935F);
  static const Color sand600 = Color(0xFF9B7446);
  static const Color sand700 = Color(0xFF7C5A36);
  static const Color sand800 = Color(0xFF5F4429);
  static const Color sand900 = Color(0xFF3B2B1A);

  // Mist (cool neutral for cards/lines)
  static const Color mist50 = Color(0xFFF8FAFC);
  static const Color mist100 = Color(0xFFEEF2F6);
  static const Color mist200 = Color(0xFFE2E8F0);
  static const Color mist300 = Color(0xFFCDD5E1);
  static const Color mist400 = Color(0xFFA3AFC2);
  static const Color mist500 = Color(0xFF7B8BA3);
  static const Color mist600 = Color(0xFF5F6F87);

  // Copper (warm accent / warning)
  static const Color copper50 = Color(0xFFFFF3EC);
  static const Color copper100 = Color(0xFFFFE5D5);
  static const Color copper200 = Color(0xFFFFC9AA);
  static const Color copper300 = Color(0xFFFF9F70);
  static const Color copper400 = Color(0xFFF0703B);
  static const Color copper500 = Color(0xFFC2410C);
  static const Color copper600 = Color(0xFF9A3412);
  static const Color copper700 = Color(0xFF7C2D12);
  static const Color copper800 = Color(0xFF6C2A12);
  static const Color copper900 = Color(0xFF4C1D12);

  // App tokens
  static const Color primary = ink900; // Ink CTA
  static const Color secondary = lagoon600; // Lagoon accent
  static const Color tertiary = ink800;
  static const Color background = sand50;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = mist50;
  static const Color surfaceVariant = mist100;
  static const Color outline = ink100;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onBackground = ink900;
  static const Color onSurface = ink900;
  static const Color onSurfaceVariant = ink600;
  static const Color error = copper600;
  static const Color onError = Color(0xFFFFFFFF);
  static const Color rating = Color(0xFFF2B84B);
  static const Color success = lagoon600;
  static const Color warning = copper500;
  static const Color info = ink600;
  static const Color shadow = Color(0x1207111C);
}

class AppGradients {
  static const LinearGradient hero = LinearGradient(
    colors: [AppColors.sand50, AppColors.mist50],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accent = LinearGradient(
    colors: [AppColors.lagoon200, AppColors.lagoon600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.secondary,
      brightness: Brightness.light,
    );
    final colorScheme = baseScheme.copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      error: AppColors.error,
      onError: AppColors.onError,
    );

    final baseText = GoogleFonts.sourceSans3TextTheme();
    final displayText = GoogleFonts.newsreaderTextTheme();
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
          bodyLarge: baseText.bodyLarge?.copyWith(height: 1.35),
          bodyMedium: baseText.bodyMedium?.copyWith(height: 1.35),
          bodySmall: baseText.bodySmall?.copyWith(height: 1.35),
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
          bodyColor: AppColors.ink700,
          displayColor: AppColors.ink900,
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
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
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
          side: const BorderSide(color: AppColors.ink300, width: 1.2),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
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
        backgroundColor: AppColors.ink900,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.ink500,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
