import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  // --- Web / In-Memory Mock Store for Flutter Web ---
  static final List<Map<String, dynamic>> _webItems = [
    {
      'id': 1,
      'name': 'Pistachio Delight',
      'price': 200.0,
      'description': 'Rich layered pistachio dessert with roasted nuts and sweet cream',
      'category': 'Special',
      'imagePath': 'assets/images/item_pistachio_delight.jpg',
      'isAsset': 1
    },
    {
      'id': 2,
      'name': 'Special Green Tea',
      'price': 200.0,
      'description': 'Warm traditional pink Kashmiri green tea topped with crushed pistachios & almonds',
      'category': 'Special',
      'imagePath': 'assets/images/item_special_green_tea.jpg',
      'isAsset': 1
    },
    {
      'id': 3,
      'name': 'Mango Delight',
      'price': 200.0,
      'description': 'Layered fresh mango puree, cream, and crunchy biscuit crumble',
      'category': 'Cup',
      'imagePath': 'assets/images/item_mango_delight.jpg',
      'isAsset': 1
    },
    {
      'id': 4,
      'name': 'Fresh Fruit Cup',
      'price': 200.0,
      'description': 'Crisp layers of kiwi, pomegranate, banana, papaya, grapes and dates',
      'category': 'Cup',
      'imagePath': 'assets/images/item_fresh_fruit_cup.jpg',
      'isAsset': 1
    },
  ];

  static final List<Map<String, dynamic>> _webOrders = [];
  static final List<Map<String, dynamic>> _webOrderItems = [];
  static int _nextItemId = 5;
  static int _nextOrderId = 1;
  static int _nextOrderItemId = 1;

  // --- SQLite Database for Android / Native Mobile ---
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'fruzo.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.delete('items');
          for (final s in _webItems) {
            await db.insert('items', Map<String, dynamic>.from(s));
          }
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL, price REAL NOT NULL,
      description TEXT, category TEXT,
      imagePath TEXT, isAsset INTEGER DEFAULT 1)''');

    await db.execute('''CREATE TABLE orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customerName TEXT NOT NULL, phone TEXT,
      totalPrice REAL NOT NULL, status TEXT DEFAULT 'pending',
      createdAt TEXT NOT NULL)''');

    await db.execute('''CREATE TABLE order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER NOT NULL, itemName TEXT NOT NULL,
      price REAL NOT NULL, quantity INTEGER NOT NULL,
      FOREIGN KEY (orderId) REFERENCES orders(id))''');

    for (final s in _webItems) {
      await db.insert('items', Map<String, dynamic>.from(s));
    }
  }

  // --- Items Repository Operations ---
  Future<List<Map<String, dynamic>>> queryItems() async {
    if (kIsWeb) {
      return List<Map<String, dynamic>>.from(_webItems);
    }
    final db = await database;
    return db.query('items', orderBy: 'id ASC');
  }

  Future<int> insertItem(Map<String, dynamic> data) async {
    if (kIsWeb) {
      final id = _nextItemId++;
      final item = Map<String, dynamic>.from(data);
      item['id'] = id;
      _webItems.add(item);
      return id;
    }
    final db = await database;
    return db.insert('items', data);
  }

  Future<int> updateItem(int id, Map<String, dynamic> data) async {
    if (kIsWeb) {
      final idx = _webItems.indexWhere((it) => it['id'] == id);
      if (idx >= 0) {
        final item = Map<String, dynamic>.from(data);
        item['id'] = id;
        _webItems[idx] = item;
        return 1;
      }
      return 0;
    }
    final db = await database;
    return db.update('items', data, where: 'id=?', whereArgs: [id]);
  }

  Future<int> deleteItem(int id) async {
    if (kIsWeb) {
      _webItems.removeWhere((it) => it['id'] == id);
      return 1;
    }
    final db = await database;
    return db.delete('items', where: 'id=?', whereArgs: [id]);
  }

  // --- Orders Repository Operations ---
  Future<List<Map<String, dynamic>>> queryOrders() async {
    if (kIsWeb) {
      final list = List<Map<String, dynamic>>.from(_webOrders);
      list.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
      return list;
    }
    final db = await database;
    return db.query('orders', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> queryOrdersByCustomer(String name) async {
    if (kIsWeb) {
      return _webOrders.where((o) => o['customerName'] == name).toList();
    }
    final db = await database;
    return db.query('orders', where: 'customerName=?', whereArgs: [name], orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> queryOrderItems(int orderId) async {
    if (kIsWeb) {
      return _webOrderItems.where((i) => i['orderId'] == orderId).toList();
    }
    final db = await database;
    return db.query('order_items', where: 'orderId=?', whereArgs: [orderId]);
  }

  Future<int> insertOrder(Map<String, dynamic> orderData, List<Map<String, dynamic>> itemsData) async {
    if (kIsWeb) {
      final orderId = _nextOrderId++;
      final order = Map<String, dynamic>.from(orderData);
      order['id'] = orderId;
      _webOrders.add(order);

      for (final it in itemsData) {
        final orderItem = Map<String, dynamic>.from(it);
        orderItem['id'] = _nextOrderItemId++;
        orderItem['orderId'] = orderId;
        _webOrderItems.add(orderItem);
      }
      return orderId;
    }

    final db = await database;
    final orderId = await db.insert('orders', orderData);
    for (final it in itemsData) {
      final orderItem = Map<String, dynamic>.from(it);
      orderItem['orderId'] = orderId;
      await db.insert('order_items', orderItem);
    }
    return orderId;
  }

  Future<int> updateOrderStatus(int orderId, String status) async {
    if (kIsWeb) {
      final idx = _webOrders.indexWhere((o) => o['id'] == orderId);
      if (idx >= 0) {
        _webOrders[idx]['status'] = status;
        return 1;
      }
      return 0;
    }
    final db = await database;
    return db.update('orders', {'status': status}, where: 'id=?', whereArgs: [orderId]);
  }
}
