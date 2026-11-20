import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/role_selection/bindings/role_selection_binding.dart';
import '../modules/role_selection/views/role_selection_view.dart';
import '../modules/admin_login/bindings/admin_login_binding.dart';
import '../modules/admin_login/views/admin_login_view.dart';
import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_shell_view.dart';
import '../modules/user/bindings/user_binding.dart';
import '../modules/user/views/user_shell_view.dart';
import '../modules/user/views/item_detail_view.dart';
import '../modules/user/views/order_success_view.dart';

class AppPages {
  static const initial = AppRoutes.splash;
  static final routes = [
    // No binding needed — SplashView handles its own timer
    GetPage(name: AppRoutes.splash, page: () => const SplashView(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.roleSelection, page: () => const RoleSelectionView(), binding: RoleSelectionBinding(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.adminLogin, page: () => const AdminLoginView(), binding: AdminLoginBinding(), transition: Transition.rightToLeftWithFade),
    GetPage(name: AppRoutes.admin, page: () => const AdminShellView(), binding: AdminBinding(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.user, page: () => const UserShellView(), binding: UserBinding(), transition: Transition.fadeIn),
    GetPage(name: AppRoutes.itemDetail, page: () => const ItemDetailView(), transition: Transition.rightToLeftWithFade),
    GetPage(name: AppRoutes.orderSuccess, page: () => const OrderSuccessView(), transition: Transition.fadeIn),
  ];
}
