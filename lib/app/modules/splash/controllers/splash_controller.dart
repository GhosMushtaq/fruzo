import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    // onReady fires after the first frame is rendered — safer than onInit
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    Get.offAllNamed(AppRoutes.roleSelection);
  }
}
