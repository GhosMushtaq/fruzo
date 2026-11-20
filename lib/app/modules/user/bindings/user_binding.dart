import 'package:get/get.dart';
import '../../shared/controllers/items_sync_controller.dart';
import '../../shared/controllers/orders_sync_controller.dart';
import '../controllers/user_nav_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/my_orders_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ItemsSyncController>()) {
      Get.put<ItemsSyncController>(ItemsSyncController(), permanent: true);
    }
    if (!Get.isRegistered<OrdersSyncController>()) {
      Get.put<OrdersSyncController>(OrdersSyncController(), permanent: true);
    }
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
    }
    Get.lazyPut<UserNavController>(() => UserNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MyOrdersController>(() => MyOrdersController());
  }
}
