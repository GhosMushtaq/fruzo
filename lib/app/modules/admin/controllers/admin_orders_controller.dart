import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../shared/controllers/orders_sync_controller.dart';
import '../../../core/constants/app_constants.dart';

class AdminOrdersController extends GetxController {
  final _sync = Get.find<OrdersSyncController>();
  final filterStatus = 'All'.obs;
  final filters = ['All', 'Pending', 'Accepted', 'Rejected'];

  RxList<OrderModel> get orders => _sync.allOrders;
  RxBool get isLoading => _sync.isLoading;

  List<OrderModel> get filteredOrders {
    if (filterStatus.value == 'All') return orders;
    return orders
        .where((o) => o.status.toLowerCase() == filterStatus.value.toLowerCase())
        .toList();
  }

  Future<void> acceptOrder(int orderId) async {
    try {
      await _sync.updateStatus(orderId, 'accepted');
      Get.snackbar(
        'Order Accepted ✅',
        'Order #$orderId has been marked as Accepted',
        backgroundColor: AppColors.leafGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not accept order: $e',
        backgroundColor: AppColors.strawberryRed,
        colorText: Colors.white,
      );
    }
  }

  Future<void> rejectOrder(int orderId) async {
    try {
      await _sync.updateStatus(orderId, 'rejected');
      Get.snackbar(
        'Order Rejected',
        'Order #$orderId has been marked as Rejected',
        backgroundColor: AppColors.strawberryRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not reject order: $e',
        backgroundColor: AppColors.strawberryRed,
        colorText: Colors.white,
      );
    }
  }

  void setFilter(String f) => filterStatus.value = f;
  Future<void> refreshOrders() => _sync.loadOrders();
}
