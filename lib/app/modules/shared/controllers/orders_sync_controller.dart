import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/order_item_model.dart';
import '../../../data/repositories/order_repository.dart';

class OrdersSyncController extends GetxController {
  final _repo = OrderRepository();
  final allOrders = <OrderModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() { super.onInit(); loadOrders(); }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try { allOrders.assignAll(await _repo.getAllOrders()); }
    finally { isLoading.value = false; }
  }

  Future<int> placeOrder(OrderModel order, List<OrderItemModel> items) async {
    final id = await _repo.insertOrder(order, items);
    await loadOrders();
    return id;
  }

  Future<void> updateStatus(int orderId, String status) async {
    await _repo.updateOrderStatus(orderId, status);
    await loadOrders();
  }
}
