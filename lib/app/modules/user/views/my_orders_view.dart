import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/my_orders_controller.dart';
import '../controllers/user_nav_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/order_model.dart';
import '../../../core/utils/helpers.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () => Get.find<UserNavController>().changePage(0),
        ),
        title: Text(
          'My Orders',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
      ),
      body: Obx(() {
        final orders = controller.myOrders;
        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long_outlined, size: 75, color: AppColors.mutedGrey),
                const SizedBox(height: 16),
                Text(
                  'No orders yet!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Place an order and track its status here',
                  style: GoogleFonts.nunito(fontSize: 14, color: AppColors.mutedGrey),
                ),
              ],
            ).animate().fadeIn(),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          itemCount: orders.length,
          itemBuilder: (_, i) => _OrderCard(order: orders[i])
              .animate()
              .fadeIn(delay: (i * 50).ms)
              .slideY(begin: 0.08, end: 0, delay: (i * 50).ms),
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order #${order.id}',
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            Helpers.timeAgo(order.createdAt),
            style: GoogleFonts.nunito(fontSize: 12, color: AppColors.mutedGrey),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '×${item.quantity}',
                    style: GoogleFonts.nunito(fontSize: 13, color: AppColors.mutedGrey),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Helpers.formatPrice(item.price * item.quantity),
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Total', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(
                Helpers.formatPrice(order.totalPrice),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
