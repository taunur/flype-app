import 'package:flutter/material.dart';
import 'package:flype/data/api/auth_service.dart';
import 'package:flype/data/db/auth_repository.dart';
import 'package:flype/data/model/user_model.dart';
import 'package:logger/logger.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  final Logger logger = Logger();
  late UserModel _user = UserModel();
  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      final UserModel user = await AuthServices().login(
        email: email,
        password: password,
      );
      if (user.token != null && user.token!.isNotEmpty) {
        // Simpan status login dan informasi pengguna ke SharedPreferences
        await authRepository.login();
        await authRepository.saveUser(user);

        _user = user;
        notifyListeners();
        return true;
      } else {
        logger.e('Token is empty after login.');
        return false;
      }
    } catch (e) {
      logger.e('Error login user: $e');
      return false;
    } finally {
      isLoadingLogin = false;
      notifyListeners();
    }
  }

  // register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoadingRegister = true;
    notifyListeners();

    try {
      AuthModel authModel = await AuthServices().register(
        name: name,
        email: email,
        password: password,
      );

      _user = authModel.loginResult;
      notifyListeners();
      return true;
    } catch (e) {
      logger.e('Error registering user: $e');
      return false;
    } finally {
      isLoadingLogin = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }
}
