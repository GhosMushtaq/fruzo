import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_nav_controller.dart';
import '../controllers/cart_controller.dart';
import '../../../core/widgets/floating_nav_bar.dart';
import 'home_view.dart';
import 'cart_view.dart';
import 'my_orders_view.dart';

class UserShellView extends GetView<UserNavController> {
  const UserShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeView(),
            CartView(),
            MyOrdersView(),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Obx(() {
        final cartCount = Get.find<CartController>().itemCount;
        return FloatingNavBar(
          selectedIndex: controller.selectedIndex.value,
          onTap: controller.changePage,
          items: [
            const NavItem(icon: Icons.home_rounded, label: 'Home'),
            NavItem(icon: Icons.shopping_cart_rounded, label: 'Cart', badgeCount: cartCount),
            const NavItem(icon: Icons.receipt_long_rounded, label: 'Orders'),
          ],
        );
      }),
    );
  }
}
