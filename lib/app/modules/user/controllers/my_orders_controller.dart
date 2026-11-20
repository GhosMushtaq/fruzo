import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../shared/controllers/orders_sync_controller.dart';
import '../controllers/cart_controller.dart';

class MyOrdersController extends GetxController {
  final _sync = Get.find<OrdersSyncController>();
  // ignore: unused_field
  final _cart = Get.find<CartController>();

  /// Show all orders so users can always track their orders.
  /// The list is reactive because _sync.allOrders is an RxList.
  RxList<OrderModel> get myOrders => _sync.allOrders;

  RxBool get isLoading => _sync.isLoading;
}
