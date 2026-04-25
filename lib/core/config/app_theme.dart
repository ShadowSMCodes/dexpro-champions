import 'package:dexpro/core/models/accent_option.dart';
import 'package:flutter/material.dart';

ThemeData buildThemeData({
  required Brightness brightness,
  required AccentOption accent,
}) {
  final bool isDark = brightness == Brightness.dark;
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: accent.color,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'RobotoCondensed',
    colorScheme: scheme,
    scaffoldBackgroundColor:
        isDark ? Colors.black : accent.lightBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? Colors.black : accent.lightBackgroundColor,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: isDark ? const Color(0xFF111111) : Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: isDark ? const Color(0xFF141414) : Colors.white,
      elevation: isDark ? 0 : 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : scheme.primary.withValues(alpha: 0.10),
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: isDark ? const Color(0xFF111111) : Colors.white,
      indicatorColor: scheme.primary.withValues(alpha: isDark ? 0.28 : 0.14),
      selectedIconTheme: IconThemeData(color: scheme.primary),
      selectedLabelTextStyle: TextStyle(
        color: scheme.primary,
        fontWeight: FontWeight.w700,
      ),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(
      color: isDark ? const Color(0xFF111111) : Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
