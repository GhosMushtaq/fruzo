import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/fruzo_button.dart';
import '../../../data/repositories/auth_repository.dart';

class AdminNavController extends GetxController {
  final selectedIndex = 0.obs;
  final _auth = AuthRepository();

  void changePage(int index) => selectedIndex.value = index;
  void logout() => Get.offAllNamed('/role-selection');

  void showChangeCredentialsDialog(BuildContext context) {
    final userController = TextEditingController(text: _auth.currentUsername);
    final passController = TextEditingController(text: _auth.currentPassword);
    final confirmPassController = TextEditingController(text: _auth.currentPassword);
    final formKey = GlobalKey<FormState>();
    final obscurePass = true.obs;
    final obscureConfirm = true.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.manage_accounts_rounded,
                        color: AppColors.primaryOrange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin Account',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepCharcoal,
                            ),
                          ),
                          Text(
                            'Change username & password',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: AppColors.mutedGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 18),

                // Username Field
                Text(
                  'Username',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: userController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_rounded, color: AppColors.primaryOrange, size: 20),
                    hintText: 'Enter new username',
                    filled: true,
                    fillColor: AppColors.creamBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Username cannot be empty';
                    if (v.trim().length < 3) return 'At least 3 characters required';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Password Field
                Text(
                  'New Password',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const SizedBox(height: 6),
                Obx(
                  () => TextFormField(
                    controller: passController,
                    obscureText: obscurePass.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.primaryOrange, size: 20),
                      hintText: 'Enter new password',
                      filled: true,
                      fillColor: AppColors.creamBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePass.value ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          size: 20,
                          color: AppColors.mutedGrey,
                        ),
                        onPressed: obscurePass.toggle,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Password cannot be empty';
                      if (v.trim().length < 4) return 'At least 4 characters required';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 14),

                // Confirm Password Field
                Text(
                  'Confirm Password',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const SizedBox(height: 6),
                Obx(
                  () => TextFormField(
                    controller: confirmPassController,
                    obscureText: obscureConfirm.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryOrange, size: 20),
                      hintText: 'Confirm new password',
                      filled: true,
                      fillColor: AppColors.creamBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirm.value ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          size: 20,
                          color: AppColors.mutedGrey,
                        ),
                        onPressed: obscureConfirm.toggle,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Please confirm your password';
                      if (v != passController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 22),

                // Save Button
                FruzoButton(
                  label: 'SAVE CREDENTIALS',
                  icon: Icons.check_circle_rounded,
                  onTap: () {
                    if (!formKey.currentState!.validate()) return;
                    _auth.updateCredentials(
                      newUsername: userController.text.trim(),
                      newPassword: passController.text.trim(),
                    );
                    Get.back();
                    Get.snackbar(
                      'Credentials Updated',
                      'Your admin username and password have been updated successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.leafGreen,
                      colorText: Colors.white,
                      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 3),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
