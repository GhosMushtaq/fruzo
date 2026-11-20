import '../models/item_model.dart';
import '../providers/database_helper.dart';

class ItemRepository {
  final _db = DatabaseHelper();

  Future<List<ItemModel>> getAllItems() async {
    final maps = await _db.queryItems();
    return maps.map(ItemModel.fromMap).toList();
  }

  Future<int> insertItem(ItemModel item) => _db.insertItem(item.toMap());

  Future<int> updateItem(ItemModel item) => _db.updateItem(item.id!, item.toMap());

  Future<int> deleteItem(int id) => _db.deleteItem(id);
}
