import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texol_chat_app/core/theme/app_pallete.dart';
import 'package:texol_chat_app/core/widgets/custom_field.dart';
import 'package:texol_chat_app/features/auth/view_model/auth_view_model.dart';
import 'package:texol_chat_app/features/chat/view/screen/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    } else if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = context.read<AuthViewModel>();
      await authViewModel.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (authViewModel.isLoggedIn && context.mounted) {
        _passwordController.clear();
        _usernameController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const ChatScreen();
            },
          ),
        );
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login.',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                CustomField(
                  controller: _usernameController,
                  hintText: 'Username',
                  validator: _validateUsername,
                  onChanged: (p0) {
                    if (_passwordController.text.isNotEmpty &&
                        _usernameController.text.isNotEmpty) {
                      _formKey.currentState?.validate();
                    }
                  },
                ),
                const SizedBox(height: 20),
                CustomField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isObscureText: true,
                  validator: _validatePassword,
                  onChanged: (p0) {
                    if (_passwordController.text.isNotEmpty &&
                        _usernameController.text.isNotEmpty) {
                      _formKey.currentState?.validate();
                    }
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Pallete.gradient1,
                        Pallete.gradient2,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Selector<AuthViewModel, bool>(
                    selector: (p0, p1) => p1.isLoading,
                    builder: (context, isLoading, _) {
                      return ElevatedButton(
                        onPressed:
                            isLoading ? null : () async => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(395, 55),
                          backgroundColor: Pallete.transparentColor,
                          shadowColor: Pallete.transparentColor,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Selector<AuthViewModel, String>(
                  selector: (p0, p1) => p1.errorMessage,
                  builder: (context, value, child) {
                    return Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Pallete.errorColor,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
