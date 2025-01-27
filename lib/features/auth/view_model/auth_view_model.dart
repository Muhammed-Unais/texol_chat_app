import 'package:flutter/material.dart';
import 'package:texol_chat_app/features/auth/repo/auth_local_repositoy.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthLocalRepositoy _authLocalRepositoy = AuthLocalRepositoy();

  bool isLoading = false;
  String errorMessage = '';
  bool _isLoggedIn = false;
  String? userName;

  bool get isLoggedIn => _isLoggedIn;

  void setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  Future<void> initLocal() async {
    await _authLocalRepositoy.init();
  }

  Future<void> login(String username, String password) async {
    try {
      setLoading(true);
      await _authLocalRepositoy.setData(userName: username, password: password);
      _isLoggedIn = true;
      userName = username;
    } catch (e) {
      errorMessage = 'Something went wrong.';
    } finally {
      setLoading(false);
    }
  }

  Future<void> autoLoginCheck() async {
    _isLoggedIn = _authLocalRepositoy.getData().$1;
    userName = _authLocalRepositoy.getData().$2;
    notifyListeners();
  }
}
