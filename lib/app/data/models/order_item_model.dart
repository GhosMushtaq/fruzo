class OrderItemModel {
  final int? id;
  final int orderId;
  final String itemName;
  final double price;
  final int quantity;

  const OrderItemModel({
    this.id,
    required this.orderId,
    required this.itemName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'orderId': orderId,
        'itemName': itemName,
        'price': price,
        'quantity': quantity,
      };

  factory OrderItemModel.fromMap(Map<String, dynamic> map) => OrderItemModel(
        id: map['id'] as int?,
        orderId: map['orderId'] as int,
        itemName: map['itemName'] as String,
        price: (map['price'] as num).toDouble(),
        quantity: map['quantity'] as int,
      );
}
