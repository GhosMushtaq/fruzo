import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/fruzo_button.dart';
import '../../../core/widgets/fruzo_image.dart';
import '../../../data/models/item_model.dart';
import '../../../core/utils/helpers.dart';

class ItemDetailView extends StatefulWidget {
  const ItemDetailView({super.key});
  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final item = Get.arguments as ItemModel;
    final cart = Get.find<CartController>();
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Get.back()),
        title: Text('Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        actions: [
          Obx(() => Stack(children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {},
            ),
            if (cart.itemCount > 0) Positioned(top: 8, right: 8,
              child: Container(width: 16, height: 16,
                decoration: const BoxDecoration(color: AppColors.strawberryRed, shape: BoxShape.circle),
                child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700), textAlign: TextAlign.center))),
          ])),
        ],
      ),
      body: Column(
        children: [
          // Hero image
          Hero(
            tag: 'item_${item.id}',
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: SizedBox(
                height: 280,
                width: double.infinity,
                child: FruzoImage(
                  imagePath: item.imagePath,
                  isAsset: item.isAsset,
                  fit: BoxFit.cover,
                  placeholder: _ph(),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.softPeach, borderRadius: BorderRadius.circular(20)),
                      child: Text(item.category, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.primaryOrange, fontWeight: FontWeight.w600))),
                    const Spacer(),
                    Text(Helpers.formatPrice(item.price), style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primaryOrange)),
                  ]).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 10),
                  Text(item.name, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal))
                      .animate().slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 100.ms),
                  const SizedBox(height: 8),
                  const Row(children: [
                    Icon(Icons.eco_rounded, size: 16, color: Color(0xFF2DC653)),
                    SizedBox(width: 4),
                    Text('Fresh'),
                    SizedBox(width: 12),
                    Icon(Icons.local_dining_rounded, size: 16, color: Color(0xFFFF6B2C)),
                    SizedBox(width: 4),
                    Text('Handmade'),
                    SizedBox(width: 12),
                    Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB703)),
                    SizedBox(width: 4),
                    Text('Premium'),
                  ]).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 16),
                  if (item.description.isNotEmpty) ...[
                    Text('About', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal)),
                    const SizedBox(height: 6),
                    Text(item.description, style: GoogleFonts.nunito(fontSize: 14, color: AppColors.mutedGrey, height: 1.6))
                        .animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 20),
                  ],
                  // Quantity
                  Row(children: [
                    Text('Quantity:', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    _QtyButton(icon: Icons.remove_rounded, onTap: () { if (_qty > 1) setState(() => _qty--); }),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedSwitcher(duration: const Duration(milliseconds: 200),
                        child: Text('$_qty', key: ValueKey(_qty), style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal)))),
                    _QtyButton(icon: Icons.add_rounded, onTap: () => setState(() => _qty++)),
                  ]).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: FruzoButton(
              label: 'Add to Cart  •  ${Helpers.formatPrice(item.price * _qty)}',
              icon: Icons.shopping_cart_rounded,
              onTap: () {
                for (var i = 0; i < _qty; i++) {
                  cart.addItem(item);
                }
                Get.back();
              },
            ).animate().slideY(begin: 0.3, end: 0, duration: 400.ms, delay: 600.ms),
          ),
        ],
      ),
    );
  }

  Widget _ph() => Container(
    decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
    child: const Icon(Icons.local_dining_rounded, size: 80, color: Colors.white));
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 36, height: 36,
      decoration: const BoxDecoration(color: AppColors.softPeach, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.primaryOrange, size: 20)));
}
