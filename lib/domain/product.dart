import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String title;
  final double price;
  final String category;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      price: (json['price'] as num? ?? 0.0).toDouble(),
      category: (json['category'] ?? 'Tous') as String,
      description: (json['description'] ?? '') as String,
      imageUrl: (json['imageUrl'] ?? '') as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price &&
          category == other.category &&
          imageUrl == other.imageUrl &&
          description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      price.hashCode ^
      category.hashCode ^
      imageUrl.hashCode ^
      description.hashCode;
}

@immutable
class CartItem {
  final Product product;
  final int quantity;
  final double totalPrice;

  CartItem({required this.product, this.quantity = 1})
    : totalPrice = product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          quantity == other.quantity;

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}
