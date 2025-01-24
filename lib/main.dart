import 'package:flutter/material.dart';
import 'package:texol_chat_app/core/theme/app_theme.dart';
import 'package:texol_chat_app/features/auth/view/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.liteThemeMode,
      home: const LoginScreen(),
    );
  }
}
