import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalRepositoy {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setData({
    required String userName,
    required String password,
  }) async {
    await _sharedPreferences.setString('userName', userName);
    await _sharedPreferences.setBool('isLoggedIn', true);
  }

  bool getData() {
    return _sharedPreferences.getBool('isLoggedIn') ?? false;
  }
}
