import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/core/constants/app_constants.dart';
import 'app/core/theme/app_theme.dart';
import 'app/modules/shared/controllers/items_sync_controller.dart';
import 'app/modules/shared/controllers/orders_sync_controller.dart';
import 'app/modules/user/controllers/cart_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize permanent shared controllers
  Get.put(ItemsSyncController(), permanent: true);
  Get.put(OrdersSyncController(), permanent: true);
  Get.put(CartController(), permanent: true);

  runApp(const FruzoApp());
}

class FruzoApp extends StatelessWidget {
  const FruzoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}
