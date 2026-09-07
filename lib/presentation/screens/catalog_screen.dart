import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop/domain/product.dart';
import '../../utils/product_sort_item.dart';
import '../providers/filter_provider.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique High-Tech'),
        actions: const [_ProfileButton(), _CartButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  key: const Key('categoryDropdown'),
                  value: filter.category,
                  items: const ['Tous', 'Sport', 'Électronique', 'Accessoires']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) =>
                      ref.read(filterProvider.notifier).setCategory(val!),
                ),
                DropdownButton<ProductSort>(
                  key: const Key('sortDropdown'),
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
                    DropdownMenuItem(
                      value: ProductSort.nameAsc,
                      child: Text('Nom (A-Z)'),
                    ),
                    DropdownMenuItem(
                      value: ProductSort.nameDesc,
                      child: Text('Nom (Z-A)'),
                    ),
                  ],
                  onChanged: (val) =>
                      ref.read(filterProvider.notifier).setSort(val!),
                ),
              ],
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('Aucun article trouvé.'));
                }
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final isFav = ref
                        .watch(favoritesProvider)
                        .contains(product.id);

                    return ListTile(
                      leading: Image.asset(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image),
                      ),
                      title: Text(product.title),
                      subtitle: Text('${product.price.toStringAsFixed(2)} €'),
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
                          _ScaleAddToCartButton(product: product),
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
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Erreur de chargement : $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleAddToCartButton extends StatefulWidget {
  final Product product;
  const _ScaleAddToCartButton({required this.product});

  @override
  State<_ScaleAddToCartButton> createState() => _ScaleAddToCartButtonState();
}

class _ScaleAddToCartButtonState extends State<_ScaleAddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ScaleTransition(
          scale: _animation,
          child: IconButton(
            icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
            onPressed: () async {
              ref.read(cartProvider.notifier).addProduct(widget.product);
              await _controller.forward();
              await _controller.reverse();
            },
          ),
        );
      },
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      ),
    );
  }
}

class _CartButton extends ConsumerWidget {
  const _CartButton();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Stack(
      alignment: Alignment.center,
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
            right: 4,
            top: 4,
            child: CircleAvatar(
              radius: 7,
              backgroundImage: Image.asset('assets/images/profile.png').image,
              child: Text(
                '${cart.length}',
                style: const TextStyle(fontSize: 9, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
