import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/admin_login_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/fruzo_button.dart';
import '../../../data/repositories/auth_repository.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _panAnimation;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.05, end: 1.20).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );
    _panAnimation = Tween<Offset>(
      begin: const Offset(10, -10),
      end: const Offset(-10, 10),
    ).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminLoginController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. ANIMATED FRUIT BACKGROUND
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Transform.translate(
                  offset: _panAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/banner_2.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // 2. FROSTED GLASS & DARK GRADIENT OVERLAY
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.black.withOpacity(0.50),
                      Colors.black.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. TOP BACK BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                    tooltip: 'Back',
                  ),
                ),
              ),
            ),
          ),

          // 4. LOGIN FORM CONTAINER
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shield Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryOrange.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.admin_panel_settings_rounded, size: 44, color: Colors.white),
                        ).animate().scale(begin: const Offset(0.7, 0.7), duration: 500.ms, curve: Curves.elasticOut),

                        const SizedBox(height: 20),

                        Text(
                          'Admin Portal 🔐',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepCharcoal,
                          ),
                        ).animate().fadeIn(delay: 200.ms),

                        const SizedBox(height: 6),

                        Text(
                          'Sign in to manage Fruzo store',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedGrey,
                          ),
                        ).animate().fadeIn(delay: 300.ms),

                        const SizedBox(height: 28),

                        // Username field
                        TextFormField(
                          controller: controller.usernameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_rounded, color: AppColors.primaryOrange),
                            hintText: 'Username',
                            filled: true,
                            fillColor: AppColors.creamBg,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Username is required' : null,
                        ).animate().slideY(begin: 0.2, end: 0, delay: 350.ms, duration: 400.ms).fadeIn(delay: 350.ms),

                        const SizedBox(height: 16),

                        // Password field
                        Obx(
                          () => TextFormField(
                            controller: controller.passwordController,
                            obscureText: controller.obscurePassword.value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.primaryOrange),
                              hintText: 'Password',
                              filled: true,
                              fillColor: AppColors.creamBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: AppColors.mutedGrey,
                                ),
                                onPressed: controller.togglePassword,
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Password is required' : null,
                          ),
                        ).animate().slideY(begin: 0.2, end: 0, delay: 450.ms, duration: 400.ms).fadeIn(delay: 450.ms),

                        const SizedBox(height: 12),

                        // Error message
                        Obx(() => controller.errorMessage.value.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.strawberryRed.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline_rounded, color: AppColors.strawberryRed, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        controller.errorMessage.value,
                                        style: GoogleFonts.nunito(
                                          color: AppColors.strawberryRed,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().shake()
                            : const SizedBox.shrink()),

                        const SizedBox(height: 24),

                        // Login Button
                        Obx(
                          () => FruzoButton(
                            label: 'SIGN IN TO DASHBOARD',
                            isLoading: controller.isLoading.value,
                            onTap: controller.login,
                            icon: Icons.login_rounded,
                          ),
                        ).animate().slideY(begin: 0.2, end: 0, delay: 550.ms, duration: 400.ms).fadeIn(delay: 550.ms),

                        const SizedBox(height: 16),

                        Obx(
                          () {
                            final auth = AuthRepository();
                            // read reactive values so Obx tracks them
                            final u = auth.rxUsername.value;
                            final p = auth.rxPassword.value;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.softPeach.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Current Login: $u / $p',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
