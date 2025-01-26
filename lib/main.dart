import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texol_chat_app/core/theme/app_theme.dart';
import 'package:texol_chat_app/features/auth/view/screens/login_screen.dart';
import 'package:texol_chat_app/features/auth/view_model/auth_view_model.dart';
import 'package:texol_chat_app/features/chat/view/screen/chat_screen.dart';
import 'package:texol_chat_app/features/chat/view_model/chat_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatViewModel(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final authViewModel = context.read<AuthViewModel>();
    authViewModel.initLocal().then((value) => authViewModel.autoLoginCheck());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.liteThemeMode,
      home: Selector<AuthViewModel, bool>(
        selector: (p0, p1) => p1.isLoggedIn,
        builder: (context, isLoggedIn, _) {
          if (isLoggedIn) {
            return const ChatScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
