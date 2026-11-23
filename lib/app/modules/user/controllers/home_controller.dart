import 'package:get/get.dart';
import '../../../data/models/item_model.dart';
import '../../shared/controllers/items_sync_controller.dart';

class HomeController extends GetxController {
  final _sync = Get.find<ItemsSyncController>();

  RxList<ItemModel> get items => _sync.items;
  RxBool get isLoading => _sync.isLoading;

  final banners = [
    {'image': 'assets/images/banner_1.jpg', 'title': '🍉 Summer Deals!', 'subtitle': 'Up to 20% off on all cups', 'cta': 'Shop Now'},
    {'image': 'assets/images/banner_2.jpg', 'title': '🍓 Fresh Daily', 'subtitle': 'Hand-picked fruits every morning', 'cta': 'Explore'},
    {'image': 'assets/images/banner_3.jpg', 'title': '🥭 New Arrival', 'subtitle': 'Pistachio & Mango Delight', 'cta': 'Try Now'},
  ];
}
