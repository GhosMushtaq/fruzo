import 'package:get/get.dart';
import '../../../data/models/item_model.dart';
import '../../../data/repositories/item_repository.dart';

class ItemsSyncController extends GetxController {
  final _repo = ItemRepository();
  final items = <ItemModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() { super.onInit(); loadItems(); }

  Future<void> loadItems() async {
    isLoading.value = true;
    try { items.assignAll(await _repo.getAllItems()); }
    finally { isLoading.value = false; }
  }

  Future<void> addItem(ItemModel item) async { await _repo.insertItem(item); await loadItems(); }
  Future<void> updateItem(ItemModel item) async { await _repo.updateItem(item); await loadItems(); }
  Future<void> deleteItem(int id) async { await _repo.deleteItem(id); await loadItems(); }
}
