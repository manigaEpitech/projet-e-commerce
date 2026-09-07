import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';

class ProductRepository {
  /// Simule un appel à une API ou la lecture d'un fichier JSON local
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Délai réseau simulé

    // Simulation d'une réponse brute au format JSON
    final List<Map<String, dynamic>> mockJsonResponse = [
      {
        'id': '1',
        'title': 'Valise de voyage',
        'price': 29.99,
        'category': 'Accessoires',
        'description': 'Idéale pour vos longs séjours et week-ends.',
        'imageUrl': 'assets/images/valise_voyage.jpg',
      },
      {
        'id': '2',
        'title': 'Lampe de bureau',
        'price': 49.99,
        'category': 'Électronique',
        'description': 'Éclairage LED tactile modulable à intensité variable.',
        'imageUrl': 'assets/images/lampe_bureau.jpg',
      },
      {
        'id': '3',
        'title': 'Sneakers Sport',
        'price': 79.99,
        'category': 'Sport',
        'description':
            'Confortables, légères et stylées pour la course à pied.',
        'imageUrl': 'assets/images/sneakers_sport.jpg',
      },
      {
        'id': '4',
        'title': 'Casque Audio Wireless',
        'price': 129.00,
        'category': 'Électronique',
        'description':
            'Son haute fidélité avec système de réduction active du bruit.',
        'imageUrl': 'assets/images/casque_audio.jpg',
      },
      {
        'id': '5',
        'title': 'Sac à dos étanche',
        'price': 45.50,
        'category': 'Accessoires',
        'description':
            'Résistant à l\'eau avec un compartiment renforcé pour ordinateur.',
        'imageUrl': 'assets/images/sac_dos.jpg',
      },
    ];

    return mockJsonResponse.map((json) => Product.fromJson(json)).toList();
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});
