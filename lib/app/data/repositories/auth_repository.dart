import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  factory AuthRepository() => _instance;
  AuthRepository._internal();

  final RxString _username = AppStrings.adminUsername.obs;
  final RxString _password = AppStrings.adminPassword.obs;

  String get currentUsername => _username.value;
  String get currentPassword => _password.value;
  RxString get rxUsername => _username;
  RxString get rxPassword => _password;

  bool login(String u, String p) => u == _username.value && p == _password.value;

  void updateCredentials({required String newUsername, required String newPassword}) {
    _username.value = newUsername.trim();
    _password.value = newPassword.trim();
  }
}
