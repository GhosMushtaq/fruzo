import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class RoleSelectionController extends GetxController {
  void goUser() => Get.toNamed(AppRoutes.user);
  void goAdmin() => Get.toNamed(AppRoutes.adminLogin);
}
