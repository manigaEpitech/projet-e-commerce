import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/product.dart';
import '../providers/filter_provider.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                product.imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${product.price} €',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
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
