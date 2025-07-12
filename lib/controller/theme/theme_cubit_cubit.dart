// theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void setTheme(ThemeMode theme) async {
    emit(theme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', theme.index);
  }

  Future<ThemeMode> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getInt('theme');
    return ThemeMode.values[savedTheme!];
  }

  Future<void> initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getInt('theme');
    if (savedTheme != null) {
      emit(ThemeMode.values[savedTheme]);
    }
  }
}
