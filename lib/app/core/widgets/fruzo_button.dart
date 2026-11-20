import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

enum FruzoButtonVariant { filled, outline }

class FruzoButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final FruzoButtonVariant variant;
  final IconData? icon;
  const FruzoButton({super.key, required this.label, this.onTap, this.isLoading = false, this.variant = FruzoButtonVariant.filled, this.icon});

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
            Text(label, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
          ]);
    if (variant == FruzoButtonVariant.outline) {
      return SizedBox(width: double.infinity, height: 52,
        child: OutlinedButton(onPressed: isLoading ? null : onTap,
          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryOrange, width: 2), foregroundColor: AppColors.primaryOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: child));
    }
    return SizedBox(width: double.infinity, height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.primaryOrange.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))]),
        child: ElevatedButton(onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: child)));
  }
}
