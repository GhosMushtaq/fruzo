import 'order_item_model.dart';

class OrderModel {
  final int? id;
  final String customerName;
  final String phone;
  final double totalPrice;
  final String status;
  final String createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    this.id,
    required this.customerName,
    this.phone = '',
    required this.totalPrice,
    this.status = 'pending',
    required this.createdAt,
    this.items = const [],
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'customerName': customerName,
        'phone': phone,
        'totalPrice': totalPrice,
        'status': status,
        'createdAt': createdAt,
      };

  factory OrderModel.fromMap(Map<String, dynamic> map, {List<OrderItemModel>? items}) =>
      OrderModel(
        id: map['id'] as int?,
        customerName: map['customerName'] as String,
        phone: map['phone'] as String? ?? '',
        totalPrice: (map['totalPrice'] as num).toDouble(),
        status: map['status'] as String? ?? 'pending',
        createdAt: map['createdAt'] as String,
        items: items ?? [],
      );

  OrderModel copyWith({String? status}) => OrderModel(
        id: id,
        customerName: customerName,
        phone: phone,
        totalPrice: totalPrice,
        status: status ?? this.status,
        createdAt: createdAt,
        items: items,
      );
}
