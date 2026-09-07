import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop/screens/catalog_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_shop/data/local_storage_service.dart';
import 'package:my_shop/data/product_repository.dart';
import 'package:my_shop/domain/product.dart';


// Dépôt de données factice accéléré pour le test UI
class FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> fetchProducts() async {
    return [
      Product(
        id: '10',
        title: 'Chaussures de running',
        price: 89.99,
        category: 'Sport',
        description: 'Baskets confortables.',
        imageUrl: 'https://picsum.photos',
      ),
    ];
  }
}

void main() {
  group('Tests d\'Interface - CatalogScreen complets', () {
    late LocalStorageService localService;

    setUp(() async {
      // Initialise le mock de SharedPreferences pour l'UI
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      localService = LocalStorageService(prefs);
    });

    testWidgets('Doit basculer l\'état visuel du bouton favori lors d\'un clic', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(FakeProductRepository()),
            localStorageServiceProvider.overrideWithValue(localService),
          ],
          child: const MaterialApp(
            home: CatalogScreen(),
          ),
        ),
      );

      // Attendre la résolution du chargement asynchrone des produits
      await tester.pumpAndSettle();

      // Au départ, l'icône favorite_border (non sélectionné) doit être présente
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Simuler le tap sur le bouton favori
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      // Désormais, l'icône favorite (remplie) doit être visible à l'écran
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
