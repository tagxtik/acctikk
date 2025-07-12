// theme_toggle.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acctik/controller/theme/theme_cubit_cubit.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, currentTheme) {
        return ToggleButtons(
          isSelected: [
            currentTheme == ThemeMode.light,
            currentTheme == ThemeMode.dark
          ],
          onPressed: (index) {
            final newTheme = index == 0 ? ThemeMode.light : ThemeMode.dark;
            context.read<ThemeCubit>().setTheme(newTheme);
          },
          children: [
            Icon(Icons.brightness_5,
                color: theme.canvasColor), // Light theme icon
            Icon(Icons.brightness_4,
                color: theme.canvasColor), // Dark theme icon
          ],
        );
      },
    );
  }
}
