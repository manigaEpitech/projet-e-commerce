import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_shop/models/product.dart';
import 'package:my_shop/presentation/cart_provider.dart';

void main() {
  group('Tests Unitaires - CartNotifier', () {
    late ProviderContainer container;
    late Product sampleProduct;

    setUp(() {
      // Initialisation d'un conteneur Riverpod isolé pour chaque test
      container = ProviderContainer();
      sampleProduct = Product(
        id: '1',
        title: 'Valise de voyage',
        price: 29.99,
        category: 'Accessoires',
        description: 'Test description',
        imageUrl: 'https://picsum.photos',
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Le panier doit être initialement vide', () {
      final cartState = container.read(cartProvider);
      expect(cartState.isEmpty, true);
    });

    test(
      'Ajouter un produit doit incrémenter la quantité et ajouter l\'article',
      () {
        // Ajouter une première fois
        container.read(cartProvider.notifier).addProduct(sampleProduct);
        var cartState = container.read(cartProvider);

        expect(cartState.containsKey('1'), true);
        expect(cartState['1']!.quantity, 1);

        // Ajouter une deuxième fois le même produit
        container.read(cartProvider.notifier).addProduct(sampleProduct);
        cartState = container.read(cartProvider);

        expect(cartState['1']!.quantity, 2);
        expect(cartState['1']!.totalPrice, 29.99 * 2);
      },
    );

    test('Mettre à jour la quantité à 0 doit retirer le produit du panier', () {
      container.read(cartProvider.notifier).addProduct(sampleProduct);
      container.read(cartProvider.notifier).updateQuantity('1', 0);

      final cartState = container.read(cartProvider);
      expect(cartState.containsKey('1'), false);
    });
  });
}
