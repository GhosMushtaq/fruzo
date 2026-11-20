import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class UserNavController extends GetxController {
  final selectedIndex = 0.obs;
  void changePage(int index) => selectedIndex.value = index;
  void backToLogin() => Get.offAllNamed(AppRoutes.roleSelection);
}
