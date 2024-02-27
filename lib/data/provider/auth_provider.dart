import 'package:flutter/material.dart';
import 'package:flype/data/api/auth_service.dart';
import 'package:flype/data/db/auth_repository.dart';
import 'package:flype/data/model/user_model.dart';
import 'package:flype/data/model/user_response.dart';
import 'package:logger/logger.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  String? _authError;
  String? get authError => _authError;

  final Logger logger = Logger();
  late UserModel _user = UserModel();
  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Login
  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      final dynamic response = await AuthServices().login(
        email: email,
        password: password,
      );

      if (response is UserModel) {
        final UserModel user = response;
        if (user.token != null && user.token!.isNotEmpty) {
          /// Simpan token ke AuthRepository
          await authRepository.saveToken(user.token!);

          /// Simpan status login dan informasi pengguna ke SharedPreferences
          await authRepository.login();
          await authRepository.saveUser(user);

          /// Ambil pengguna dari AuthRepository setelah disimpan
          UserModel loggedInUser =
              await authRepository.getUser() ?? UserModel();
          _user = loggedInUser;

          notifyListeners();
          return true;
        } else {
          logger.e('Token is empty after login.');
          return false;
        }
      } else if (response is UserResponse) {
        /// Tangani respons error dari login di sini
        _authError = response.message;
        logger.e('Error login user: ${response.message}');
        return false;
      } else {
        logger.e('Unknown response type after login.');
        return false;
      }
    } catch (e) {
      _authError = 'Unknown error occurred';
      logger.e('Error login user: $e');
      return false;
    } finally {
      isLoadingLogin = false;
      notifyListeners();
    }
  }

  /// register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoadingRegister = true;
    notifyListeners();

    try {
      UserResponse registerResult = await AuthServices().register(
        name: name,
        email: email,
        password: password,
      );

      if (!registerResult.error) {
        notifyListeners();
        return true;
      } else {
        _authError = registerResult.message;
        logger.e('Registration failed: ${registerResult.message}');
        return false;
      }
    } catch (e) {
      _authError = 'Unknown error occurred';
      logger.e('Error registering user: $e');
      return false;
    } finally {
      isLoadingRegister = false;
      notifyListeners();
    }
  }

  /// Logout
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
