import 'package:flutter/material.dart';

/// Charte graphique GESTAVI, reprise du panel web : vert GESTAVI comme couleur principale,
/// neutres légèrement verdis, Figtree, arrondis 10 px (contrôles) et 14 px (surfaces).
/// Deux thèmes : Sous-bois (clair) et Nuit (sombre).
class GestaviTheme {
  GestaviTheme._();

  static const Color primary = Color(0xFF15803D);
  static const Color primaryDark = Color(0xFF14532D);
  static const Color primaryLight = Color(0xFF4ADE80);
  static const Color primarySoft = Color(0xFFDCFCE7);

  static const Color ink = Color(0xFF1C2B22);
  static const Color inkMuted = Color(0xFF4B5F54);
  static const Color line = Color(0xFFDFE5E0);
  static const Color sand = Color(0xFFF6F5EF);

  static const Color nightCanvas = Color(0xFF0F1A14);
  static const Color nightSurface = Color(0xFF16241C);
  static const Color nightLine = Color(0xFF243229);
  static const Color nightInk = Color(0xFFE6EBE7);
  static const Color nightMuted = Color(0xFF9FB3A7);

  static const Color danger = Color(0xFFBE123C);
  static const Color warning = Color(0xFFB45309);
  static const Color info = Color(0xFF1D4ED8);

  static const double radiusControl = 10;
  static const double radiusSurface = 14;

  static ThemeData light() => _build(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primarySoft,
      onPrimaryContainer: primaryDark,
      secondary: primaryDark,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: ink,
      surfaceContainerHighest: line,
      onSurfaceVariant: inkMuted,
      outline: line,
      error: danger,
      onError: Colors.white,
    ),
    canvas: sand,
    appBarBackground: primaryDark,
    appBarForeground: Colors.white,
  );

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryLight,
      onPrimary: nightCanvas,
      primaryContainer: Color(0xFF1F3A2A),
      onPrimaryContainer: Color(0xFF86EFAC),
      secondary: primaryLight,
      onSecondary: nightCanvas,
      surface: nightSurface,
      onSurface: nightInk,
      surfaceContainerHighest: nightLine,
      onSurfaceVariant: nightMuted,
      outline: nightLine,
      error: Color(0xFFFB7185),
      onError: nightCanvas,
    ),
    canvas: nightCanvas,
    appBarBackground: nightCanvas,
    appBarForeground: nightInk,
  );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color canvas,
    required Color appBarBackground,
    required Color appBarForeground,
  }) {
    // Figtree est embarquée dans l'application (assets/fonts) : aucun téléchargement à l'exécution
    final base = ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'Figtree',
    );
    final text = base.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusControl),
    );

    return base.copyWith(
      scaffoldBackgroundColor: canvas,
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(
          color: appBarForeground,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSurface),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: controlShape,
          textStyle: text.labelLarge?.copyWith(fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: controlShape,
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          text.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusControl),
        ),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outline, space: 1),
    );
  }
}
