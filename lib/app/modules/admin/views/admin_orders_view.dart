import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/admin_orders_controller.dart';
import '../controllers/admin_nav_controller.dart';
import '../../shared/controllers/orders_sync_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/order_model.dart';
import '../../../core/utils/helpers.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminOrdersController>();
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: AppBar(
        title: const Text('Incoming Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => Get.find<OrdersSyncController>().loadOrders(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.manage_accounts_rounded),
            onPressed: () => Get.find<AdminNavController>().showChangeCredentialsDialog(context),
            tooltip: 'Account Settings',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: Get.find<AdminNavController>().logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: c.filters.map((f) {
                    final isSelected = c.filterStatus.value == f;
                    final count = f == 'All'
                        ? c.orders.length
                        : c.orders.where((o) => o.status.toLowerCase() == f.toLowerCase()).length;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text('$f ($count)'),
                        selected: isSelected,
                        onSelected: (_) => c.setFilter(f),
                        selectedColor: AppColors.primaryOrange,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.deepCharcoal,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Orders List
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryOrange),
                );
              }
              final orders = c.filteredOrders;
              if (orders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.mutedGrey),
                        const SizedBox(height: 12),
                        Text(
                          'No orders found',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepCharcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'When customers place orders, they appear here.',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: AppColors.mutedGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                itemCount: orders.length,
                itemBuilder: (_, i) => _OrderCard(order: orders[i], controller: c)
                    .animate()
                    .fadeIn(delay: (i * 50).ms)
                    .slideY(begin: 0.08, end: 0, delay: (i * 50).ms),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final AdminOrdersController controller;
  const _OrderCard({required this.order, required this.controller});

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
          // Order ID and Status
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order #${order.id}',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepCharcoal,
                  ),
                ),
              ),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 6),

          // Customer info
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 15, color: AppColors.mutedGrey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order.customerName,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepCharcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (order.phone.isNotEmpty) ...[
                const SizedBox(width: 8),
                const Icon(Icons.phone_outlined, size: 14, color: AppColors.mutedGrey),
                const SizedBox(width: 4),
                Text(
                  order.phone,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppColors.mutedGrey,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Order Items
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepCharcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '×${item.quantity}',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.mutedGrey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    Helpers.formatPrice(item.price * item.quantity),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Total & Time
          Row(
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepCharcoal,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '• ${Helpers.timeAgo(order.createdAt)}',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: AppColors.mutedGrey,
                ),
              ),
              const Spacer(),
              Text(
                Helpers.formatPrice(order.totalPrice),
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),

          // Action buttons for Pending orders
          if (order.status.toLowerCase() == 'pending') ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.acceptOrder(order.id!),
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.leafGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.rejectOrder(order.id!),
                    icon: const Icon(Icons.cancel_rounded, size: 16),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.strawberryRed,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
