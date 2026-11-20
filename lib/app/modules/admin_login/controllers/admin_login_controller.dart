import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class AdminLoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePassword = true.obs;

  void togglePassword() => obscurePassword.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    errorMessage.value = '';
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    final ok = _auth.login(usernameController.text.trim(), passwordController.text.trim());
    isLoading.value = false;
    if (ok) {
      Get.offNamed(AppRoutes.admin);
    } else {
      errorMessage.value = 'Invalid username or password. Please try again.';
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
