import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/products_provider.dart';
import '../models/product.dart';
import '../utils/product_sort_item.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final filter = ref.watch(filterProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique High-Tech & Sport'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Section Filtres
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: filter.category,
                  items: ['Tous', 'Sport', 'Électronique', 'Accessoires']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) =>
                      ref.read(filterProvider.notifier).setCategory(val!),
                ),
                DropdownButton<ProductSort>(
                  value: filter.sort,
                  items: const [
                    DropdownMenuItem(
                      value: ProductSort.none,
                      child: Text('Pas de tri'),
                    ),
                    DropdownMenuItem(
                      value: ProductSort.priceAsc,
                      child: Text('Prix Croissant'),
                    ),
                    DropdownMenuItem(
                      value: ProductSort.priceDesc,
                      child: Text('Prix Décroissant'),
                    ),
                  ],
                  onChanged: (val) =>
                      ref.read(filterProvider.notifier).setSort(val!),
                ),
              ],
            ),
          ),
          // Liste des produits avec AsyncValue
          Expanded(
            child: productsAsync.when(
              data: (products) => ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isFav = ref
                      .watch(favoritesProvider)
                      .contains(product.id);

                  return ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                    title: Text(product.title),
                    subtitle: Text('${product.price} €'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : null,
                          ),
                          onPressed: () => ref
                              .read(favoritesProvider.notifier)
                              .toggleFavorite(product.id),
                        ),
                        // BONUS: Animation de base via l'action du bouton
                        IconButton(
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            ref.read(cartProvider.notifier).addProduct(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.title} ajouté au panier !',
                                ),
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur : $err')),
            ),
          ),
        ],
      ),
    );
  }
}
