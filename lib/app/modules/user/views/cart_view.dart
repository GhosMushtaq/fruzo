import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/user_nav_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/fruzo_button.dart';
import '../../../core/widgets/fruzo_image.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/cart_item_model.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CartController>();
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () => Get.find<UserNavController>().changePage(0),
        ),
        title: Obx(
          () => Text(
            'My Cart (${c.itemCount})',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Obx(() {
        if (c.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 75, color: AppColors.mutedGrey),
                const SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore our fresh fruit cups and bowls!',
                  style: GoogleFonts.nunito(fontSize: 14, color: AppColors.mutedGrey),
                ),
              ],
            ).animate().fadeIn(),
          );
        }

        return Column(
          children: [
            // Cart Items Scrollable List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                itemCount: c.cartItems.length,
                itemBuilder: (_, i) => _CartTile(ci: c.cartItems[i], controller: c)
                    .animate()
                    .fadeIn(delay: (i * 40).ms)
                    .slideX(begin: -0.08, end: 0, delay: (i * 40).ms),
              ),
            ),

            // Summary Card (Padded at bottom to sit clear of FloatingNavBar)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 95),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text('Subtotal', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.mutedGrey)),
                      const Spacer(),
                      Text(
                        Helpers.formatPrice(c.total),
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Delivery Fee', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.mutedGrey)),
                      const Spacer(),
                      Text(
                        'Free 🎉',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: AppColors.leafGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 18),
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        Helpers.formatPrice(c.total),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  FruzoButton(
                    label: 'Place Order →',
                    onTap: () => _showOrderDialog(context, c),
                    icon: Icons.check_circle_rounded,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showOrderDialog(BuildContext context, CartController c) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isLoading = false.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.softPeach,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Complete Your Order ✓',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Your Full Name *',
                    prefixIcon: Icon(Icons.person_rounded, color: AppColors.primaryOrange),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Phone Number (optional)',
                    prefixIcon: Icon(Icons.phone_rounded, color: AppColors.primaryOrange),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => FruzoButton(
                    label: 'Confirm Order ✓',
                    isLoading: isLoading.value,
                    onTap: () async {
                      if (!formKey.currentState!.validate()) return;
                      isLoading.value = true;
                      await c.placeOrder(nameCtrl.text.trim(), phoneCtrl.text.trim());
                      isLoading.value = false;
                    },
                    icon: Icons.check_rounded,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItemModel ci;
  final CartController controller;
  const _CartTile({required this.ci, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 60,
              height: 60,
              child: FruzoImage(
                imagePath: ci.item.imagePath,
                isAsset: ci.item.isAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Details & Quantity Stepper
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ci.item.name,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Helpers.formatPrice(ci.item.price),
                  style: GoogleFonts.nunito(fontSize: 12, color: AppColors.mutedGrey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _QtyBtn(icon: Icons.remove_rounded, onTap: () => controller.decrement(ci)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${ci.quantity}',
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                    _QtyBtn(icon: Icons.add_rounded, onTap: () => controller.increment(ci)),
                  ],
                ),
              ],
            ),
          ),

          // Subtotal & Remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Helpers.formatPrice(ci.subtotal),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => controller.removeItem(ci),
                child: const Icon(Icons.delete_outline_rounded, color: AppColors.strawberryRed, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.softPeach,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryOrange),
        ),
      );
}
