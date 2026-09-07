import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<Map<String, dynamic>> mockJsonResponse = [
      {
        'id': '1',
        'title': 'Valise de voyage',
        'price': 29.99,
        'category': 'Accessoires',
        'description': 'Idéale pour vos longs séjours.',
        'imageUrl': 'assets/images/valise_voyage.jpg',
      },
      {
        'id': '2',
        'title': 'Lampe de bureau',
        'price': 49.99,
        'category': 'Électronique',
        'description': 'Éclairage LED tactile modulable.',
        'imageUrl': 'assets/images/lampe_de_bureau.jpg',
      },
      {
        'id': '3',
        'title': 'Sneakers Sport',
        'price': 79.99,
        'category': 'Sport',
        'description': 'Confortables pour la course.',
        'imageUrl': 'assets/images/sneaker_sports.jpg',
      },

      {
        'id': '4',
        'title': 'Montre connectée',
        'price': 199.99,
        'category': 'Électronique',
        'description': 'Suivi de santé et notifications.',
        'imageUrl': 'assets/images/casque_audio.jpg',
      },
      {
        'id': '5',
        'title': 'Sac à dos randonnée',
        'price': 59.99,
        'category': 'Sport',
        'description': 'Résistant et confortable.',
        'imageUrl': 'assets/images/sack_a_dos.jpg',
      },
    ];
    return mockJsonResponse.map((json) => Product.fromJson(json)).toList();
  }
}

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(),
);
