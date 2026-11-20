import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/user_nav_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../routes/app_routes.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final orderId = args?['orderId'] ?? 0;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.successGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                // Success icon
                Container(width: 120, height: 120,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.4), width: 3)),
                  child: const Icon(Icons.check_circle_rounded, size: 72, color: Colors.white))
                    .animate()
                    .scale(begin: const Offset(0.3, 0.3), duration: 700.ms, curve: Curves.elasticOut)
                    .fadeIn(duration: 500.ms),
                const SizedBox(height: 32),
                Text('Order Placed! 🎉', style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white))
                    .animate().slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 500.ms).fadeIn(delay: 400.ms),
                const SizedBox(height: 12),
                Text("We're preparing your\nfresh fruit cups 🍓", textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(fontSize: 16, color: Colors.white.withOpacity(0.9), height: 1.5))
                    .animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 20),
                // Order badge
                Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3))),
                  child: Text('Order #$orderId', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)))
                    .animate().scale(begin: const Offset(0.8, 0.8), delay: 800.ms, duration: 400.ms).fadeIn(delay: 800.ms),
                const SizedBox(height: 48),
                // Buttons
                ElevatedButton.icon(
                  onPressed: () => Get.offNamedUntil(AppRoutes.user, (r) => false),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Back to Home'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.leafGreen,
                    minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ).animate().slideY(begin: 0.3, end: 0, delay: 1000.ms).fadeIn(delay: 1000.ms),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Get.offNamedUntil(AppRoutes.user, (r) => false);
                    if (Get.isRegistered<UserNavController>()) {
                      Get.find<UserNavController>().changePage(2);
                    }
                  },
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: const Text('Track My Order'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white, width: 2),
                    minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ).animate().slideY(begin: 0.3, end: 0, delay: 1100.ms).fadeIn(delay: 1100.ms),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

