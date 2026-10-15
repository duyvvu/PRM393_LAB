class ProductItem {
  final int id;
  final String title;
  final String category;
  final double price;
  final int quantity;
  final String status;

  ProductItem({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.quantity,
    this.status = 'In Stock',
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      status: json['status'] as String? ?? 'In Stock',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'quantity': quantity,
      'status': status,
    };
  }

  ProductItem copyWith({
    int? id,
    String? title,
    String? category,
    double? price,
    int? quantity,
    String? status,
  }) {
    return ProductItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
    );
  }
}
