import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../providers/database_helper.dart';

class OrderRepository {
  final _db = DatabaseHelper();

  Future<List<OrderModel>> getAllOrders() async {
    final maps = await _db.queryOrders();
    final orders = <OrderModel>[];
    for (final m in maps) {
      final id = m['id'] as int;
      final itemMaps = await _db.queryOrderItems(id);
      orders.add(OrderModel.fromMap(m, items: itemMaps.map(OrderItemModel.fromMap).toList()));
    }
    return orders;
  }

  Future<List<OrderModel>> getOrdersByCustomer(String name) async {
    final maps = await _db.queryOrdersByCustomer(name);
    final orders = <OrderModel>[];
    for (final m in maps) {
      final id = m['id'] as int;
      final itemMaps = await _db.queryOrderItems(id);
      orders.add(OrderModel.fromMap(m, items: itemMaps.map(OrderItemModel.fromMap).toList()));
    }
    return orders;
  }

  Future<int> insertOrder(OrderModel order, List<OrderItemModel> items) async {
    return _db.insertOrder(
      order.toMap(),
      items.map((i) => i.toMap()).toList(),
    );
  }

  Future<int> updateOrderStatus(int orderId, String status) =>
      _db.updateOrderStatus(orderId, status);
}
