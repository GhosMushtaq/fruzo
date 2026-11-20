import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_nav_controller.dart';
import '../../../core/widgets/floating_nav_bar.dart';
import 'manage_items_view.dart';
import 'admin_orders_view.dart';

class AdminShellView extends GetView<AdminNavController> {
  const AdminShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            ManageItemsView(),
            AdminOrdersView(),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Obx(
        () => FloatingNavBar(
          selectedIndex: controller.selectedIndex.value,
          onTap: controller.changePage,
          items: const [
            NavItem(icon: Icons.inventory_2_rounded, label: 'Items'),
            NavItem(icon: Icons.receipt_long_rounded, label: 'Orders'),
          ],
        ),
      ),
    );
  }
}
