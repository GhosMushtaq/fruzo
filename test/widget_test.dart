import 'package:flutter_test/flutter_test.dart';
import 'package:fruzo/app/data/models/item_model.dart';
import 'package:fruzo/app/data/models/cart_item_model.dart';
import 'package:fruzo/app/data/models/order_model.dart';
import 'package:fruzo/app/data/models/order_item_model.dart';

void main() {
  group('Fruzo Unit Tests', () {
    test('ItemModel serialization and copyWith', () {
      final item = ItemModel(
        id: 1,
        name: 'Mango Delight Cup',
        price: 120.0,
        description: 'Fresh mango cup',
        category: 'Cup',
        imagePath: 'assets/images/item_mango_cup.jpg',
        isAsset: true,
      );

      final map = item.toMap();
      expect(map['id'], 1);
      expect(map['name'], 'Mango Delight Cup');
      expect(map['price'], 120.0);

      final fromMap = ItemModel.fromMap(map);
      expect(fromMap.name, item.name);
      expect(fromMap.price, item.price);

      final updated = item.copyWith(price: 130.0);
      expect(updated.price, 130.0);
      expect(updated.name, item.name);
    });

    test('CartItemModel subtotal calculation', () {
      final item = ItemModel(
        id: 2,
        name: 'Strawberry Dream',
        price: 150.0,
        imagePath: 'assets/images/item_strawberry_cup.jpg',
      );

      final cartItem = CartItemModel(item: item, quantity: 3);
      expect(cartItem.subtotal, 450.0);
    });

    test('OrderModel serialization', () {
      final items = [
        const OrderItemModel(
          id: 1,
          orderId: 10,
          itemName: 'Mixed Fruit Bowl',
          price: 180.0,
          quantity: 2,
        ),
      ];

      final order = OrderModel(
        id: 10,
        customerName: 'Test Customer',
        phone: '01700000000',
        totalPrice: 360.0,
        status: 'pending',
        createdAt: '2026-11-20T03:00:00Z',
        items: items,
      );

      final map = order.toMap();
      expect(map['customerName'], 'Test Customer');
      expect(map['totalPrice'], 360.0);
      expect(map['status'], 'pending');

      final fromMap = OrderModel.fromMap(map, items: items);
      expect(fromMap.items.length, 1);
      expect(fromMap.items.first.itemName, 'Mixed Fruit Bowl');
    });
  });
}
