import 'package:dexpro/core/config/app_constants.dart';
import 'package:dexpro/core/models/accent_option.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _themeMode = ThemeMode.dark;
    _accent = _defaultAccent;
  }
  late ThemeMode _themeMode;
  late AccentOption _accent;

  ThemeMode get themeMode => _themeMode;
  AccentOption get accent => _accent;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  AccentOption get _defaultAccent => accentOptions.firstWhere(
    (AccentOption option) => option.name == 'Mint',
  );

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> updateAccent(AccentOption accent) async {
    _accent = accent;
    notifyListeners();
  }
}
