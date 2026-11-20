import 'package:get/get.dart';
import '../../shared/controllers/items_sync_controller.dart';
import '../../shared/controllers/orders_sync_controller.dart';
import '../controllers/admin_nav_controller.dart';
import '../controllers/manage_items_controller.dart';
import '../controllers/admin_orders_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ItemsSyncController>()) {
      Get.put<ItemsSyncController>(ItemsSyncController(), permanent: true);
    }
    if (!Get.isRegistered<OrdersSyncController>()) {
      Get.put<OrdersSyncController>(OrdersSyncController(), permanent: true);
    }
    Get.lazyPut<AdminNavController>(() => AdminNavController());
    Get.lazyPut<ManageItemsController>(() => ManageItemsController());
    Get.lazyPut<AdminOrdersController>(() => AdminOrdersController());
  }
}
