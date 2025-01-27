import 'package:flutter/material.dart';
import 'package:texol_chat_app/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final liteThemeMode = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: Pallete.whiteColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(Pallete.borderColor),
      focusedBorder: _border(Pallete.gradient2),
      errorBorder: _border(Pallete.errorColor),
      focusedErrorBorder: _border(Pallete.errorColor),
    ),
  );
}
