import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/order_item_model.dart';
import '../../shared/controllers/orders_sync_controller.dart';
import '../../../routes/app_routes.dart';

class CartController extends GetxController {
  final cartItems = <CartItemModel>[].obs;
  final customerName = ''.obs;
  final lastOrderId = 0.obs;

  int get itemCount => cartItems.fold(0, (sum, ci) => sum + ci.quantity);
  double get total => cartItems.fold(0.0, (sum, ci) => sum + ci.subtotal);

  bool isInCart(int itemId) => cartItems.any((ci) => ci.item.id == itemId);

  void addItem(ItemModel item) {
    final idx = cartItems.indexWhere((ci) => ci.item.id == item.id);
    if (idx >= 0) {
      cartItems[idx].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(item: item));
    }
    Get.snackbar('Added! 🛒', '${item.name} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF2DC653),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2));
  }

  void increment(CartItemModel ci) {
    ci.quantity++;
    cartItems.refresh();
  }

  void decrement(CartItemModel ci) {
    if (ci.quantity > 1) {
      ci.quantity--;
      cartItems.refresh();
    } else {
      cartItems.remove(ci);
    }
  }

  void removeItem(CartItemModel ci) => cartItems.remove(ci);

  void clearCart() => cartItems.clear();

  Future<void> placeOrder(String name, String phone) async {
    if (cartItems.isEmpty) return;
    final sync = Get.find<OrdersSyncController>();
    final order = OrderModel(
      customerName: name,
      phone: phone,
      totalPrice: total,
      status: 'pending',
      createdAt: DateTime.now().toIso8601String(),
    );
    final items = cartItems.map((ci) => OrderItemModel(
      orderId: 0,
      itemName: ci.item.name,
      price: ci.item.price,
      quantity: ci.quantity,
    )).toList();
    final orderId = await sync.placeOrder(order, items);
    customerName.value = name;
    lastOrderId.value = orderId;
    clearCart();
    Get.offNamed(AppRoutes.orderSuccess, arguments: {'orderId': orderId, 'customerName': name});
  }
}
