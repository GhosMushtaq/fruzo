import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Get.offAllNamed(AppRoutes.roleSelection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rounded Official Logo
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.85),
                      width: 3.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.4, 0.4),
                      end: const Offset(1.0, 1.0),
                      duration: 850.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 600.ms),

                const SizedBox(height: 28),

                // App Name
                Text(
                  AppStrings.appName,
                  style: GoogleFonts.poppins(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                )
                    .animate()
                    .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 350.ms, curve: Curves.easeOut)
                    .fadeIn(duration: 600.ms, delay: 350.ms),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  AppStrings.tagline,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                )
                    .animate()
                    .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 550.ms, curve: Curves.easeOut)
                    .fadeIn(duration: 600.ms, delay: 550.ms),

                const SizedBox(height: 56),

                // Animated loading dots
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (i) => Container(
                      width: 9,
                      height: 9,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .scaleXY(begin: 0.6, end: 1.1, duration: 600.ms, delay: (i * 200).ms, curve: Curves.easeInOut)
                        .then()
                        .scaleXY(begin: 1.1, end: 0.6, duration: 600.ms, curve: Curves.easeInOut),
                  ),
                ).animate().fadeIn(delay: 850.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
