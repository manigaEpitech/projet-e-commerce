import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return [
      Product(
        id: '1',
        title: 'Valise de voyage',
        price: 29.99,
        category: 'Bagages',
        description: 'Description for Product 1',
        imageUrl: 'https://example.com/product1.jpg',
      ),
      Product(
        id: '2',
        title: 'Lampe de bureau',
        price: 49.99,
        category: 'Éclairage',
        description: 'Description for Product 2',
        imageUrl: 'https://example.com/product2.jpg',
      ),
      Product(
        id: '3',
        title: 'Sneakers Sport',
        price: 79.99,
        category: 'Chaussures',
        imageUrl: 'https://picsum.photos',
        description: 'Confortables et stylées.',
      ),
      Product(
        id: '4',
        title: 'Casque Audio',
        price: 129.00,
        category: 'Électronique',
        imageUrl: 'https://picsum.photos',
        description: 'Son haute fidélité.',
      ),
      Product(
        id: '5',
        title: 'Sac à dos',
        price: 45.50,
        category: 'Accessoires',
        imageUrl: 'https://picsum.photos',
        description: 'Résistant à l\'eau.',
      ),
      // Add more products as needed
    ];
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});
