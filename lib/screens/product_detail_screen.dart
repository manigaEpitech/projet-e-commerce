import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop/presentation/cart_provider.dart';
import '../presentation/products_provider.dart';
import '../models/product.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.imageUrl, height: 200),
            const SizedBox(height: 20),
            Text(
              '${product.price} €',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 20),
            Text(product.description),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Ajouter au panier'),
              onPressed: () =>
                  ref.read(cartProvider.notifier).addProduct(product),
            ),
          ],
        ),
      ),
    );
  }
}
