import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;
    final IconData icon;
    switch (status.toLowerCase()) {
      case 'accepted':
        bg = AppColors.leafGreen; fg = Colors.white; label = 'ACCEPTED'; icon = Icons.check_circle_rounded;
        break;
      case 'rejected':
        bg = AppColors.strawberryRed; fg = Colors.white; label = 'REJECTED'; icon = Icons.cancel_rounded;
        break;
      default:
        bg = AppColors.mangoYellow; fg = AppColors.deepCharcoal; label = 'PENDING'; icon = Icons.schedule_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: fg),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: fg, letterSpacing: 0.5)),
      ]),
    );
  }
}
