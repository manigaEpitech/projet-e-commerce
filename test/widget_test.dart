import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop/data/product_repository.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/screens/catalog_screen.dart';

// Un dépôt factice créé spécialement pour les tests (Mock)
class FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> fetchProducts() async {
    return [
      Product(
        id: '99',
        title: 'Produit Test UI',
        price: 10.00,
        category: 'Sport',
        description: 'Test UI description',
        imageUrl: 'https://picsum.photos',
      ),
    ];
  }
}

void main() {
  group('Tests d\'Interface - CatalogScreen', () {
    testWidgets(
      'Doit afficher un indicateur de chargement puis la liste des produits',
      (WidgetTester tester) async {
        // Charger le widget dans un environnement de test Riverpod
        // en remplaçant le dépôt réel par notre dépôt factice accéléré
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              productRepositoryProvider.overrideWithValue(
                FakeProductRepository(),
              ),
            ],
            child: const MaterialApp(home: CatalogScreen()),
          ),
        );

        // 1. Vérifier que l'indicateur de progression s'affiche immédiatement (état Loading de AsyncValue)
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Lancer le rafraîchissement des frames pour résoudre le Future asynchrone
        await tester.pumpAndSettle();

        // 2. Vérifier que le chargement a disparu et que les données du dépôt factice sont visibles
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Produit Test UI'), findsOneWidget);
        expect(find.text('10.00 €'), findsOneWidget);
      },
    );

    testWidgets(
      'Ajouter un produit doit mettre à jour le compteur du panier dans l\'AppBar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              productRepositoryProvider.overrideWithValue(
                FakeProductRepository(),
              ),
            ],
            child: const MaterialApp(home: CatalogScreen()),
          ),
        );

        await tester.pumpAndSettle();

        // Au départ, aucun badge rouge avec le chiffre '1' ne doit être présent
        expect(find.text('1'), findsNothing);

        // Simuler un clic sur le bouton d'ajout au panier (icône add_shopping_cart)
        final BuildContext context = tester.element(find.byType(CatalogScreen));
        await tester.tap(find.byIcon(Icons.add_shopping_cart));
        await tester
            .pumpAndSettle(); // Gérer l'affichage de la SnackBar et la mise à jour d'état

        // Vérifier que le badge du panier affiche désormais '1' dans le Stack de l'AppBar
        expect(find.text('1'), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );
  });
}
