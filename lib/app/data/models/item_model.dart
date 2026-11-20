class ItemModel {
  final int? id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String imagePath;
  final bool isAsset;

  const ItemModel({
    this.id,
    required this.name,
    required this.price,
    this.description = '',
    this.category = 'Cup',
    required this.imagePath,
    this.isAsset = true,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'price': price,
        'description': description,
        'category': category,
        'imagePath': imagePath,
        'isAsset': isAsset ? 1 : 0,
      };

  factory ItemModel.fromMap(Map<String, dynamic> map) => ItemModel(
        id: map['id'] as int?,
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        description: map['description'] as String? ?? '',
        category: map['category'] as String? ?? 'Cup',
        imagePath: map['imagePath'] as String? ?? '',
        isAsset: (map['isAsset'] as int? ?? 1) == 1,
      );

  ItemModel copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? category,
    String? imagePath,
    bool? isAsset,
  }) =>
      ItemModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        description: description ?? this.description,
        category: category ?? this.category,
        imagePath: imagePath ?? this.imagePath,
        isAsset: isAsset ?? this.isAsset,
      );
}
