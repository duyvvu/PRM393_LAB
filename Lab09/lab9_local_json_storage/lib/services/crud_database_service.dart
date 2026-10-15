import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product_item.dart';

class CrudDatabaseService {
  static const String _fileName = 'crud_database.json';
  static const String _seedAssetPath = 'assets/data/initial_database.json';

  List<ProductItem>? _memoryFallback;

  Future<File> get _localFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<String> getFilePath() async {
    try {
      final File file = await _localFile;
      return file.path;
    } catch (_) {
      return 'in-memory/$_fileName';
    }
  }

  /// Default fallback data if assets or file system are unreachable
  List<ProductItem> _getHardcodedDefaultSeed() {
    return [
      ProductItem(
        id: 1,
        title: 'MacBook Pro 16 M3 Max',
        category: 'Laptop',
        price: 3499.0,
        quantity: 12,
        status: 'In Stock',
      ),
      ProductItem(
        id: 2,
        title: 'iPhone 16 Pro Max 256GB',
        category: 'Smartphone',
        price: 1199.0,
        quantity: 25,
        status: 'In Stock',
      ),
      ProductItem(
        id: 3,
        title: 'Sony WH-1000XM5 Wireless Headphones',
        category: 'Audio',
        price: 399.0,
        quantity: 40,
        status: 'In Stock',
      ),
    ];
  }

  /// Loads initial seed from asset or returns default list
  Future<List<ProductItem>> _loadSeedData() async {
    try {
      final String jsonStr = await rootBundle.loadString(_seedAssetPath);
      final dynamic decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Warning: Could not load seed asset: $e');
    }
    return _getHardcodedDefaultSeed();
  }

  /// Reads all items from local JSON file
  Future<List<ProductItem>> readAll() async {
    try {
      final File file = await _localFile;
      if (!await file.exists()) {
        final initialSeed = await _loadSeedData();
        await saveAll(initialSeed);
        return initialSeed;
      }

      final String content = await file.readAsString();
      if (content.trim().isEmpty) {
        return [];
      }

      final dynamic decoded = jsonDecode(content);
      if (decoded is List) {
        return decoded
            .map((item) => ProductItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('CrudDatabaseService read error: $e');
      if (_memoryFallback != null) {
        return List.from(_memoryFallback!);
      }
      _memoryFallback = await _loadSeedData();
      return List.from(_memoryFallback!);
    }
  }

  /// Saves entire list to local JSON file (auto-save)
  Future<int> saveAll(List<ProductItem> items) async {
    final list = items.map((e) => e.toJson()).toList();
    final String jsonString = const JsonEncoder.withIndent('  ').convert(list);

    try {
      final File file = await _localFile;
      await file.writeAsString(jsonString, flush: true);
      _memoryFallback = List.from(items);
      return jsonString.length;
    } catch (e) {
      debugPrint('CrudDatabaseService write error: $e');
      _memoryFallback = List.from(items);
      return jsonString.length;
    }
  }

  /// Generates the next incremental ID
  int generateNextId(List<ProductItem> items) {
    if (items.isEmpty) return 1;
    return items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  /// Adds a new product and auto-saves to JSON
  Future<List<ProductItem>> addProduct(
    List<ProductItem> currentItems, {
    required String title,
    required String category,
    required double price,
    required int quantity,
    required String status,
  }) async {
    final nextId = generateNextId(currentItems);
    final newItem = ProductItem(
      id: nextId,
      title: title,
      category: category,
      price: price,
      quantity: quantity,
      status: status,
    );

    final updated = [newItem, ...currentItems];
    await saveAll(updated);
    return updated;
  }

  /// Updates an existing product and auto-saves to JSON
  Future<List<ProductItem>> updateProduct(
    List<ProductItem> currentItems,
    ProductItem updatedItem,
  ) async {
    final index = currentItems.indexWhere((e) => e.id == updatedItem.id);
    if (index != -1) {
      final updatedList = List<ProductItem>.from(currentItems);
      updatedList[index] = updatedItem;
      await saveAll(updatedList);
      return updatedList;
    }
    return currentItems;
  }

  /// Deletes a product and auto-saves to JSON
  Future<List<ProductItem>> deleteProduct(
    List<ProductItem> currentItems,
    int id,
  ) async {
    final updatedList = List<ProductItem>.from(currentItems)
      ..removeWhere((e) => e.id == id);
    await saveAll(updatedList);
    return updatedList;
  }

  /// Resets database back to seed template
  Future<List<ProductItem>> resetDatabase() async {
    final initialSeed = await _loadSeedData();
    await saveAll(initialSeed);
    return initialSeed;
  }

  /// Exports current JSON formatted string for preview
  Future<String> exportRawJson(List<ProductItem> items) async {
    final list = items.map((e) => e.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }
}
